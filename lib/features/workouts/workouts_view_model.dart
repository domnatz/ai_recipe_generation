import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../services/firestore.dart';
import '../workouts/workouts_model.dart';

class SavedworkoutsViewModel extends ChangeNotifier {
  List<workout> workouts = [];

  final workoutPath = '/workouts';
  final firestore = FirebaseFirestore.instance;

  SavedworkoutsViewModel() {
    firestore.collection(workoutPath).snapshots().listen((querySnapshot) {
      workouts = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return workout.fromFirestore(data);
      }).toList();
      notifyListeners();
    });
  }

  void deleteworkout(workout workout) {
    FirestoreService.deleteworkout(workout);
  }

  void updateworkout(workout workout) {
    FirestoreService.updateworkout(workout);
    notifyListeners();
  }
}
