import 'package:beer_tracker/models/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../ui/week_view.dart';

class OverviewPage extends StatefulWidget {
  OverviewPage({required this.counter, Key? key, this.title = ''}) : super(key: key);
  final String title;
  final ValueListenable<int> counter;

  @override
  State<StatefulWidget> createState() {
    return _OverviewPageState(counter: this.counter);
  }
}

class _OverviewPageState extends State<OverviewPage> {
  ValueListenable<int> counter;

  _OverviewPageState({required this.counter});

  @override
  Widget build(BuildContext context) {
    var val = counter.value.toString();

    //add text children
    var children = <Widget>[];

    var textChildren = <Widget>[
      Text(
        Settings.counterMode.value == CounterMode.total ? 'Du hast insgesamt' : 'Du hast dieses Jahr',
        style: Theme.of(context).textTheme.caption,
        textScaleFactor: 2,
      ),
      Text(
        val,
        style: Theme.of(context).textTheme.headline6,
        textScaleFactor: 6,
      ),
      Text(
        'Bier getrunken.',
        style: Theme.of(context).textTheme.caption,
        textScaleFactor: 2,
      )
    ];

    var countPane = Container(
      child: Padding(
          child: Column(
            children: textChildren,
          ),
          padding: EdgeInsets.all(16)),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: Theme.of(context).cardColor,
          //border: Border.all(color: Color(0xFFDDDEDF), width: 8)),
          border: Border.all(color: Theme.of(context).appBarTheme.backgroundColor!, width: 8)),
      // border: Border.all(color: Theme.of(context).appBarTheme.backgroundColor!, width: 8)),
    );

    children.add(countPane);

    var weekView = WeekView(title: 'Bier', subtitle: "in der Woche");
    children.add(weekView);

    // var testChart = SizedBox(
    //   child: VerticalBarLabelChart.withSampleData(),
    //   width: 500,
    //   height: 250,
    // );
    // children.add(testChart);
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
