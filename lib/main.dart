import 'package:ai_workout_generation/util/device_info.dart';
import 'package:ai_workout_generation/util/tap_recorder.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

import 'features/prompt/prompt_view_model.dart';
import 'features/workouts/workouts_view_model.dart';
import 'firebase_options.dart';
import 'router.dart';
import 'theme.dart';

late CameraDescription camera;
late BaseDeviceInfo deviceInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  deviceInfo = await DeviceInfo.initialize(DeviceInfoPlugin());
  if (DeviceInfo.isPhysicalDeviceWithCamera(deviceInfo)) {
    final cameras = await availableCameras();
    camera = cameras.first;
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late GenerativeModel geminiVisionProModel;
  late GenerativeModel geminiProModel;
  @override
  void initState() {
    const apiKey = 'AIzaSyCUgEIdM2LP1rdhfQrELJadVlEZ28hwV0o';
    if (apiKey == 'key not found') {
      throw InvalidApiKey(
        'Key not found in environment. Please add an API key.',
      );
    }

    geminiVisionProModel = GenerativeModel(
      model: 'gemini-1.5-pro-002',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 1,
        maxOutputTokens: 4096,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );

    geminiProModel = GenerativeModel(
      model: 'gemini-1.5-pro-002',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 1,
        maxOutputTokens: 4096,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final workoutsViewModel = SavedworkoutsViewModel();

    return TapRecorder(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PromptViewModel(
              multiModalModel: geminiVisionProModel,
              textModel: geminiProModel,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => workoutsViewModel,
          ),
        ],
        child: SafeArea(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: MarketplaceTheme.theme,
            scrollBehavior: const ScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              },
            ),
            home: const AdaptiveRouter(),
          ),
        ),
      ),
    );
  }
}
