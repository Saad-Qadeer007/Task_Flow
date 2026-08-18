import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_flow/Models/Task_Model.dart';

class FirebaseServices {
  Future<void> addTaskToFirebase(TaskModel model) async {
    Map<String, dynamic> data = TaskModel.toMap(model);
    try {
      final document = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("tasks")
          .add(data);
      await document.update({"id": document.id});
    } catch (e) {
      print(e);
    }
    print("Task Added Successfully");
  }

  Future<QuerySnapshot> getTasksFromFirebase() async {
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tasks")
        .get();
    return data;
  }


}
