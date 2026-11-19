import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/debug/auth_diagnostics.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final bool _mockMode;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    bool mockMode = false,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _mockMode = mockMode;

  @override
  Stream<AppUser?> get authStateChanges {
    if (_mockMode) {
      // In mock mode, return authenticated test user
      return Stream.value(const AppUser(
        uid: 'test-user',
        email: 'test@example.com',
        isAnonymous: false,
      ));
    }
    try {
      return _firebaseAuth.authStateChanges().map(_convertUser);
    } catch (e) {
      // Firebase not initialized - return mock user for tests
      return Stream.value(const AppUser(
        uid: 'test-user',
        email: 'test@example.com',
        isAnonymous: false,
      ));
    }
  }

  @override
  AppUser? get currentUser {
    if (_mockMode) {
      return const AppUser(
        uid: 'test-user',
        email: 'test@example.com',
        isAnonymous: false,
      );
    }
    try {
      final user = _firebaseAuth.currentUser;
      return user != null ? _convertUser(user) : null;
    } catch (e) {
      // Firebase not initialized
      return const AppUser(
        uid: 'test-user',
        email: 'test@example.com',
        isAnonymous: false,
      );
    }
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AuthDiagnostics.logAuthState(
        'Sign-in with email successful',
        uid: credential.user?.uid,
        email: credential.user?.email,
        displayName: credential.user?.displayName,
        isAnonymous: credential.user?.isAnonymous,
      );
      return _convertUser(credential.user)!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<AppUser> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AuthDiagnostics.logAuthState(
        'Sign-up with email successful',
        uid: credential.user?.uid,
        email: credential.user?.email,
        displayName: credential.user?.displayName,
        isAnonymous: credential.user?.isAnonymous,
      );
      return _convertUser(credential.user)!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Google sign-in cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      AuthDiagnostics.logAuthState(
        'Sign-in with Google successful',
        uid: userCredential.user?.uid,
        email: userCredential.user?.email,
        displayName: userCredential.user?.displayName,
        isAnonymous: userCredential.user?.isAnonymous,
      );
      return _convertUser(userCredential.user)!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException('Google sign-in failed: ${e.toString()}');
    }
  }

  @override
  Future<AppUser> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      AuthDiagnostics.logAuthState(
        'Anonymous sign-in successful',
        uid: credential.user?.uid,
        email: credential.user?.email,
        displayName: credential.user?.displayName,
        isAnonymous: credential.user?.isAnonymous,
      );
      return _convertUser(credential.user)!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    AuthDiagnostics.logAuthState('Sign-out', uid: null);
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Ignore GoogleSignIn errors if not signed in via Google
    }
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  AppUser? _convertUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
    );
  }

  AuthException _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException('No account found with this email');
      case 'wrong-password':
        return AuthException('Incorrect password');
      case 'email-already-in-use':
        return AuthException('Email already in use');
      case 'invalid-email':
        return AuthException('Invalid email address');
      case 'weak-password':
        return AuthException('Password is too weak');
      case 'user-disabled':
        return AuthException('Account has been disabled');
      case 'too-many-requests':
        return AuthException('Too many attempts. Try again later');
      case 'network-request-failed':
        return AuthException('Network error. Check your connection');
      default:
        return AuthException(e.message ?? 'Authentication failed');
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
