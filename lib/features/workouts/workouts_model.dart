import 'dart:convert';

import 'package:ai_workout_generation/util/json_parsing.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Workout {
  Workout({
    required this.title,
    required this.id,
    required this.description,
    required this.equipment,
    required this.instructions,
    required this.muscleGroups,
    required this.benefits,
    this.rating = -1,
  });

  final String id;
  final String title;
  final String description;
  final List<String> equipment;
  final List<String> instructions;
  final List<String> muscleGroups;
  final List<String> benefits;
  int rating;

  factory Workout.fromGeneratedContent(GenerateContentResponse content) {
    /// failures should be handled when the response is received
    assert(content.text != null);

    final validJson = cleanJson(content.text!);
    print('Valid JSON: $validJson');
    final json = jsonDecode(validJson);

    if (json
        case {
          "equipment": List<dynamic> equipment,
          "instructions": List<dynamic> instructions,
          "title": String title,
          "id": String id,
          "muscleGroups": List<dynamic> muscleGroups,
          "description": String description,
          "benefits": List<dynamic> benefits,
        }) {
      return Workout(
          id: id,
          title: title,
          equipment: equipment.map((i) => i.toString()).toList(),
          instructions: instructions.map((i) => i.toString()).toList(),
          muscleGroups: muscleGroups.map((i) => i.toString()).toList(),
          benefits: benefits.map((i) => i.toString()).toList(),
          description: description);
    }

    print('Malformed JSON: $json');
    throw JsonUnsupportedObjectError(json);
  }

  Map<String, Object?> toFirestore() {
    return {
      'id': id,
      'title': title,
      'instructions': instructions,
      'equipment': equipment,
      'muscleGroups': muscleGroups,
      'rating': rating,
      'benefits': benefits,
      'description': description,
    };
  }

  factory Workout.fromFirestore(Map<String, Object?> data) {
    if (data
        case {
          "equipment": List<dynamic> equipment,
          "instructions": List<dynamic> instructions,
          "title": String title,
          "id": String id,
          "muscleGroups": List<dynamic> muscleGroups,
          "description": String description,
          "benefits": List<dynamic> benefits,
          "rating": int rating
        }) {
      return Workout(
        id: id,
        title: title,
        equipment: equipment.map((i) => i.toString()).toList(),
        instructions: instructions.map((i) => i.toString()).toList(),
        muscleGroups: muscleGroups.map((i) => i.toString()).toList(),
        benefits: benefits.map((i) => i.toString()).toList(),
        description: description,
        rating: rating,
      );
    }

    throw "Malformed Firestore data";
  }
}
