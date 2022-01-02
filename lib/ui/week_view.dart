import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../helpers/date_helper.dart';

class WeekView extends StatefulWidget {
  final String title;
  final String subtitle;

  WeekView({
    required this.title,
    required this.subtitle,
  });

  @override
  _WeekViewState createState() => new _WeekViewState();
}

class WeekdayCounter {
  int weekday; //0:mon .. 6:sun
  int count;

  WeekdayCounter(this.weekday, this.count);
}

class _WeekViewState extends State<WeekView> {
  List<WeekdayCounter> dayCount = [
    WeekdayCounter(0, 0),
    WeekdayCounter(1, 0),
    WeekdayCounter(2, 0),
    WeekdayCounter(3, 0),
    WeekdayCounter(4, 0),
    WeekdayCounter(5, 0),
    WeekdayCounter(6, 0)
  ];

  _WeekViewState() {}

  updateDayCount() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: charts.BarChart(
        [
          charts.Series<WeekdayCounter, String>(
            data: dayCount,
            domainFn: (datum, index) => WeekdaysNames.short[datum.weekday],
            measureFn: (datum, index) => datum.count,
            id: "",
          )
        ],
      ),
      height: 250,
    );
  }
}
