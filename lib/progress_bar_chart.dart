library progress_bar_chart;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget that displays a progress bar chart.
///
/// The [ProgressBarChart] widget is used to display a chart with progress bars.
class ProgressBarChart extends StatefulWidget {
  const ProgressBarChart({
    super.key,
    required this.height,
    required this.values,
    this.borderRadius,
    this.showLables = true,
  });

  /// A map that maps colors to their corresponding progress values.
  ///
  /// The progress values should be between 0 and 1.
  /// The colors should be unique.
  ///
  /// Example:
  ///
  /// ```dart
  /// {
  ///   Colors.red: 0.2,
  ///   Colors.green: 0.5,
  ///   Colors.blue: 0.3,
  /// }
  /// ```
  final Map<Color, double> values;

  /// The height of the progress bar chart.
  final double height;

  /// The border radius of the progress bars (optional).
  final double? borderRadius;

  /// Whether to show the labels on the progress bars (optional).
  final bool showLables;

  @override
  State<ProgressBarChart> createState() => _ProgressBarChartState();
}

class _ProgressBarChartState extends State<ProgressBarChart>
    with TickerProviderStateMixin {
  Map<Color, AnimationController> controllers = {};
  Map<Color, Animation<double>> animations = {};
  Map<Color, double> sortedValues = {};

  /// Initializes the state of the progress bar chart.
  @override
  void initState() {
    super.initState();
    double total = 0.0;

    // Sort the values in descending order
    sortedValues = Map.fromEntries(widget.values.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));

    // Calculate the cumulative total for each value
    sortedValues = sortedValues.map((key, value) {
      total += value;
      return MapEntry(key, total);
    });

    // Reverse the order of the sorted values
    sortedValues = Map.fromEntries(sortedValues.entries.toList().reversed);

    const maxDuration = Duration(seconds: 1);

    // Create animation controllers and animations for each value
    for (var entry in sortedValues.entries) {
      final duration = Duration(
          milliseconds: (maxDuration.inMilliseconds * entry.value).round());
      controllers[entry.key] = AnimationController(
        duration: duration,
        vsync: this,
      );
      animations[entry.key] = Tween<double>(begin: 0, end: entry.value).animate(
        CurvedAnimation(
          parent: controllers[entry.key]!.view,
          curve: Curves.easeOut,
        ),
      );
      controllers[entry.key]?.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String formatText(double value) {
    double result = value * 100;
    return result % 1 == 0
        ? result.toInt().toString()
        : result.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Center(
          child: SizedBox(
            width: width,
            height: widget.height,
            child: Stack(
              children: sortedValues.entries
                  .map(
                    (entry) => AnimatedBuilder(
                      animation: animations[entry.key]!,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            LinearProgressIndicator(
                              minHeight: widget.height,
                              value: animations[entry.key]?.value,
                              backgroundColor: Colors.transparent,
                              color: entry.key,
                              semanticsValue: entry.value.toString(),
                              borderRadius: widget.borderRadius != null
                                  ? BorderRadius.circular(widget.borderRadius!)
                                  : BorderRadius.zero,
                            ),
                            if (widget.showLables)
                              Builder(
                                builder: (context) {
                                  final textWidth =
                                      width * widget.values[entry.key]!;
                                  if (textWidth < 40) return Container();
                                  return FutureBuilder(
                                    future: Future.delayed(
                                        const Duration(microseconds: 500)),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else {
                                        return Container(
                                          width: width * entry.value,
                                          height: widget.height,
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            width: textWidth,
                                            child: Text(
                                              '${formatText(widget.values[entry.key]!)} ${textWidth > 60 ? '%' : ''}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: entry.key
                                                            .computeLuminance() >
                                                        0.5
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: widget.height * 0.5,
                                                fontWeight: FontWeight.w700,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ).animate().fadeIn();
                                      }
                                    },
                                  );
                                },
                              )
                          ],
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
