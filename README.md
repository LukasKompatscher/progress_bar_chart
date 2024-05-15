# progress_bar_chart

A package to display multipe values on a vertical chart using progess indicators and animation.  Each value can has a color .

## Features

Without colorblend:

![Example](https://raw.githubusercontent.com/LukasKompatscher/progress_bar_chart/master/assets/example.gif)

With colorblend:

![Example](https://raw.githubusercontent.com/LukasKompatscher/progress_bar_chart/master/assets/example_colorblend.gif)

## Usage

Example

With colorblend:

```dart
ProgressBarChart(
        height: 30,
        values: {
          Colors.blue: 0.15,
          Colors.green: 0.4,
          Colors.red: 0.2,
          Colors.yellow: 0.1,
        },
        borderRadius: 40,
)
```

Without colorblend:

```dart
ProgressBarChart(
        height: 30,
        values: {
          Colors.blue: 0.15,
          Colors.green: 0.4,
          Colors.red: 0.2,
          Colors.yellow: 0.1,
        },
        borderRadius: 40,
        colorBlend: false,
)
```

Without labels:

```dart
ProgressBarChart(
        height: 30,
        values: {
          Colors.blue: 0.15,
          Colors.green: 0.4,
          Colors.red: 0.2,
          Colors.yellow: 0.1,
        },
        borderRadius: 40,
        showLables: false,
)
```
