# Gym Workout Tracker V2

Complete rewrite of the gym workout tracking application. Android-first with Web support.

## Project Status

**DEV-003 in progress** — Architecture foundation, dependency setup and Riverpod bootstrap implemented. Full specification compliance remains pending recovery of the referenced architecture and UX documents.

## Platform Support

- ✓ Android (primary)
- ✓ Web
- ⏳ iOS (prepared, requires macOS/Xcode for native builds)

## Technical Stack

- **Framework:** Flutter 3.44.6 / Dart 3.12.2
- **State Management:** Riverpod (root scope configured)
- **Navigation:** GoRouter (installed; configuration pending)
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
- [ ] Additional milestones TBD

## License

TBD
