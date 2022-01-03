import 'package:beer_tracker/entry_storage.dart';
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

class _WeekViewState extends State<WeekView> {
  List<int> dayCount = [0, 0, 0, 0, 0, 0, 0];

  _WeekViewState() {
    updateDayCount();
  }

  updateDayCount() async {
    List<int> newDayCount = await EntryStorage.get().countEntriesByDay();
    setState(() {
      dayCount = newDayCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: charts.BarChart(
        [
          charts.Series<int, String>(
            data: dayCount,
            domainFn: (datum, index) => WeekdaysNames.short[index!],
            measureFn: (datum, index) => datum,
            id: "",
          )
        ],
      ),
      height: 250,
    );
  }
}
