# Architecture Overview

## Project Structure

Gym Workout Tracker V2 uses **feature-first layered architecture** with clear separation of concerns.

### Core Principles

1. **Feature-First Organization:** Code organized by feature/domain, not technical layer
2. **Separation of Concerns:** Clear boundaries between UI, business logic, and data
3. **Dependency Inversion:** Core logic independent of external frameworks
4. **Testability:** Each layer independently testable

### Planned Directory Structure

```
lib/
├── main.dart                    # Application entry point
├── app/                         # App-level configuration
│   ├── router.dart             # GoRouter navigation (TBD)
│   ├── theme.dart              # Dark-first design system (TBD)
│   └── providers.dart          # Root Riverpod providers (TBD)
├── features/                    # Feature modules
│   ├── home/                   # Dashboard feature
│   ├── workouts/               # Workout logging feature
│   ├── exercises/              # Exercise catalog feature
│   ├── progress/               # Progress tracking feature
│   └── nutrition/              # Nutrition tracking feature
├── shared/                      # Shared utilities
│   ├── widgets/                # Reusable UI components
│   ├── models/                 # Shared data models
│   └── utils/                  # Helper functions
└── core/                        # Core infrastructure
    ├── database/               # Drift/SQLite setup (TBD)
    ├── auth/                   # Firebase Auth (TBD)
    └── api/                    # Firestore integration (TBD)
```

### Feature Module Structure

Each feature follows consistent internal organization:

```
feature_name/
├── presentation/               # UI layer
│   ├── screens/               # Screen widgets
│   ├── widgets/               # Feature-specific widgets
│   └── providers/             # Riverpod state providers
├── domain/                     # Business logic
│   ├── models/                # Domain entities
│   ├── repositories/          # Abstract repository interfaces
│   └── usecases/              # Business operations (optional)
└── data/                       # Data layer
    ├── models/                # Data transfer objects
    ├── repositories/          # Repository implementations
    └── datasources/           # Local/remote data sources
```

## Technology Stack

### State Management: Riverpod

- **Provider types:** StateNotifierProvider, FutureProvider, StreamProvider
- **State holders:** StateNotifier, AsyncValue
- **Scope:** Feature-level providers, app-level root providers

### Navigation: GoRouter

- **Routes:** Declarative route definitions
- **Deep linking:** Web URL support
- **Guards:** Authentication route protection

### Local Persistence: Drift/SQLite

- **Database:** Type-safe SQL with Drift
- **Migrations:** Version-controlled schema changes
- **Queries:** Reactive streams, complex joins

### Backend: Firebase

- **Authentication:** Email/password, social providers
- **Firestore:** Cloud data sync, offline support
- **Structure:** User-scoped collections, security rules

## Design System

### Theme

- **Mode:** Dark-first design
- **Colors:** Material 3 dynamic color scheme
- **Typography:** Platform-appropriate font scales
- **Components:** Custom theme extensions

### Responsive Design

- **Breakpoints:** Mobile-first, adaptive layouts
- **Android:** Primary target, optimized experience
- **Web:** Responsive grid, desktop-friendly navigation
- **iOS:** Platform conventions (future)

## Testing Strategy

### Unit Tests

- Domain models and business logic
- Repository implementations
- Utility functions

### Widget Tests

- Individual widgets and screens
- User interactions
- State transitions

### Integration Tests

- End-to-end user flows
- Database operations
- Navigation paths

## Development Phases

### Phase 1: Foundation (Current)

- [x] Fresh Flutter project
- [ ] Core app structure
- [ ] Design system
- [ ] Navigation setup

### Phase 2: Features (TBD)

- [ ] Authentication
- [ ] Exercise catalog
- [ ] Workout logging
- [ ] Progress tracking
- [ ] Nutrition tracking

### Phase 3: Enhancement (TBD)

- [ ] Offline support
- [ ] Cloud sync
- [ ] Analytics
- [ ] Notifications

## Code Conventions

- **Formatting:** `dart format` default rules
- **Linting:** `analysis_options.yaml` strict configuration
- **Naming:** Descriptive, feature-prefixed for clarity
- **Documentation:** Public APIs documented, complex logic commented

## Build Variants

- **Debug:** Development, hot reload enabled
- **Profile:** Performance testing
- **Release:** Production builds, obfuscated

## CI/CD (Future)

- Automated testing on PR
- Static analysis enforcement
- Build verification
- Deployment automation

---

**Last Updated:** 2026-11-16  
**Status:** Foundation phase, architecture defined
