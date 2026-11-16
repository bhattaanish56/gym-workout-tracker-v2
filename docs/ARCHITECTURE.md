# Architecture Overview

Gym Workout Tracker V2 uses feature-first layered architecture with clear separation of concerns.

**Note:** Full compliance with GWT-V2-ARCH-001, GWT-V2-DEV-001, and final UX specifications remains unverified as complete documents are unavailable.

## Directory Structure

Only `lib/main.dart` and `lib/app/app.dart` currently exist below. All other
folders and files in these diagrams are planned; no empty placeholders are created.
The `ai_assistant` feature is future-only and is not implemented in this milestone.


```
lib/
├── main.dart                    # Entry point
├── app/                         # App-level composition and configuration
│   ├── app.dart                # Root widget (current)
│   ├── router.dart             # GoRouter navigation (planned)
│   ├── theme.dart              # Design system (planned)
│   └── providers.dart          # Root providers, dependency injection (planned)
├── core/                        # Shared domain and infrastructure
│   ├── domain/                 # Shared domain primitives, errors, value objects
│   ├── contracts/              # Repository interfaces, service contracts
│   ├── utils/                  # Pure Dart utilities
│   └── adapters/               # Platform adapters (storage, network, auth clients)
├── features/                    # Feature modules
│   ├── authentication/
│   ├── onboarding/
│   ├── home/
│   ├── programs/               # Program templates (replaces generic workouts)
│   ├── sessions/               # Workout session logging
│   ├── exercises/              # Exercise catalog and definitions
│   ├── progress/               # Progress tracking and analytics
│   ├── nutrition/              # Nutrition tracking
│   ├── profile/                # User profile management
│   └── account_data/           # Account settings and data management
└── shared/                      # Reusable presentation components
    ├── widgets/                # Cross-feature UI components
    ├── theme/                  # Theme extensions, custom styles
    └── utils/                  # UI helpers, formatters
```

### Feature Module Structure

Each feature follows internal layering:

```
feature_name/
├── presentation/               # UI layer
│   ├── screens/               # Screen widgets
│   ├── widgets/               # Feature-specific widgets
│   └── providers/             # Riverpod state management (planned)
├── application/                # Application services (optional, for complex features)
│   └── services/              # Orchestration, use cases
├── domain/                     # Business logic (pure Dart)
│   ├── models/                # Domain entities, value objects
│   └── repositories/          # Abstract repository contracts
└── data/                       # Data layer
    ├── models/                # DTOs, serialization models
    ├── repositories/          # Repository implementations
    └── datasources/           # Local (Drift) and remote (Firebase) data sources
```

Example: `lib/features/exercises/domain/models/exercise.dart`

## Dependency Rules

**Inward dependencies only:**
- presentation → application → domain ← data
- features/ → core/ (allowed)
- core/ → features/ (forbidden)
- shared/ → core/ (allowed for utilities)
- feature A → feature B (avoid; use core/ for shared domain)

**Domain layer:**
- Pure Dart, no Flutter or external framework dependencies
- Defines repository contracts (interfaces)
- Enforces business rules and invariants

**Data layer:**
- Implements repository contracts
- Uses external libraries (Drift, Firebase) and core adapters
- Handles serialization, caching, network calls

**Presentation layer:**
- Reads from repositories via providers
- Triggers actions, displays results
- Must NOT perform database writes directly
- Must NOT perform authoritative fitness calculations (e.g., 1RM formulas, calorie burns)
  - Domain defines authoritative formulas; application orchestrates their use
  - UI displays computed results

**Composition:**
- App-level (lib/app/) imports data implementations to inject into contracts
- Example: `final exerciseRepo = DriftExerciseRepository(db);`

## Technology Stack (Planned)

- **State Management:** Riverpod installed with root ProviderScope; feature providers pending
- **Navigation:** GoRouter installed; route configuration pending
- **Local Database:** Drift/SQLite packages installed; database configuration pending
- **Backend:** Firebase Core, Auth and Firestore packages installed; backend not configured
- **Platforms:** Android (primary), Web (responsive), iOS 15+ (scaffolded, requires macOS for builds)

## Core Concepts

### Repository Pattern
- Contracts in domain layer define operations
- Data layer provides implementations
- Presentation consumes via providers

### Error Handling
- Domain errors: sealed classes or enums
- Result types for operations that can fail
- Propagate to presentation for user-facing messages
- Strategy for specific error types (network, validation, auth) deferred

### Platform Adapters
- Abstract platform-specific functionality in core/adapters/
- Implementations injected at app level
- Examples: storage client, auth client, network client

### Local Persistence vs Cloud Sync
- Local-first: Drift as source of truth
- Cloud sync: background reconciliation strategy deferred
- Conflict resolution algorithm: deferred
- Offline support: deferred

## Testing Strategy

```
test/                           # Mirrors lib/ structure
├── features/
│   └── exercises/
│       ├── domain/            # Unit tests for models, business logic
│       ├── data/              # Repository implementation tests
│       └── presentation/      # Widget tests for screens and widgets
├── core/                       # Core utilities and contracts tests
└── shared/                     # Shared widget tests

integration_test/               # End-to-end tests (reserved for later)
```

**Test organization:**
- Unit tests: domain models, business logic, pure functions
- Widget tests: individual screens, widgets, user interactions
- Integration tests: full user flows, database operations, navigation (future)

## Naming Conventions

- Files: snake_case (e.g., `exercise_repository.dart`)
- Classes: PascalCase (e.g., `ExerciseRepository`)
- Variables/functions: camelCase (e.g., `fetchExercises`)
- Private members: leading underscore (e.g., `_counter`)
- Feature prefixes for clarity where needed (e.g., `ExerciseListScreen`)

## Unspecified Decisions (Deferred)

- Specific authentication providers (email/password, Google, Apple)
- Analytics integration and event tracking
- Encryption strategy for sensitive data
- GDPR compliance mechanisms
- Notification system and scheduling
- Cloud sync schedule and retry logic
- Firestore schema and security rules
- Event bus or message passing between features
- Specific metrics tracked or coverage targets

## Development Status

**Current Phase:** Foundation
- [x] Fresh Flutter project created
- [x] Initial architecture defined
- [x] App-level structure established (lib/app/app.dart)
- [ ] Dependencies added (Riverpod, GoRouter, Drift, Firebase)
- [ ] Design system implemented
- [ ] Navigation configured
- [ ] Feature development

---

**Last Updated:** 2026-11-17
**Document Version:** DEV-002
