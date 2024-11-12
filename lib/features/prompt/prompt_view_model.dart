import 'package:ai_workout_generation/services/gemini.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/firestore.dart';
import '../../util/filter_chip_enums.dart';
import '../workouts/workouts_model.dart';
import 'prompt_model.dart';

class PromptViewModel extends ChangeNotifier {
  PromptViewModel({
    required this.multiModalModel,
    required this.textModel,
  });

  final GenerativeModel multiModalModel;
  final GenerativeModel textModel;
  bool loadingNewworkout = false;

  PromptData userPrompt = PromptData.empty();
  TextEditingController promptTextController = TextEditingController();

  String badImageFailure =
      "The workout request either does not contain images, or does not contain images of food items. I cannot recommend a workout.";

  Workout? workout;
  String? _geminiFailureResponse;
  String? get geminiFailureResponse => _geminiFailureResponse;
  set geminiFailureResponse(String? value) {
    _geminiFailureResponse = value;
    notifyListeners();
  }

  void notify() => notifyListeners();

  void addImage(XFile image) {
    userPrompt.images.insert(0, image);
    notifyListeners();
  }

  void addAdditionalPromptContext(String text) {
    final existingInputs = userPrompt.additionalTextInputs;
    userPrompt =
        userPrompt.copyWith(additionalTextInputs: [...existingInputs, text]);
    notifyListeners();
  }

  void removeImage(XFile image) {
    userPrompt.images.removeWhere((el) => el.path == image.path);
    notifyListeners();
  }

  void resetPrompt() {
    userPrompt = PromptData.empty();
    notifyListeners();
  }

  // Creates an ephemeral prompt with additional text that the user shouldn't be
  // concerned with to send to Gemini, such as formatting.
  PromptData buildPrompt() {
    return PromptData(
      images: userPrompt.images,
      textInput: mainPrompt,
      muscleGroup: userPrompt.selectedmuscleGroup,
      additionalTextInputs: [format],
    );
  }

  Future<void> submitPrompt() async {
    loadingNewworkout = true;
    notifyListeners();
    print('Submitting prompt...');
    // Create an ephemeral PromptData, preserving the user prompt data without
    // adding the additional context to it.
    var model = userPrompt.images.isEmpty ? textModel : multiModalModel;
    final prompt = buildPrompt();

    try {
      final content = await GeminiService.generateContent(model, prompt);
      print('Content received from Gemini: ${content.text}');

      // handle no image or image of not-food
      if (content.text != null && content.text!.contains(badImageFailure)) {
        geminiFailureResponse = badImageFailure;
        print('Bad image failure: $badImageFailure');
      } else {
        try {
          workout = Workout.fromGeneratedContent(content);
          print('Workout generated: ${workout!.title}');
        } catch (e) {
          print('Error parsing workout content: $e');
          geminiFailureResponse = 'Failed to parse workout content.';
        }
      }
    } catch (error) {
      geminiFailureResponse = 'Failed to reach Gemini. \n\n$error';
      print('Error reaching Gemini: $error');
      loadingNewworkout = false;
    }

    loadingNewworkout = false;
    resetPrompt();
    notifyListeners();
  }

  void saveworkout() {
    FirestoreService.saveworkout(workout!);
  }

  void addMuscleGroup(Set<MuscleGroup> muscleGroups) {
    userPrompt.selectedmuscleGroup.addAll(muscleGroups);
    notifyListeners();
  }

  String get mainPrompt {
    return '''
You are a professional gym trainer. You have a client who is looking to get in shape for a trip to the Amazon Rainforest. They have the following gym equipment: ${userPrompt.equipment}.
Recommend me workouts based on the captured gym equipment.
The workout should be realistic and doable to the average user.
If there are no images attached, or if the image does not contain gym equipment, respond exactly with: $badImageFailure

Adhere to safety and handling best practices when using gym equipment.
These are my target muscle groups: ${userPrompt.selectedmuscleGroup},
Optionally also include the following equipment: ${userPrompt.equipment}
Do not repeat any equipment.

After providing the workouts, add descriptions that creatively explain why the workouts are good based on only the equipment used in the workout.
List out any safety precautions when using the gym equipment.
Provide a summary of the workout and the benefits of the workout. Make your responses as brief as possible.

${promptTextController.text.isNotEmpty ? promptTextController.text : ''}
''';
  }

  final String format = '''
Return the workout plan as valid JSON using the following structure:
{
  "id": \$uniqueId,
  "title": \$workoutTitle,
  "equipment": \$equipment,
  "description": \$description,
  "instructions": \$instructions,
  "muscleGroups": \$muscleGroups,
  "safetyPrecautions": \$safetyPrecautions,
  "benefits": \$benefits,
}

uniqueId should be unique and of type String.
title, description, muscleGroups, safetyPrecautions, and benefits should be of String type.
equipment and instructions should be of type List<String>.
''';
}
