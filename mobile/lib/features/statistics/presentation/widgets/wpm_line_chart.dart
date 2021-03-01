import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/use_cases/get_zscore_of_number_of_words_read_per_minute_use_case.dart';

class WPMLineChart extends StatelessWidget {
  WPMLineChart({
    Key key,
    @required this.minY,
    @required this.maxY,
    @required this.gradientColors,
    @required this.readingStatusMap,
    @required this.data,
    this.indexToHighlight,
  }) : super(key: key);

  final double minY;
  final double maxY;

  final int indexToHighlight;

  final List<double> data;

  final List<Color> gradientColors;
  final Map<ReadingStatus, double> readingStatusMap;

  final noDeficitColor = Color(0xff67DB66);
  final alertColor = Color(0xffFADF53);
  final deficitColor = Color(0xffFDC55B);
  final moderateColor = Color(0xffFA7C2B);
  final majorColor = Color(0xffD80000);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minY - (maxY / 20),
        maxY: maxY + (maxY / 20),
        gridData: buildGridData(),
        titlesData: buildFlTitlesData(),
        lineTouchData: buildTouchData(),
        axisTitleData: buildAxisTitleData(),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        lineBarsData: buildLineBarsData(),
      ),
    );
  }

  FlAxisTitleData buildAxisTitleData() {
    return FlAxisTitleData(
      bottomTitle: AxisTitle(
        showTitle: true,
        titleText: 'Readings',
        margin: 8,
        textStyle: TextStyle(color: Colors.white),
      ),
      leftTitle: AxisTitle(
        showTitle: true,
        titleText: 'Words Read Per Minute',
        margin: -5,
        textStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  LineTouchData buildTouchData() {
    return LineTouchData(
      touchSpotThreshold: 16,
      getTouchedSpotIndicator: (barData, spotIndexes) =>
          getCustomTouchedSpotIndicator(spotIndexes),
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipItems: (touchedSpots) => getCustomTooltipItem(touchedSpots),
        tooltipRoundedRadius: 5,
      ),
    );
  }

  List<TouchedSpotIndicatorData> getCustomTouchedSpotIndicator(
      List<int> spotIndexes) {
    List<TouchedSpotIndicatorData> touchedSpotIndicators = [];

    for (int i = 0; i < spotIndexes.length; i++) {
      final color = getReadingStatusColorFromValue(data[spotIndexes[i]]);

      touchedSpotIndicators.add(
        TouchedSpotIndicatorData(
          FlLine(color: color, strokeWidth: 4),
          FlDotData(
            getDotPainter: (spot, index, c, d) => FlDotCirclePainter(
              color: color,
              radius: 12,
            ),
          ),
        ),
      );
    }

    return touchedSpotIndicators;
  }

  List<LineTooltipItem> getCustomTooltipItem(List<LineBarSpot> touchedSpots) {
    List<LineTooltipItem> tooltipItems = [];
    touchedSpots.forEach((element) {
      final value = element.y;
      tooltipItems.add(LineTooltipItem(
        '${value.toInt()} WPM\n ${getReadingStatusTextFromValue(value)}',
        TextStyle(fontSize: 14, color: Colors.black),
      ));
    });

    return tooltipItems;
  }

  FlGridData buildGridData() {
    return FlGridData(
      show: true,
      horizontalInterval: 30,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (_) => FlLine(
        color: const Color(0xff37434d),
        strokeWidth: 1,
      ),
      getDrawingVerticalLine: (_) => FlLine(
        color: const Color(0xff37434d),
        strokeWidth: 1,
      ),
    );
  }

  FlTitlesData buildFlTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: false,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff68737d),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        margin: 16,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        reservedSize: 32,
        margin: 8,
        interval: maxY / 9,
        getTitles: (value) => '${value.toInt()}',
        checkToShowTitle: (_a, _b, _c, _d, value) =>
            value > minY && value < maxY,
      ),
    );
  }

  List<LineChartBarData> buildLineBarsData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++)
      spots.add(FlSpot(i.toDouble(), data[i]));

    return [
      LineChartBarData(
        spots: spots,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: indexToHighlight != null && index == indexToHighlight
                ? 8.5
                : 5.5,
            color: getReadingStatusColorFromValue(spot.y),
            strokeWidth:
                indexToHighlight != null && index == indexToHighlight ? 2.5 : 0,
            strokeColor: Colors.white,
          ),
        ),
        isCurved: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.15)).toList(),
        ),
      ),
    ];
  }

  Color getReadingStatusColorFromValue(double value) {
    List<Color> colors = [
      majorColor,
      moderateColor,
      deficitColor,
      alertColor,
      noDeficitColor,
    ];

    int index = 0;
    readingStatusMap.entries.forEach((element) {
      if (value <= element.value) return colors[index];
      index++;
    });

    return colors[index];
  }

  String getReadingStatusTextFromValue(double value) {
    ReadingStatus status;
    for (int i = 0; i < readingStatusMap.keys.length; i++) {
      if (value <= readingStatusMap.values.elementAt(i)) {
        status = readingStatusMap.keys.elementAt(i);
        break;
      }
    }
    switch (status) {
      case ReadingStatus.majorDeficit:
        return 'Major Deficit';
      case ReadingStatus.moderateDeficit:
        return 'Moderate Deficit';
      case ReadingStatus.deficit:
        return 'Deficit';
      case ReadingStatus.deficitAlert:
        return 'Deficit Alert';
      default:
        return 'No Deficit';
    }
  }
}
