# Dependencies

DEV-003a dependency foundation for Gym Workout Tracker V2.

## Installed Packages

### flutter_riverpod ^3.5.0
**Purpose:** State management and dependency injection
**Status:** Resolved and installed. ProviderScope added to main.dart. Providers not yet configured.
**Reference:** https://riverpod.dev/docs/introduction/getting_started

### go_router ^18.1.4
**Purpose:** Declarative routing and navigation
**Status:** Resolved and installed. Router configuration deferred to DEV-005.
**Reference:** https://pub.dev/packages/go_router

### drift ^2.35.4
**Purpose:** Type-safe SQLite database layer
**Status:** Resolved and installed. Database schema, tables, and code generation deferred to database schema task.
**Reference:** https://drift.simonbinder.eu/setup/

### drift_flutter ^0.3.1
**Purpose:** Flutter-specific Drift utilities (native database location)
**Status:** Resolved and installed. Not yet initialized.

### path_provider ^2.1.6
**Purpose:** Platform-specific directory paths for local persistence
**Status:** Resolved and installed. Not yet used.

## Pending Configurations

- **drift_dev and build_runner:** Code generation tools deferred until database schema task
- **Web Drift runtime:** Requires worker/wasm setup and browser persistence tests in later milestone
- **Firebase plugins:** Installation and platform setup pending. Firebase Auth requires iOS 15+ minimum deployment target; project currently targets iOS 13. Compatibility decision deferred.
- **Android native runtime:** Unverified
- **iOS native runtime:** Unverified

## Platform Compatibility Notes

**iOS:** Current minimum deployment target is iOS 13. Firebase Auth documentation specifies iOS 15 minimum. Upgrading deployment target will be required when Firebase is added.

**Web:** Drift on web requires additional WASM binary and worker configuration. This is not included in DEV-003a.

## References

- Riverpod: https://riverpod.dev/docs/introduction/getting_started
- GoRouter: https://pub.dev/packages/go_router
- Drift: https://drift.simonbinder.eu/setup/
- Firebase Flutter Setup: https://firebase.google.com/docs/flutter/setup

---

**Verification:** Dependency resolution, analysis, tests, and platform builds are recorded in DEVELOPMENT-HANDOFF.md after supervisor execution.
