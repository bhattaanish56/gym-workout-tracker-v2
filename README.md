# Gym Workout Tracker V2

Complete rewrite of the gym workout tracking application. Android-first with Web support.

## Project Status

**DEV-001 Complete** — Fresh Flutter project initialized.

## Platform Support

- ✓ Android (primary)
- ✓ Web
- ⏳ iOS (prepared, requires macOS/Xcode for native builds)

## Technical Stack

- **Framework:** Flutter 3.44.6 / Dart 3.12.2
- **State Management:** Riverpod (TBD in milestone)
- **Navigation:** GoRouter (TBD in milestone)
- **Local Storage:** Drift/SQLite (TBD in milestone)
- **Backend:** Firebase Authentication + Firestore (TBD in milestone)
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
- [ ] DEV-002: TBD
- [ ] Additional milestones TBD

## License

TBD
