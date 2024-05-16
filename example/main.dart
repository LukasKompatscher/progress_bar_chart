import 'package:flutter/material.dart';
import 'package:progress_bar_chart/progress_bar_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const height = 30.0;
    final List<StatisticsItem> colors = [
      StatisticsItem(Colors.blue, 500, title: 'Weight'),
      StatisticsItem(Colors.green, 200, title: 'Height'),
      StatisticsItem(Colors.red, 300, title: 'Length'),
      StatisticsItem(Colors.yellow, 100, title: 'Width'),
    ];

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Center(
        child: ProgressBarChart(
          values: colors,
          height: height,
          borderRadius: 20,
          totalPercentage: 1200,
          unitLabel: 'kg',
        ),
      ),
    );
  }
}
