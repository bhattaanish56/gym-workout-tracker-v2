import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/sync_operation.dart';

class FirestoreSyncService {
  final FirebaseFirestore _firestore;
  final String userId;

  FirestoreSyncService(this._firestore, this.userId);

  Future<void> executeSyncOperation(SyncOperation operation) async {
    final collectionRef = _firestore.collection('users/$userId/${operation.collection}');

    switch (operation.operationType) {
      case SyncOperationType.create:
      case SyncOperationType.update:
        if (operation.data == null) {
          throw Exception('Data required for create/update operation');
        }
        await collectionRef.doc(operation.recordId).set(
          operation.data!,
          SetOptions(merge: true),
        );
        break;

      case SyncOperationType.delete:
        await collectionRef.doc(operation.recordId).delete();
        break;
    }
  }

  Future<void> uploadWorkout(String workoutId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users/$userId/workouts')
        .doc(workoutId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> uploadProgram(String programId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users/$userId/programs')
        .doc(programId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> uploadCustomExercise(String exerciseId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users/$userId/custom_exercises')
        .doc(exerciseId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> uploadBodyWeight(String entryId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users/$userId/bodyweight')
        .doc(entryId)
        .set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> downloadWorkout(String workoutId) async {
    final doc = await _firestore
        .collection('users/$userId/workouts')
        .doc(workoutId)
        .get();
    return doc.data();
  }

  Future<List<Map<String, dynamic>>> downloadAllWorkouts() async {
    final snapshot = await _firestore
        .collection('users/$userId/workouts')
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> downloadAllPrograms() async {
    final snapshot = await _firestore
        .collection('users/$userId/programs')
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> downloadAllCustomExercises() async {
    final snapshot = await _firestore
        .collection('users/$userId/custom_exercises')
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> downloadAllBodyWeight() async {
    final snapshot = await _firestore
        .collection('users/$userId/bodyweight')
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<Map<String, dynamic>?> downloadProfile() async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .get();
    return doc.data();
  }

  Future<void> uploadProfile(Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .set(data, SetOptions(merge: true));
  }
}
