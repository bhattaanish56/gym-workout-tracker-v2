# Firebase Authentication Setup Guide

This guide covers the remaining Firebase configuration steps required to enable authentication and Google Sign-In.

## Prerequisites

- Firebase project created at https://console.firebase.google.com
- Android package name: `com.gymworkouttracker.v2`

## Required Configuration Files

### 1. Android Configuration (`google-services.json`)

**Location:** `/android/app/google-services.json`

**Steps:**
1. Go to Firebase Console → Project Settings → General
2. Under "Your apps", select your Android app (or add one with package name `com.gymworkouttracker.v2`)
3. Download `google-services.json`
4. Place it in `/android/app/google-services.json`

### 2. Web Configuration (`firebase_options.dart`)

**Location:** `/lib/firebase_options.dart`

**Steps:**
1. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
2. Run: `flutterfire configure`
3. Select your Firebase project
4. Select Android and Web platforms
5. This generates `lib/firebase_options.dart` automatically

**OR manually create the file:**

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('DefaultFirebaseOptions not configured for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.gymworkouttracker.v2',
  );
}
```

## Firebase Console Configuration

### 1. Enable Authentication Providers

1. Go to Firebase Console → Authentication → Sign-in method
2. Enable **Email/Password** provider
3. Enable **Google** provider
4. For Google provider, configure support email

### 2. Configure Google Sign-In for Android

**Get SHA-1 Certificate Fingerprint:**

Debug certificate:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Release certificate (if you have one):
```bash
keytool -list -v -keystore /path/to/your/keystore -alias your-alias
```

**Add SHA-1 to Firebase:**
1. Firebase Console → Project Settings → Your Android app
2. Add SHA-1 certificate fingerprint
3. Download updated `google-services.json` and replace the old one

### 3. Configure Google Sign-In for Web

1. Firebase Console → Authentication → Sign-in method → Google
2. Note your Web client ID (starts with numbers, ends with `.apps.googleusercontent.com`)
3. Add authorized domains if needed (localhost is enabled by default)

## Update main.dart

If not already done, update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}
```

## Testing Authentication

### Test Email/Password
1. Launch app → Welcome screen appears
2. Tap "Sign up" → Create account with email/password
3. Verify user can access Home screen
4. Sign out → Redirected to Welcome screen
5. Sign in with same credentials

### Test Google Sign-In
1. Welcome screen → Tap "Continue with Google"
2. Select Google account
3. Verify user can access Home screen
4. Profile screen shows Google avatar and email

### Test Guest Mode
1. Welcome screen → Tap "Continue as Guest"
2. Verify user can access Home screen and workout features
3. Profile screen shows "Guest Account"
4. Sign out returns to Welcome screen

### Test Session Persistence
1. Sign in with any method
2. Close app completely
3. Reopen app
4. Verify user remains signed in and lands on Home screen

## Common Issues

### Android Build Fails with "google-services.json not found"
- Ensure `google-services.json` is in `/android/app/`
- Check filename is exactly `google-services.json`
- Run `flutter clean` and rebuild

### Google Sign-In Returns Error on Android
- Verify SHA-1 fingerprint is added to Firebase Console
- Verify package name matches: `com.gymworkouttracker.v2`
- Download updated `google-services.json` after adding SHA-1

### Firebase Not Initialized Error
- Ensure `firebase_options.dart` exists in `/lib/`
- Check `Firebase.initializeApp()` is called in `main()` before `runApp()`
- Verify API keys are correct

### Web OAuth Error
- Check authorized domains in Firebase Console → Authentication → Settings
- For local dev, `localhost` should be in authorized domains

## Verification Checklist

- [ ] `google-services.json` in `/android/app/`
- [ ] `firebase_options.dart` in `/lib/`
- [ ] Email/Password provider enabled in Firebase Console
- [ ] Google provider enabled in Firebase Console
- [ ] SHA-1 fingerprint added for Android (debug and release)
- [ ] App builds successfully on Android
- [ ] Email sign-up works
- [ ] Email sign-in works
- [ ] Google Sign-In works
- [ ] Guest mode works
- [ ] Sign out works
- [ ] Session persists after app restart
- [ ] Password reset email sends

## Next Steps

Once Firebase is configured:
1. Test all auth flows thoroughly
2. Consider adding email verification (optional)
3. Implement Firestore workout sync (future feature)
4. Add production release signing configuration
