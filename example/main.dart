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
    final Map<Color, double> colors = {
      Colors.blue: 0.15,
      Colors.green: 0.4,
      Colors.red: 0.2,
      Colors.yellow: 0.1,
    };

    return MaterialApp(
      title: 'ProgressBarChart Example',
      home: ProgressBarChart(
        height: height,
        values: colors,
        borderRadius: 40,
      ),
    );
  }
}
