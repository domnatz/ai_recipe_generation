import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/workouts/workouts_model.dart';

const workoutPath = '/workouts';
final firestore = FirebaseFirestore.instance;

class FirestoreService {
  static Future<Null> saveworkout(Workout workout) async {
    await firestore
        .collection(workoutPath)
        .doc(workout.id)
        .set(workout.toFirestore());
  }

  static Future<Null> deleteworkout(Workout workout) async {
    await firestore.doc("$workoutPath/${workout.id}").delete();
  }

  static Future<Null> updateworkout(Workout workout) async {
    await firestore
        .doc("$workoutPath/${workout.id}")
        .update(workout.toFirestore());
  }
}
