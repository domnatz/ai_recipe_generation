import 'package:ai_workout_generation/features/workouts/workouts_view_model.dart';
import 'package:ai_workout_generation/features/workouts/widgets/workout_fullscreen_dialog.dart';
import 'package:ai_workout_generation/theme.dart';
import 'package:ai_workout_generation/util/extensions.dart';
import 'package:ai_workout_generation/widgets/highlight_border_on_hover_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

import '../../widgets/marketplace_button_widget.dart';
import '../../widgets/star_rating.dart';
import '../recipes/workout_model.dart';

class SavedworkoutsScreen extends StatefulWidget {
  const SavedworkoutsScreen({super.key, required this.canScroll});

  final bool canScroll;

  @override
  State<SavedworkoutsScreen> createState() => _SavedworkoutsScreenState();
}

class _SavedworkoutsScreenState extends State<SavedworkoutsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SavedworkoutsViewModel>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: constraints.isMobile
              ? const EdgeInsets.only(
                  left: MarketplaceTheme.spacing7,
                  right: MarketplaceTheme.spacing7,
                  bottom: MarketplaceTheme.spacing7,
                  top: MarketplaceTheme.spacing7,
                )
              : const EdgeInsets.only(
                  left: MarketplaceTheme.spacing7,
                  right: MarketplaceTheme.spacing7,
                  bottom: MarketplaceTheme.spacing1,
                  top: MarketplaceTheme.spacing7,
                ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(MarketplaceTheme.defaultBorderRadius),
              topRight: Radius.circular(50),
              bottomRight:
                  Radius.circular(MarketplaceTheme.defaultBorderRadius),
              bottomLeft: Radius.circular(MarketplaceTheme.defaultBorderRadius),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: MarketplaceTheme.borderColor),
                borderRadius: const BorderRadius.only(
                  topLeft:
                      Radius.circular(MarketplaceTheme.defaultBorderRadius),
                  topRight: Radius.circular(50),
                  bottomRight:
                      Radius.circular(MarketplaceTheme.defaultBorderRadius),
                  bottomLeft:
                      Radius.circular(MarketplaceTheme.defaultBorderRadius),
                ),
                color: Colors.white,
              ),
              child: constraints.isMobile
                  ? ListView.builder(
                      physics: widget.canScroll
                          ? const PageScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.workouts.length,
                      itemBuilder: (context, idx) {
                        final workout = viewModel.workouts[idx];
                        return Container(
                          margin: EdgeInsets.only(top: idx == 0 ? 70 : 0),
                          child: Align(
                            heightFactor: .5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: MarketplaceTheme.spacing7,
                                vertical: MarketplaceTheme.spacing7,
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * .99,
                                height: 200,
                                child: _ListTile(
                                  constraints: constraints,
                                  key: Key('$idx-${workout.hashCode}'),
                                  workout: workout,
                                  idx: idx,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : GridView.count(
                      physics: widget.canScroll
                          ? const PageScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 1.5,
                      children: [
                        ...List.generate(viewModel.workouts.length, (idx) {
                          final workout = viewModel.workouts[idx];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: MarketplaceTheme.spacing7,
                              vertical: MarketplaceTheme.spacing7,
                            ),
                            child: _ListTile(
                              key: Key('$idx-${workout.hashCode}'),
                              workout: workout,
                              idx: idx,
                              constraints: constraints,
                            ),
                          );
                        }),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _ListTile extends StatefulWidget {
  const _ListTile({
    super.key,
    required this.workout,
    this.idx = 0,
    required this.constraints,
  });

  final workout workout;
  final int idx;
  final BoxConstraints constraints;

  @override
  State<_ListTile> createState() => _ListTileState();
}

class _ListTileState extends State<_ListTile> {
  final List<Color> colors = [
    MarketplaceTheme.primary,
    MarketplaceTheme.secondary,
    MarketplaceTheme.tertiary,
    MarketplaceTheme.scrim,
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SavedworkoutsViewModel>();
    final color = colors[widget.idx % colors.length];

    return GestureDetector(
      child: HighlightBorderOnHoverWidget(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(MarketplaceTheme.defaultBorderRadius),
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(MarketplaceTheme.defaultBorderRadius),
          bottomLeft: Radius.circular(MarketplaceTheme.defaultBorderRadius),
        ),
        color: color,
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -2),
                color: Colors.black38,
                blurRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MarketplaceTheme.defaultBorderRadius),
              topRight: Radius.circular(50),
              bottomRight:
                  Radius.circular(MarketplaceTheme.defaultBorderRadius),
              bottomLeft: Radius.circular(MarketplaceTheme.defaultBorderRadius),
            ),
            color: Colors.white,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(MarketplaceTheme.defaultBorderRadius),
                topRight: Radius.circular(50),
                bottomRight:
                    Radius.circular(MarketplaceTheme.defaultBorderRadius),
                bottomLeft:
                    Radius.circular(MarketplaceTheme.defaultBorderRadius),
              ),
              color: color.withAlpha(77),
            ),
            padding: const EdgeInsets.all(MarketplaceTheme.spacing7),
            child: Stack(
              children: [
                Text(
                  widget.workout.title,
                  style: MarketplaceTheme.heading3,
                ),
                Positioned(
                  top: widget.constraints.isMobile ? 40 : 60,
                  left: 0,
                  child: Text(
                    widget.workout.cuisine,
                    style: MarketplaceTheme.subheading1,
                  ),
                ),
                Positioned(
                  right: 15,
                  top: widget.constraints.isMobile ? 40 : 60,
                  child: StartRating(
                    initialRating: widget.workout.rating,
                    starColor: color,
                    onTap: null,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () async {
        await showDialog<Null>(
          context: context,
          builder: (context) {
            return workoutDialogScreen(
              workout: widget.workout,
              subheading: Row(
                children: [
                  const Text('My rating:'),
                  const SizedBox(width: 10),
                  StartRating(
                    initialRating: widget.workout.rating,
                    starColor: MarketplaceTheme.tertiary,
                    onTap: (index) {
                      widget.workout.rating = index + 1;
                      viewModel.updateworkout(widget.workout);
                    },
                  ),
                ],
              ),
              actions: [
                MarketplaceButton(
                  onPressed: () {
                    viewModel.deleteworkout(widget.workout);
                    Navigator.of(context).pop();
                  },
                  buttonText: "Delete workout",
                  icon: Symbols.delete,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
