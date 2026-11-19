import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../sessions/data/database/app_database.dart';
import '../../domain/services/data_migration_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final dataMigrationServiceProvider = Provider<DataMigrationService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final firestore = FirebaseFirestore.instance;
  return DataMigrationService(db, firestore);
});

final migrationStateProvider = NotifierProvider<MigrationStateNotifier, MigrationState>(() {
  return MigrationStateNotifier();
});

class MigrationStateNotifier extends Notifier<MigrationState> {
  @override
  MigrationState build() => MigrationState.initial();

  Future<void> checkForGuestData(String userId) async {
    state = MigrationState.checking();

    try {
      final service = ref.read(dataMigrationServiceProvider);
      final guestStatus = await service.checkGuestData();
      final hasCloud = await service.hasCloudData(userId);

      if (guestStatus.hasGuestData) {
        state = MigrationState.promptNeeded(
          guestData: guestStatus,
          hasCloudData: hasCloud,
        );
      } else {
        state = MigrationState.noGuestData();
      }
    } catch (e) {
      state = MigrationState.error(e.toString());
    }
  }

  void dismissPrompt() {
    state = MigrationState.dismissed();
  }

  Future<void> useCloudData() async {
    // Load cloud data - guest data remains untouched
    state = MigrationState.usingCloudData();
  }

  Future<void> importGuestData(String userId) async {
    state = MigrationState.importing();

    try {
      final service = ref.read(dataMigrationServiceProvider);
      final result = await service.importGuestData(userId);

      if (result.success || result.imported > 0) {
        // Mark guest records as imported (assign userId)
        await service.markGuestDataAsImported(userId);
      }

      state = MigrationState.completed(result);
    } catch (e) {
      state = MigrationState.error(e.toString());
    }
  }

  void reset() {
    state = MigrationState.initial();
  }
}

class MigrationState {
  final MigrationStatus status;
  final GuestDataStatus? guestData;
  final bool hasCloudData;
  final ImportResult? importResult;
  final String? error;

  MigrationState({
    required this.status,
    this.guestData,
    this.hasCloudData = false,
    this.importResult,
    this.error,
  });

  factory MigrationState.initial() => MigrationState(status: MigrationStatus.initial);
  factory MigrationState.checking() => MigrationState(status: MigrationStatus.checking);
  factory MigrationState.noGuestData() => MigrationState(status: MigrationStatus.noGuestData);
  factory MigrationState.promptNeeded({
    required GuestDataStatus guestData,
    required bool hasCloudData,
  }) => MigrationState(
        status: MigrationStatus.promptNeeded,
        guestData: guestData,
        hasCloudData: hasCloudData,
      );
  factory MigrationState.dismissed() => MigrationState(status: MigrationStatus.dismissed);
  factory MigrationState.importing() => MigrationState(status: MigrationStatus.importing);
  factory MigrationState.usingCloudData() => MigrationState(status: MigrationStatus.usingCloudData);
  factory MigrationState.completed(ImportResult result) => MigrationState(
        status: MigrationStatus.completed,
        importResult: result,
      );
  factory MigrationState.error(String error) => MigrationState(
        status: MigrationStatus.error,
        error: error,
      );
}

enum MigrationStatus {
  initial,
  checking,
  noGuestData,
  promptNeeded,
  dismissed,
  importing,
  usingCloudData,
  completed,
  error,
}
