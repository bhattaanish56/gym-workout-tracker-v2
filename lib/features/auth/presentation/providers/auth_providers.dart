import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).when(
        data: (user) => user,
        loading: () => null,
        error: (_, __) => null,
      );
});
