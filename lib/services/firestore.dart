import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/workouts/workout_model.dart';

const workoutPath = '/workouts';
final firestore = FirebaseFirestore.instance;

class FirestoreService {
  static Future<Null> saveworkout(workout workout) async {
    await firestore
        .collection(workoutPath)
        .doc(workout.id)
        .set(workout.toFirestore());
  }

  static Future<Null> deleteworkout(workout workout) async {
    await firestore.doc("$workoutPath/${workout.id}").delete();
  }

  static Future<Null> updateworkout(workout workout) async {
    await firestore
        .doc("$workoutPath/${workout.id}")
        .update(workout.toFirestore());
  }
}
