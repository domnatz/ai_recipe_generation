import 'package:image_picker/image_picker.dart';

import '../../util/filter_chip_enums.dart';

class PromptData {
  PromptData({
    required this.images,
    required this.textInput,
    Set<MuscleGroup>? muscleGroup,
    List<String>? additionalTextInputs,
  })  : additionalTextInputs = additionalTextInputs ?? [],
        selectedmuscleGroup = muscleGroup ?? {};

  PromptData.empty()
      : images = [],
        additionalTextInputs = [],
        selectedmuscleGroup = {},
        textInput = '';

  String get equipment {
    return selectedmuscleGroup.map((workout) => workout.name).join(", ");
  }

  List<XFile> images;
  String textInput;
  List<String> additionalTextInputs;
  Set<MuscleGroup> selectedmuscleGroup;

  PromptData copyWith({
    List<XFile>? images,
    String? textInput,
    List<String>? additionalTextInputs,
    Set<MuscleGroup>? muscleGroup,
  }) {
    return PromptData(
      images: images ?? this.images,
      textInput: textInput ?? this.textInput,
      additionalTextInputs: additionalTextInputs ?? this.additionalTextInputs,
      muscleGroup: muscleGroup ?? selectedmuscleGroup,
    );
  }
}
