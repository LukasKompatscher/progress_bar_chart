# progress_bar_chart

A package to display multipe values on a vertical chart using progess indicators and animation.  Each value can has a color .

## Features

| Example 1| Example 2 |
| -------------------- | ------- |
| ![Example](https://raw.githubusercontent.com/LukasKompatscher/progress_bar_chart/master/screenshots/example_kg.gif) | ![Example](https://raw.githubusercontent.com/LukasKompatscher/progress_bar_chart/master/screenshots/example_percent.gif) |

## Usage

Example 1:

```dart
final List<StatisticsItem> stats = [
  StatisticsItem(Colors.blue, 500, title: 'Type 1'),
  StatisticsItem(Colors.green, 200, title: 'Type 2'),
  StatisticsItem(Colors.red, 300, title: 'Type 3'),
  StatisticsItem(Colors.yellow, 100, title: 'Type 4'),
];

ProgressBarChart(
    values: stats,
    height: 30,
    borderRadius: 20,
    totalPercentage: 1100,
    unitLabel: 'kg',
),
```

Example 2:

```dart
final List<StatisticsItem> stats = [
  StatisticsItem(Colors.blue, 0.4),
  StatisticsItem(Colors.green, 0.3),
  StatisticsItem(Colors.red, 0.2),
  StatisticsItem(Colors.yellow, 0.1),
];

ProgressBarChart(
  values: stats,
  height: 30,
  borderRadius: 20,
),
```

Without labels and colorblend:

```dart
final List<StatisticsItem> stats = [
  StatisticsItem(Colors.blue, 0.4),
  StatisticsItem(Colors.green, 0.3),
  StatisticsItem(Colors.red, 0.2),
  StatisticsItem(Colors.yellow, 0.1),
];

ProgressBarChart(
  values: stats,
  height: 30,
  borderRadius: 20,
  showLables: false,
  colorBlend: false,
)
```
