# Gym Workout Tracker V2

Complete rewrite of the gym workout tracking application. Android-first with Web support.

## Project Status

**Foundation development in progress** — Architecture, dependency setup, Riverpod bootstrap, a provisional dark-first theme and five-section adaptive navigation are implemented. Tracking, persistence and backend behavior remain pending. Full specification compliance requires recovery of the referenced architecture and UX documents.

## Platform Support

- ✓ Android (primary)
- ✓ Web
- ⏳ iOS (prepared, requires macOS/Xcode for native builds)

## Technical Stack

- **Framework:** Flutter 3.44.6 / Dart 3.12.2
- **State Management:** Riverpod (root scope configured)
- **Navigation:** GoRouter (five branches, adaptive bottom bar / navigation rail)
- **Local Storage:** Drift/SQLite (installed; configuration pending)
- **Backend:** Firebase Core, Authentication and Firestore (packages installed; backend configuration pending)
- **Architecture:** Feature-first layered

## Planned Features

- **Home:** Dashboard, quick actions, recent activity
- **Workouts:** Log sessions, track exercises, rest timers
- **Exercises:** Catalog, search, custom exercises
- **Progress:** Charts, statistics, personal records
- **Nutrition:** Calorie tracking, meal logging

## Getting Started

### Prerequisites

- Flutter 3.44.6+
- Android SDK 36.0.0+
- Chrome (for Web)
- Git 2.54+

### Run Application

```bash
# Android
flutter run -d <device_id>

# Web
flutter run -d chrome
```

### Development Commands

```bash
# Install dependencies
flutter pub get

# Run tests
flutter test

# Static analysis
flutter analyze

# Format code
dart format .
```

## Application ID

**Android:** `com.gymworkouttracker.v2`

## Architecture

Feature-first structure with clear separation of concerns. Full architecture documentation in `docs/ARCHITECTURE.md`.

## Development Milestones

- [x] DEV-001: Initialize fresh Flutter project
- [x] DEV-002: App composition and feature-first architecture foundation
- [ ] DEV-003: Dependencies and platform validation (dependency foundation implemented)
- [ ] DEV-004: Theme and UI foundation (provisional light/dark themes verified)
- [ ] DEV-005: Navigation and app shell (provisional shell verified)
- [ ] DEV-006: Testing and CI (local checks passed; manual workflow prepared, not run remotely)

The workflow in `.github/workflows/manual-quality.yml` has only a manual trigger.
It analyzes, tests and builds a web artifact; it does not deploy or run Claude.
There is no recurring development worker. See `docs/DEVELOPMENT-HANDOFF.md` for
verified results, platform limitations and the bounded implementation process.

Current local checks: 20 widget tests passed on VM and headless Chrome, 12
supervisor tests passed, analysis and Web build passed, and an ARM64 debug APK
was built. Browser testing uses the isolated Windows tooling workaround described
in `docs/QUALITY-CHECKS.md`. Device installation/runtime remains unverified.

## License

TBD
