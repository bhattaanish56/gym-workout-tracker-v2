import 'package:flutter/foundation.dart';

class AuthDiagnostics {
  static void logAuthState(String event, {String? uid, String? email, String? displayName, bool? isAnonymous}) {
    if (!kDebugMode) return;

    debugPrint('=== AUTH DIAGNOSTIC: $event ===');
    if (uid != null) {
      debugPrint('Firebase Project: gym-workout-tracker-6ae9a');
      debugPrint('User UID: $uid');
      debugPrint('Email: ${email ?? "null"}');
      debugPrint('Display Name: ${displayName ?? "null"}');
      debugPrint('Is Anonymous: ${isAnonymous ?? false}');
    } else {
      debugPrint('User: null (signed out)');
    }
    debugPrint('===============================');
  }
}
