import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../theme.dart';
import '../../workouts/workouts_model.dart';

class workoutDisplayWidget extends StatelessWidget {
  const workoutDisplayWidget({
    super.key,
    required this.workout,
    this.subheading,
  });

  final Workout workout;
  final Widget? subheading;

  List<Widget> _buildEquipment(List<String> equipment) {
    final widgets = <Widget>[];
    for (var item in equipment) {
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Symbols.stat_0_rounded,
              size: 12,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                item,
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildInstructions(List<String> instructions) {
    final widgets = <Widget>[];

    // check for existing numbers in instructions.
    if (instructions.first.startsWith(RegExp('[0-9]'))) {
      for (var instruction in instructions) {
        widgets.add(Text(instruction));
        widgets.add(const SizedBox(height: MarketplaceTheme.spacing6));
      }
    } else {
      for (var i = 0; i < instructions.length; i++) {
        widgets.add(Text(
          '${i + 1}. ${instructions[i]}',
          softWrap: true,
        ));
        widgets.add(const SizedBox(height: MarketplaceTheme.spacing6));
      }
    }

    return widgets;
  }

  List<Widget> _buildMuscleGroups(List<String> muscleGroups) {
    final widgets = <Widget>[];
    for (var group in muscleGroups) {
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Symbols.fitness_center,
              size: 12,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                group,
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildSafetyPrecautions(List<String> safetyPrecautions) {
    final widgets = <Widget>[];
    for (var precaution in safetyPrecautions) {
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Symbols.warning,
              size: 12,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                precaution,
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildBenefits(List<String> benefits) {
    final widgets = <Widget>[];
    for (var benefit in benefits) {
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Symbols.thumb_up,
              size: 12,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                benefit,
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(MarketplaceTheme.defaultBorderRadius),
            color: MarketplaceTheme.primary.withAlpha(128),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout!.title,
                            softWrap: true,
                            style: MarketplaceTheme.heading2,
                          ),
                          if (subheading != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: MarketplaceTheme.spacing7,
                              ),
                              child: subheading,
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                          (states) {
                            if (states.contains(MaterialState.hovered)) {
                              return MarketplaceTheme.scrim.withAlpha(153);
                            }
                            return Colors.white;
                          },
                        ),
                        shape: MaterialStateProperty.resolveWith(
                          (states) {
                            return RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: MarketplaceTheme.primary),
                              borderRadius: BorderRadius.circular(
                                MarketplaceTheme.defaultBorderRadius,
                              ),
                            );
                          },
                        ),
                        textStyle: MaterialStateProperty.resolveWith(
                          (states) {
                            return MarketplaceTheme.dossierParagraph.copyWith(
                              color: Colors.black45,
                            );
                          },
                        ),
                      ),
                      onPressed: () async {
                        await showDialog<dynamic>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Padding(
                                padding: const EdgeInsets.all(
                                    MarketplaceTheme.spacing7),
                                child: Text(workout!.description),
                              ),
                            );
                          },
                        );
                      },
                      child: Transform.translate(
                        offset: const Offset(0, 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: MarketplaceTheme.spacing6),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: SvgPicture.asset(
                                  'assets/chef_cat.svg',
                                  semanticsLabel: 'Chef cat icon',
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(1, -6),
                                child: Transform.rotate(
                                  angle: -pi / 20.0,
                                  child: Text(
                                    'Chef Noodle \n says...',
                                    style: MarketplaceTheme.label,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 40,
                  color: Colors.black26,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: MarketplaceTheme.spacing7,
                  ),
                  child: Text('Muscle Groups:',
                      style: MarketplaceTheme.subheading1),
                ),
                ..._buildMuscleGroups(workout!.muscleGroups),
                const Divider(
                  height: 40,
                  color: Colors.black26,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: MarketplaceTheme.spacing7,
                  ),
                  child: Text('Safety Precautions:',
                      style: MarketplaceTheme.subheading1),
                ),
                ..._buildSafetyPrecautions(workout!.safetyPrecautions),
                const Divider(
                  height: 40,
                  color: Colors.black26,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: MarketplaceTheme.spacing7,
                  ),
                  child: Text('Benefits:', style: MarketplaceTheme.subheading1),
                ),
                ..._buildBenefits(workout!.benefits),
              ],
            ),
          ),

          /// Body section
          Padding(
            padding: const EdgeInsets.all(MarketplaceTheme.spacing4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: MarketplaceTheme.spacing7,
                  ),
                  child:
                      Text('Equipment:', style: MarketplaceTheme.subheading1),
                ),
                ..._buildEquipment(workout!.equipment),
                const SizedBox(height: MarketplaceTheme.spacing4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: MarketplaceTheme.spacing7),
                  child: Text('Instructions:',
                      style: MarketplaceTheme.subheading1),
                ),
                ..._buildInstructions(workout!.instructions),
              ],
            ),
          )
        ],
      ),
    );
  }
}
