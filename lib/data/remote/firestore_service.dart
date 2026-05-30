import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _tasksRef(String uid) =>
      _db.collection('users').doc(uid).collection('tasks');

  Future<void> uploadTask(Task task) async {
    await _tasksRef(task.uid).doc(task.id).set(task.toMap());
  }

  Future<Task?> fetchTask(String uid, String taskId) async {
    final doc = await _tasksRef(uid).doc(taskId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Task.fromMap(doc.data()!);
  }

  Future<List<Task>> fetchAllTasks(String uid) async {
    final snapshot = await _tasksRef(uid).get();
    return snapshot.docs
        .map((doc) => Task.fromMap(doc.data()))
        .toList();
  }

  Future<void> deleteTask(String uid, String taskId) async {
    await _tasksRef(uid).doc(taskId).delete();
  }
}
