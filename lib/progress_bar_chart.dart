library progress_bar_chart;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

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
    this.colorBlend = true,
    this.totalPercentage = 0,
    this.unitLabel = '%',
  });

  /// A list of [StatisticsItem] objects representing the data to be displayed in the progress bar chart.
  ///
  /// Each [StatisticsItem] object contains a color, a value, and an optional title. The color represents the color of the progress bar,
  /// the value represents the progress of the bar, and the title (if provided) represents the label of the bar.
  ///
  /// The values are sorted in descending order and the cumulative total is calculated for each value. If [totalPercentage] is provided,
  /// each value is converted to a percentage of [totalPercentage] before being added to the total. If [totalPercentage] is zero,
  /// the values are simply added to the total.
  ///
  /// The list is then reversed so that the values with the highest progress are displayed first in the chart.
  /// Example:
  /// ```dart
  ///    StatisticsItem(Colors.blue, 599.50),
  ///    StatisticsItem(Colors.green, 0.3),
  ///    StatisticsItem(Colors.red, 300, title: 'Weight'),
  /// ```
  final List<StatisticsItem> values;

  /// The height of the progress bar chart.
  final double height;

  /// The border radius of the progress bars (optional).
  final double? borderRadius;

  /// Whether to show the labels on the progress bars (optional).
  final bool showLables;

  /// Whether to blend the colors of the progress bars (optional).
  final bool colorBlend;

  /// The unit label of the progress values (optional).
  final String unitLabel;

  /// The total percentage of the progress bars (optional).
  /// If the total percentage is not provided, it will be calculated automatically.
  final double totalPercentage;

  @override
  State<ProgressBarChart> createState() => _ProgressBarChartState();
}

class _ProgressBarChartState extends State<ProgressBarChart>
    with TickerProviderStateMixin {
  Map<Color, AnimationController> controllers = {};
  Map<Color, Animation<double>> animations = {};
  List<StatisticsItem> percentageValues = [];

  /// Initializes the state of the progress bar chart.
  @override
  void initState() {
    super.initState();

    percentageValues = List<StatisticsItem>.from(widget.values);
    percentageValues.sort((a, b) => b.value.compareTo(a.value));

    double total = 0;
    for (var i = 0; i < percentageValues.length; i++) {
      double percentage = widget.totalPercentage != 0
          ? (percentageValues[i].value / widget.totalPercentage)
          : percentageValues[i].value;
      total += percentage;
      percentageValues[i] = StatisticsItem(percentageValues[i].color, total);
    }

    percentageValues = percentageValues.reversed.toList();

    const maxDuration = Duration(seconds: 1);

    // Create animation controllers and animations for each value
    for (var entry in percentageValues) {
      final duration = Duration(
          milliseconds: (maxDuration.inMilliseconds * entry.value).round());
      controllers[entry.color] = AnimationController(
        duration: duration,
        vsync: this,
      );
      animations[entry.color] =
          Tween<double>(begin: 0, end: entry.value).animate(
        CurvedAnimation(
          parent: controllers[entry.color]!.view,
          curve: Curves.easeOut,
        ),
      );
      controllers[entry.color]?.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String formatText(double value, {bool original = false}) {
    double result = widget.totalPercentage != 0 ? value : value * 100;
    int formatResult = result.toInt();
    var languageCode = Localizations.localeOf(context).languageCode;
    final numberFormat = NumberFormat.decimalPattern(languageCode);
    String ret = numberFormat.format(formatResult);
    return original
        ? result % 1 == 0
            ? ret
            : result.toStringAsFixed(2)
        : ret;
  }

  Color getTextColor(Color color) {
    if (widget.colorBlend) {
      return Color.alphaBlend(color.withValues(alpha: 0.3), Colors.black);
    }
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  getTitle(String? title) {
    return title != null ? '$title: ' : '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return SizedBox(
            width: width,
            child: Stack(
              children: percentageValues
                  .map(
                    (entry) => AnimatedBuilder(
                      animation: animations[entry.color]!,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            IgnorePointer(
                              child: LinearProgressIndicator(
                                minHeight: widget.height,
                                value: animations[entry.color]?.value,
                                backgroundColor: Colors.transparent,
                                color: entry.color,
                                semanticsValue: entry.value.toString(),
                                borderRadius: widget.borderRadius != null
                                    ? BorderRadius.circular(
                                        widget.borderRadius!,
                                      )
                                    : BorderRadius.zero,
                              ),
                            ),
                            if (widget.showLables)
                              Builder(
                                builder: (context) {
                                  final itemOrigin = widget.values.firstWhere(
                                      (e) => e.color == entry.color);
                                  final textWidth = width *
                                      (widget.totalPercentage != 0
                                          ? itemOrigin.value /
                                              widget.totalPercentage
                                          : itemOrigin.value);
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
                                          child: Tooltip(
                                            message:
                                                '${getTitle(itemOrigin.title)}${formatText(itemOrigin.value, original: true)}${widget.unitLabel}',
                                            triggerMode: TooltipTriggerMode.tap,
                                            child: SizedBox(
                                              width: textWidth,
                                              child: Text(
                                                '${formatText(itemOrigin.value)} ${textWidth > 60 ? widget.unitLabel : ''}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      getTextColor(entry.color),
                                                  fontSize: widget.height * 0.5,
                                                  fontWeight: FontWeight.w700,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
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
          );
        },
      ),
    );
  }
}

/// Represents an item in the statistics chart.
class StatisticsItem {
  /// Represents the title of the progress bar chart displayed in tooltips.
  final String? title;

  /// Represents the value of the progress bar chart.
  double value;

  /// Represents the color of the progress bar chart.
  final Color color;

  /// Creates a new instance of [StatisticsItem].
  ///
  /// The [color] parameter specifies the color of the item.
  /// The [value] parameter specifies the value of the item.
  /// The [title] parameter is an optional title for the item.
  StatisticsItem(
    this.color,
    this.value, {
    this.title,
  });
}
