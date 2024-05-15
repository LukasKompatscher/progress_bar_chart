# progress_bar_chart

A package to display multipe values on a vertical chart using progess indicators and animation.  Each value can has a color .

## Features

![Example](https://raw.githubusercontent.com/LukasKompatscher/progress_bar_chart/master/assets/example.gif)

## Usage

Example

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
