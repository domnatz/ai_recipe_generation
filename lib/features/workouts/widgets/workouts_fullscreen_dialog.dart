import 'package:ai_workout_generation/features/workouts/widgets/workouts_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme.dart';
import '../../../widgets/marketplace_button_widget.dart';
import '../../workouts/workouts_model.dart';

class workoutDialogScreen extends StatelessWidget {
  const workoutDialogScreen({
    super.key,
    required this.workout,
    required this.actions,
    this.subheading,
  });

  final Workout workout;
  final List<Widget> actions;
  final Widget? subheading;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: workoutDisplayWidget(
              workout: workout,
              subheading: subheading,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: MarketplaceTheme.spacing5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MarketplaceButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  buttonText: 'Close',
                  icon: Symbols.close,
                ),
                ...actions,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
