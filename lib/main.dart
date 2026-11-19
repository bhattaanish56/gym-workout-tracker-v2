import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';

export 'app/app.dart' show MyApp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase - requires firebase_options.dart
  // Generate with: flutterfire configure
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('Run: flutterfire configure OR add firebase_options.dart manually');
  }

  runApp(const ProviderScope(child: MyApp()));
}
