# Dependencies

Gym Workout Tracker V2 dependency manifest for DEV-003 milestone.

## Status Summary

- **Core packages (5):** RESOLVED (flutter pub get completed)
- **Firebase packages (3):** RESOLVED (supervisor pub get completed)
- **ProviderScope:** Configured in lib/main.dart
- **Feature providers:** Not implemented
- **GoRouter routes:** Not configured
- **Drift database:** Not configured
- **Firebase backend:** Not configured (Dart packages alone do not configure a backend)

## Regular Dependencies

### UI Framework
- **cupertino_icons** ^1.0.8 (RESOLVED)
  - iOS-style icon assets
  - https://pub.dev/packages/cupertino_icons

### State Management
- **flutter_riverpod** ^3.5.0 (RESOLVED)
  - Declarative reactive state management
  - Root ProviderScope exists; feature providers pending
  - https://pub.dev/packages/flutter_riverpod

### Navigation
- **go_router** ^18.1.4 (RESOLVED)
  - Declarative routing with deep linking support
  - Route configuration pending
  - https://pub.dev/packages/go_router

### Local Database
- **drift** ^2.35.4 (RESOLVED)
  - Type-safe SQLite persistence
  - Database schema and tables not yet defined
  - https://pub.dev/packages/drift

- **drift_flutter** ^0.3.1 (RESOLVED)
  - Flutter platform integration for Drift
  - Web persistence and browser runtime unverified
  - https://pub.dev/packages/drift_flutter

### Platform Utilities
- **path_provider** ^2.1.6 (RESOLVED)
  - Platform-specific directory paths
  - Intended for future local database file placement; not used yet
  - https://pub.dev/packages/path_provider

### Backend Services
- **firebase_core** ^5.2.0 (RESOLVED)
  - Firebase SDK initialization and configuration
  - No Firebase.initializeApp() call exists
  - No Firebase project selected or configured
  - https://pub.dev/packages/firebase_core

- **firebase_auth** ^7.1.0 (RESOLVED)
  - User authentication and session management
  - No auth UI or authentication flow implemented
  - https://pub.dev/packages/firebase_auth

- **cloud_firestore** ^7.2.0 (RESOLVED)
  - Cloud NoSQL database client
  - No Firestore schema, security rules, or data operations implemented
  - https://pub.dev/packages/cloud_firestore

## Dev Dependencies

- **flutter_lints** ^6.0.0 (RESOLVED)
  - Recommended Dart/Flutter linting rules
  - https://pub.dev/packages/flutter_lints

## SDK Constraints

- **Dart SDK:** ^3.12.2
- **Flutter SDK:** 3.44.6 stable (current project toolchain)

## Platform Minimums

- **Android:** Generated Flutter platform defaults; native build not yet verified
- **iOS:** iOS 15+ (documented minimum; native build unverified on Windows dev environment)
- **Web:** Build verified before this change; real browser runtime remains unverified
- **Windows desktop:** Not a project target

## Known Build Blockers

- **Android build:** Required SDK components installed; guarded build stopped at its free-space reserve
- **iOS native builds:** Require macOS; untested from Windows
- **Web database persistence:** Unverified in production browser environments

## References

- Firebase Flutter Setup: https://firebase.google.com/docs/flutter/setup
- Official package registry: https://pub.dev

## Notes

- Firebase Dart packages resolved; native platform compilation remains unverified
- No flutterfire configure execution performed
- No Firebase project credentials, analytics, or production access configured
- Full DEV-003 milestone completion not claimed
- Dart plugin resolution does not establish native SDK installation or backend configuration
- drift_dev/build_runner and Web database worker/WASM setup are deferred to the database task

---

**Last Updated:** 2026-11-17
**Document Version:** DEV-003
