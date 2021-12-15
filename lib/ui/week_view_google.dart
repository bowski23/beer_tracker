import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';

class WeekdaysNames {
  static List<String> _longList;
  static List<String> _shortList;

  static List<String> get long {
    if (_longList == null) {
      _longList = DateFormat.EEEE(Platform.localeName).dateSymbols.WEEKDAYS.toList();
      _longList.add(_longList.removeAt(0));
    }
    return _longList;
  }

  static List<String> get short {
    if (_shortList == null) {
      _shortList = DateFormat.EEEE(Platform.localeName).dateSymbols.SHORTWEEKDAYS.toList();
      _shortList.add(_shortList.removeAt(0));
    }
    return _shortList;
  }
}

class WeekViewGoogle extends StatefulWidget {
  final String title;
  final String subtitle;

  WeekViewGoogle({
    @required this.title,
    @required this.subtitle,
  });

  @override
  _WeekViewGoogleState createState() => new _WeekViewGoogleState();
}

class _WeekViewGoogleState extends State<WeekViewGoogle> {
  void _handleButtonPress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: charts.BarChart(
        [
          charts.Series<WeekdayCounter, String>(
            data: [
              WeekdayCounter(0, 2),
              WeekdayCounter(1, 3),
              WeekdayCounter(2, 0),
              WeekdayCounter(3, 5),
              WeekdayCounter(4, 21),
              WeekdayCounter(5, 0),
              WeekdayCounter(6, 2),
            ],
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

class WeekdayCounter {
  int weekday; //0:mon .. 6:sun
  int count;

  WeekdayCounter(this.weekday, this.count);
}
