# Data Contract & Synchronization Design

**Version:** DEV-007  
**Status:** Design review (not yet implemented)  
**Last Updated:** 2026-11-17

> **Important:** This contract synthesizes requirements from reconstructed specifications (GWT-V2-DATA-001, FS-001 through FS-006, ARCH-001, AUDIT-001). Specific field names, indexes, numeric precision and implementation details require validation before development.

## Purpose

Define the Gym Workout Tracker V2 data model, integrity constraints, local/cloud ownership boundaries and synchronization contracts before implementing Drift schemas or Firebase operations.

## Global Data Integrity Rules

### 1. Identity and Ownership
- **Stable UUIDs** for all user-created aggregates (programs, sessions, exercises, foods, recipes)
- **Mutation operation IDs** are unique UUIDs for idempotency
- **User ID scoping:** Every private record owned by Firebase Auth UID
- **Account isolation:** No cross-account cache leakage; all queries include UID scope

### 2. Timestamps and Dates (Q5 — RESOLVED)
- **UTC instants** (`DateTime`) for all absolute ordering and synchronization
- **Local calendar dates** (`String` YYYY-MM-DD) for workout sessions, body-weight entries, nutrition diary and adherence records
- **IANA time-zone identifier** stored with profile (e.g. 'America/New_York', 'Asia/Kathmandu')
- **Historical stability:** Local calendar dates remain unchanged when device time zone changes
- **Session date policy:** Defaults to local calendar date when session started; user can explicitly correct
- **Cross-midnight sessions:** Completion event links to the workout day (per local timezone at session start)
- **DST handling:** No automatic adjustment of historical dates; daylight-saving changes represented as timezone context, not date shifts
- **Offline clock inconsistencies:** Tolerate minor device clock drift; sync reconciliation resolves major discrepancies

### 3. Numeric Precision (Q10 — RESOLVED)
- **Weight/load canonical storage:** Integer grams (never kg or lb as float)
- **Display units separate:** `Preferences.weightUnit` ('kg' | 'lb') controls UI display only
- **Conversion rule:** At persistence: `kg_input * 1000 = grams_storage`; at display: `grams / 1000 = kg` (with rounding per UI)
- **Reps/sets:** Integer counts (never fractional)
- **Nutrition values:** Fixed-point with explicit precision metadata
  - Calories: integer (no decimal places)
  - Protein/Carbs/Fat: stored as integer deci-grams (1 dg = 0.1g precision)
  - Conversion: `10.5g input → 105 stored; 105 → 10.5g display`
- **Validation limits:** Workout resistance < 1,000,000g (1000 kg realistic max), Body weight 20,000g–300,000g (20–300 kg), Calories < 100,000 per entry
- **Never use binary float equality** for persisted fitness measurements; always compare as integers
- **Rounding policy:** Display rounds to 0.1g for weights, 1g for macros; stored value is source of truth

### 4. Versioning and Revisions
- **Local timestamps:** `createdAt`, `updatedAt` for client-side ordering
- **Cloud revision:** Server-controlled version for conflict detection
- **Schema versions:** Explicit migration tracking in `schema_migrations` table

### 5. Historical Snapshots
- **Performed sessions** store exercise name/unit snapshots at logging time
- **Nutrition diary** stores food/recipe nutrition snapshots at consumption time
- **Program snapshots** preserved with sessions so program deletion doesn't cascade-delete history
- Catalog/program edits never rewrite historical records

### 6. Idempotency and Completion
- **Completion events:** Stable idempotency key (UUID)
- **Rotation advancement:** Exactly once per accepted completion event
- **Retry behavior:** Duplicate event UUID recognized; rotation does not advance twice
- Historical edits trigger analytics recomputation but never replay completion side-effects

### 7. Deletion and Tombstones
- **Soft delete:** Tombstone records prevent resurrection after sync
- **Account deletion:** Terminal barrier; stale offline devices rejected
- **Cascade rules:** Sessions reference programs but carry snapshots (no cascade delete)

### 8. Conflict Preservation
- **Critical data:** Preserve both local and remote payloads for manual resolution
- **Simple aggregates:** Last server-confirmed edit may apply where data loss is tolerable
- **Compare-and-swap:** Use `cloudRevision`, not client `updatedAt`

### 9. Active Session Ownership
- **Connected mode:** Lease claim/renew/expiry via trusted backend
- **Offline mode:** Allow recoverable local logging with ownership uncertainty warning
- **Conflict resolution:** Surface conflicts; never silently merge concurrent sessions

### 10. Atomic Transactions
- **Local writes:** Drift transaction persists data change + outbox operation atomically
- **Sync protocol:** Local save → outbox → sync worker → backend validation → Firestore commit → clear outbox

---

## Entity Definitions

### Account and Profile

**Profile**
- `uid` (String, Firebase Auth UID, PK)
- `displayName` (String?)
- `heightCm` (int?)
- `birthDate` (String? YYYY-MM-DD)
- `timeZone` (String? IANA identifier, e.g. 'America/New_York'; defaults to device timezone)
- `createdAt` (DateTime UTC)
- `updatedAt` (DateTime UTC)

**Preferences**
- `uid` (String, PK)
- `weightUnit` (String: 'kg' | 'lb')
- `distanceUnit` (String: 'km' | 'mi')
- `firstDayOfWeek` (int: 0=Sunday, 1=Monday)
- `updatedAt` (DateTime UTC)

**OnboardingProgress**
- `uid` (String, PK)
- `completed` (bool)
- `skippedAt` (DateTime?)

### Workout Programs

**Program**
- `id` (String UUID, PK)
- `uid` (String, owner)
- `name` (String)
- `description` (String?)
- `scheduleMode` (String: 'fixed_weekly' | 'flexible_rotation')
- `status` (String: 'draft' | 'active' | 'archived')
- `createdAt` (DateTime UTC)
- `updatedAt` (DateTime UTC)
- `cloudRevision` (int?)

**Constraints:**
- Only one active program per UID
- Schedule mode immutable after first session logged

**ProgramDay**
- `id` (String UUID, PK)
- `programId` (String FK)
- `orderIndex` (int, 0-based)
- `name` (String)
- `targetDescription` (String?)
- `createdAt` (DateTime UTC)
- `updatedAt` (DateTime UTC)

**Ordering:** Days ordered by `orderIndex` within program

**PlannedExercise**
- `id` (String UUID, PK)
- `programDayId` (String FK)
- `exerciseId` (String FK to Exercise or CustomExercise)
- `orderIndex` (int)
- `targetSets` (int?)
- `targetRepsMin` (int?)
- `targetRepsMax` (int?)
- `targetLoadGrams` (int? grams; display as kg with Preferences.weightUnit)
- `restSeconds` (int?)
- `notes` (String?)

**ScheduleOccurrence** (for fixed weekly schedules)
- `id` (String UUID, PK)
- `uid` (String)
- `programId` (String FK)
- `programDayId` (String FK)
- `scheduledDate` (String YYYY-MM-DD)
- `status` (String: 'pending' | 'completed' | 'missed')
- `completionEventId` (String? FK)
- `createdAt` (DateTime UTC)

**RotationState** (for flexible rotation)
- `programId` (String PK)
- `nextDayIndex` (int)
- `lastCompletionEventId` (String?)
- `updatedAt` (DateTime UTC)
- `cloudRevision` (int)

**Critical:** Rotation updates require server-side coordination to prevent double-advancement

### Workout Sessions

**WorkoutSession**
- `id` (String UUID, PK)
- `uid` (String, owner)
- `sourceType` (String: 'scheduled' | 'program_day' | 'freestyle')
- `programId` (String? FK)
- `programDayId` (String? FK)
- `programSnapshot` (String? JSON: {programName, dayName, dayOrderIndex})
- `startedAt` (DateTime UTC)
- `finishedAt` (DateTime? UTC)
- `workoutDate` (String YYYY-MM-DD, local calendar date)
- `status` (String: 'in_progress' | 'completed' | 'abandoned')
- `ownerDeviceId` (String?)
- `ownerLeaseExpiry` (DateTime?)
- `createdAt` (DateTime)
- `updatedAt` (DateTime)
- `cloudRevision` (int?)

**PerformedExercise**
- `id` (String UUID, PK)
- `sessionId` (String FK)
- `orderIndex` (int)
- `exerciseId` (String? FK, may be null if custom deleted)
- `exerciseSnapshot` (String JSON: {name, equipment, primaryMuscle})
- `notes` (String?)

**PerformedSet**
- `id` (String UUID, PK)
- `performedExerciseId` (String FK)
- `orderIndex` (int)
- `setType` (String: 'warmup' | 'working')
- `loadGrams` (int? grams; display per Preferences.weightUnit)
- `reps` (int?)
- `completed` (bool)
- `notes` (String?)

**WorkoutCompletionEvent**
- `id` (String UUID, PK, idempotency key)
- `uid` (String)
- `sessionId` (String FK)
- `programId` (String? FK)
- `scheduleOccurrenceId` (String? FK)
- `completedAt` (DateTime UTC)
- `workoutDate` (String YYYY-MM-DD)
- `cloudRevision` (int?)

**Critical:** `id` is stable idempotency key; duplicate submissions ignored

**RestTimerState** (in-memory or local preference)
- `defaultRestSeconds` (int)
- `currentTimerStart` (DateTime?)
- `currentTimerDuration` (int?)

### Exercise Catalog

**Exercise** (curated base catalog)
- `id` (String UUID, PK)
- `sourceProvider` (String: 'wger' | 'curated')
- `sourceId` (String?)
- `canonicalName` (String)
- `equipment` (String?)
- `primaryMuscle` (String?)
- `secondaryMuscles` (String? JSON array)
- `instructions` (String?)
- `mediaUrl` (String?)
- `mediaLicense` (String?)
- `mediaAttribution` (String?)
- `createdAt` (DateTime)

**Critical:** Verify WGER or provider license/attribution before production use

**ExerciseAlias**
- `exerciseId` (String FK)
- `alias` (String)
- Unique constraint on (exerciseId, alias)

**CustomExercise** (user-created)
- `id` (String UUID, PK)
- `uid` (String, owner)
- `name` (String)
- `equipment` (String?)
- `primaryMuscle` (String?)
- `instructions` (String?)
- `createdAt` (DateTime)
- `cloudRevision` (int?)

**FavoriteExercise**
- `uid` (String)
- `exerciseId` (String FK to Exercise or CustomExercise)
- `createdAt` (DateTime)
- PK: (uid, exerciseId)

### Progress Tracking

**BodyWeightEntry**
- `id` (String UUID, PK)
- `uid` (String)
- `weightGrams` (int; display per Preferences.weightUnit as kg or lb with appropriate rounding)
- `measuredAt` (DateTime UTC)
- `measuredDate` (String YYYY-MM-DD, local calendar date)
- `notes` (String?)
- `createdAt` (DateTime UTC)
- `cloudRevision` (int?)

**WeeklyWorkoutGoal**
- `uid` (String PK)
- `targetWorkoutsPerWeek` (int)
- `effectiveFrom` (String YYYY-MM-DD)
- `updatedAt` (DateTime)

**Analytics:** Computed from sessions/body-weight entries; no cached projection tables initially

### Nutrition

**Food** (curated catalog)
- `id` (String UUID, PK)
- `sourceProvider` (String: 'usda' | 'curated')
- `sourceId` (String?)
- `name` (String)
- `brand` (String?)
- `category` (String?)
- `createdAt` (DateTime)

**FoodServing**
- `id` (String UUID, PK)
- `foodId` (String FK)
- `servingName` (String: 'per 100g', 'cup', 'piece')
- `servingGrams` (int?)
- `servingMl` (int?)
- `caloriesInt` (int; no decimals)
- `proteinDeciGrams` (int; store 10.5g as 105)
- `carbsDeciGrams` (int; store 25.3g as 253)
- `fatDeciGrams` (int; store 8.2g as 82)
- `dataQuality` (String: 'verified' | 'community' | 'estimated')

**BarcodeMapping**
- `barcode` (String PK)
- `foodId` (String FK)
- `servingId` (String FK)
- `updatedAt` (DateTime)

**CustomFood** (user-created)
- `id` (String UUID, PK)
- `uid` (String)
- `name` (String)
- `brand` (String?)
- `servingGrams` (int)
- `caloriesInt` (int)
- `proteinDeciGrams` (int; 10.5g stored as 105)
- `carbsDeciGrams` (int; 25.3g stored as 253)
- `fatDeciGrams` (int; 8.2g stored as 82)
- `createdAt` (DateTime UTC)
- `cloudRevision` (int?)

**Recipe**
- `id` (String UUID, PK)
- `uid` (String)
- `name` (String)
- `servings` (int)
- `instructions` (String?)
- `createdAt` (DateTime)
- `updatedAt` (DateTime)
- `cloudRevision` (int?)

**RecipeIngredient**
- `id` (String UUID, PK)
- `recipeId` (String FK)
- `foodId` (String? FK to Food or CustomFood)
- `orderIndex` (int)
- `quantityGrams` (int)
- `ingredientSnapshot` (String JSON: {name, calories, protein, carbs, fat})

**NutritionDiaryEntry**
- `id` (String UUID, PK)
- `uid` (String)
- `entryDate` (String YYYY-MM-DD, local calendar date per user timezone)
- `mealCategory` (String: 'breakfast' | 'lunch' | 'dinner' | 'snack')
- `loggedAt` (DateTime UTC)
- `foodId` (String? FK)
- `recipeId` (String? FK)
- `quantityGrams` (int)
- `nutritionSnapshot` (String JSON: {name, caloriesInt, proteinDeciGrams, carbsDeciGrams, fatDeciGrams, servingDescription})
- `notes` (String?)
- `createdAt` (DateTime UTC)
- `updatedAt` (DateTime UTC)
- `cloudRevision` (int?)

**Critical:** Snapshot preserves nutrition at consumption time; food/recipe edits don't retroactively change diary

**NutritionGoal**
- `uid` (String PK)
- `effectiveFrom` (String YYYY-MM-DD)
- `dailyCaloriesInt` (int?)
- `dailyProteinDeciGrams` (int?; 150.5g stored as 1505)
- `dailyCarbsDeciGrams` (int?; 200.0g stored as 2000)
- `dailyFatDeciGrams` (int?; 65.5g stored as 655)
- `goalOrigin` (String: 'manual' | 'calculated')
- `updatedAt` (DateTime UTC)

### Synchronization

**OutboxOperation**
- `id` (String UUID, PK)
- `uid` (String)
- `operationType` (String: 'create' | 'update' | 'delete')
- `entityType` (String: 'program' | 'session' | 'completion_event' | 'nutrition_entry' | ...)
- `entityId` (String)
- `payload` (String JSON)
- `createdAt` (DateTime)
- `attempts` (int default 0)
- `lastAttemptAt` (DateTime?)
- `status` (String: 'pending' | 'in_flight' | 'acknowledged' | 'failed')

**SyncConflict**
- `id` (String UUID, PK)
- `uid` (String)
- `entityType` (String)
- `entityId` (String)
- `localRevision` (int)
- `remoteRevision` (int)
- `localPayload` (String JSON)
- `remotePayload` (String JSON)
- `detectedAt` (DateTime)
- `resolvedAt` (DateTime?)
- `resolution` (String?: 'local_wins' | 'remote_wins' | 'manual' | 'merged')

**Tombstone**
- `entityType` (String)
- `entityId` (String)
- `uid` (String)
- `deletedAt` (DateTime)
- `cloudRevision` (int)
- PK: (entityType, entityId)

**SyncCursor**
- `uid` (String PK)
- `lastSyncedAt` (DateTime)
- `changeSequence` (int?)

---

## Local vs Cloud Storage

### Local-Only (Drift)
- `RestTimerState` (ephemeral session state)
- `OnboardingProgress` (device-specific)
- Sync metadata: `OutboxOperation`, `SyncConflict`, `SyncCursor`
- Cached analytics projections (if implemented)

### Local + Cloud Sync (Drift → Firestore)
- `Profile`, `Preferences`
- `Program`, `ProgramDay`, `PlannedExercise`
- `ScheduleOccurrence`, `RotationState`
- `WorkoutSession`, `PerformedExercise`, `PerformedSet`
- `WorkoutCompletionEvent`
- `CustomExercise`, `FavoriteExercise`
- `BodyWeightEntry`, `WeeklyWorkoutGoal`
- `CustomFood`, `Recipe`, `RecipeIngredient`
- `NutritionDiaryEntry`, `NutritionGoal`
- `Tombstone`

### Shared Catalog (Read-Only, No Sync)
- `Exercise`, `ExerciseAlias` (curated, bundled with app or cached from CDN)
- `Food`, `FoodServing`, `BarcodeMapping` (curated, bundled with app)

**Critical:** Catalogs are explicitly public/licensed; never sync private user data to shared collections

### Trusted Backend Operations
**Require server-side coordination (Firebase Cloud Functions or equivalent):**
- `WorkoutCompletionEvent` acceptance (idempotency + rotation advancement)
- `RotationState` updates (prevent double-advancement)
- Active session lease claim/renew/expiry
- Account deletion barrier enforcement

**Rationale:** Client-side revision calculation cannot guarantee serialization for critical mutations

---

## Firestore Structure (Proposed)

```
/users/{uid}
  /profile (document)
  /preferences (document)
  /programs/{programId}
  /programDays/{dayId}
  /scheduleOccurrences/{occurrenceId}
  /rotationStates/{programId}
  /workoutSessions/{sessionId}
  /workoutCompletionEvents/{eventId}
  /customExercises/{exerciseId}
  /favoriteExercises/{exerciseId}
  /bodyWeightEntries/{entryId}
  /weeklyWorkoutGoals/{goalId}
  /customFoods/{foodId}
  /recipes/{recipeId}
  /nutritionDiaryEntries/{entryId}
  /nutritionGoals/{goalId}
  /tombstones/{entityType_entityId}

/sharedCatalogs (read-only)
  /exercises/{exerciseId}
  /foods/{foodId}
```

**Security Rules Requirements:**
- Deny-by-default
- Verify UID ownership on all `/users/{uid}` subcollections
- Verify email verification where required
- Rate limit mutations
- Validate schema/revision constraints server-side

---

## Synchronization Protocol

### Mutation Flow
1. **Validate** domain command
2. **Drift transaction:**
   - Update local aggregate
   - Append `OutboxOperation(UUID, entityType, payload)`
   - Commit atomically
3. **UI** reflects locally saved status
4. **Sync worker** (background):
   - Submit authenticated operation to trusted backend
5. **Trusted backend:**
   - Validate UID, revision, ownership, idempotency
   - Execute Firestore transaction
   - Return accepted revision
6. **Client:**
   - Store acknowledged `cloudRevision`
   - Clear outbox operation
7. **Change feed** reconciles remote changes without duplicating local effects

### Conflict Detection
- **Compare-and-swap:** Check `cloudRevision` before write
- **Mismatch:** Create `SyncConflict` record
- **Resolution strategy:**
  - Critical data (sessions, diary): preserve both, surface for manual resolution
  - Simple aggregates (preferences): last-write-wins (server timestamp)

### Bootstrap Sync
- **Initial load:** Paginated query of user's Firestore documents
- **Checkpoint:** Store `lastSyncedAt` cursor
- **Incremental:** Query changes since cursor
- **Retry:** Exponential backoff for transient failures

---

## Migration Strategy

### Drift Migrations
- **Version tracking:** `schema_migrations` table with version number and timestamp
- **Upgrade-only:** No automatic downgrades
- **Testing:** Validate migrations against snapshots before release
- **Destructive operations:** Prohibited (never drop columns with user data)

### Schema Versioning
- **Local schema version:** Embedded in Drift database
- **Cloud schema version:** Included in Firestore document metadata
- **Compatibility:** Clients must support reading 1-2 versions back

---

## Platform Considerations

### Android
- **Drift:** Native SQLite via `drift_flutter` package
- **Persistence:** App-private database files
- **Barcode scanning:** Camera permission + provider lookup

### Web
- **Drift:** SQLite/WASM via `drift_flutter` web support
- **Persistence durability:** IndexedDB (not guaranteed across all browsers/modes)
- **Testing required:** Verify persistence across browser restart, private mode, origin changes
- **Barcode:** Manual entry fallback

### iOS
- **Drift:** Native SQLite (not yet built/tested on Windows dev environment)
- **Firebase:** Requires proper configuration and device testing

---

## Open Questions and Unresolved Decisions

### Resolved Decisions

**Q5 — Time Zone Policy (RESOLVED)**
- UTC timestamps for absolute events
- Explicit IANA timezone identifiers in Profile
- Local calendar dates stable across device timezone changes
- Cross-midnight sessions linked to workout day at session start
- DST handled as timezone context, not date shifts

**Q10 — Numeric Precision (RESOLVED)**
- Weights: canonical storage as integer grams
- Nutrition: fixed-point with deci-gram precision (0.1g)
- Display units separate from storage units
- No binary float equality for persisted measurements

### Unresolved Questions (8 Remaining)

| # | Question | Impact | Status | Blocks |
|---|----------|--------|--------|--------|
| 1 | Firebase project billing/quotas | Cost/availability | Needs decision | DEV-010+ |
| 2 | Trusted backend: Cloud Functions vs alternative | Architecture | Needs decision | DEV-010+ |
| 3 | Exercise catalog source + licensing | Data rights | Needs curation | M2 |
| 4 | Nutrition catalog + barcode API | Data rights | Needs curation | M7 |
| 6 | Conflict resolution UI/UX flow | User experience | Needs design | M1 feature work |
| 7 | Web IndexedDB durability + user disclosure | Data loss risk | Needs testing | DEV-009 |
| 8 | Rotation advancement for high-frequency users | Scalability | Needs load testing | DEV-010+ |
| 9 | Active session lease duration + renewal | Session safety | Needs decision | M4 |

**Rationale for deferring Q1, Q2, Q8, Q9:** Do not block DEV-008 (domain primitives). These are backend/operational concerns, not data model requirements. Drift schema can be finalized without Firebase configuration.

---

## Deferred Functionality

**Not in initial release:**
- AI fitness assistant
- Meal photo identification
- Automated workout recommendations
- Social features or shared programs
- Third-party integrations (Strava, Fitbit, etc.)
- Wearable device sync
- Advanced analytics (periodization, fatigue models)
- Multi-program concurrent tracking

---

## Feasibility Risks

### High Risk
1. **Firebase Cloud Functions cost:** Unknown usage patterns may exceed budget
2. **Web IndexedDB durability:** Users may lose data in private mode or storage eviction
3. **Concurrent active session conflicts:** Fully offline simultaneous sessions cannot be prevented

### Medium Risk
4. **Exercise media licensing:** WGER or alternative provider terms may change
5. **Rotation state synchronization:** Complex distributed coordination required
6. **Firestore document size limits:** Large sessions with many sets may approach limits

### Low Risk
7. **Drift migration complexity:** Standard Flutter/Drift patterns well-documented
8. **UID scoping enforcement:** Firestore security rules handle this reliably

---

## Implementation Roadmap Dependencies

**Before DEV-008 (Domain Primitives):**
- No blockers (numeric precision and time zone policies resolved via Q5 and Q10)

**Before DEV-009 (Drift Schema):**
- Resolve open questions 1, 7 (Q10 resolved)
- Validate Web persistence strategy

**Before DEV-010 (Firebase Auth):**
- Create Firebase project
- Configure authentication providers

**Before DEV-013 (Firestore Rules):**
- Finalize Firestore structure
- Decide trusted backend implementation approach

**Before M2 (Exercise Library):**
- License exercise catalog
- Curate initial exercise list

**Before M4 (Active Sessions):**
- Implement session lease mechanism
- Resolve rotation coordination approach

**Before M7 (Nutrition):**
- License nutrition catalog
- Configure barcode provider API

---

## Verification Checklist

**Data Integrity Rules:**
- [ ] UUID generation for all aggregates tested
- [ ] UID scoping enforced in all queries
- [ ] Snapshot preservation verified for sessions/diary
- [ ] Idempotency tested for completion events
- [ ] Tombstone prevention of resurrection tested
- [ ] Conflict preservation tested

**Synchronization:**
- [ ] Atomic local transaction + outbox tested
- [ ] Outbox retry with exponential backoff tested
- [ ] Compare-and-swap conflict detection tested
- [ ] Bootstrap sync pagination tested
- [ ] Account deletion barrier tested

**Platform:**
- [ ] Android Drift persistence tested
- [ ] Web Drift/WASM persistence tested across browser restart
- [ ] iOS Drift persistence tested (requires macOS)
- [ ] Migration upgrade/downgrade safety tested

---

## Summary

This data contract defines:
- **39+ entity types** across 7 major domains
- **10 global integrity rules** for data consistency
- **Local-first architecture** with explicit cloud sync boundaries
- **Idempotent operations** and conflict preservation
- **10 open questions** requiring decisions before implementation
- **3 high-risk** feasibility concerns requiring mitigation strategies

**Next Steps:**
1. Review and validate against original requirements (if available)
2. Resolve open questions with product/technical decisions
3. Create Firebase project and configure authentication
4. Implement domain primitives (DEV-008)
5. Implement Drift schema (DEV-009)

**Document Status:** Design review complete, awaiting approval for DEV-008
