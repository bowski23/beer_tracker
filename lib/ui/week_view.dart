import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _WeekView extends StatelessWidget {
  const _WeekView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: false,
        ),
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceEvenly,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'Mo';
              case 1:
                return 'Di';
              case 2:
                return 'Mi';
              case 3:
                return 'Do';
              case 4:
                return 'Fr';
              case 5:
                return 'Sa';
              case 6:
                return 'So';
              default:
                return '';
            }
          },
        ),
        rightTitles: SideTitles(showTitles: false),
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              y: 8,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(y: 10, colors: [Colors.lightBlueAccent, Colors.greenAccent])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(y: 14, colors: [Colors.lightBlueAccent, Colors.greenAccent])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(y: 15, colors: [Colors.lightBlueAccent, Colors.greenAccent])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              y: 13,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(y: 10, colors: [Colors.lightBlueAccent, Colors.greenAccent])
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}

class WeekViewChart extends StatefulWidget {
  const WeekViewChart({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeekViewChartState();
}

class WeekViewChartState extends State<WeekViewChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.fromLTRB(2, 10, 2, 5),
        color: Theme.of(context).primaryColor,
        child: const _WeekView(),
      ),
    );
  }
}
