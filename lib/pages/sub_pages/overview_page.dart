import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  OverviewPage({@required this.counter, Key key, this.title}) : super(key: key);
  final String title;
  final ValueListenable<int> counter;

  @override
  State<StatefulWidget> createState() {
    return _OverviewPageState(counter: this.counter);
  }
}

class _OverviewPageState extends State<OverviewPage> {
  ValueListenable<int> counter;

  _OverviewPageState({this.counter});

  @override
  Widget build(BuildContext context) {
    var val = counter.value.toString();
    var textChildren = <Widget>[
      Text(
        'Du hast bisher',
        style: Theme.of(context).textTheme.headline6,
      ),
      Text(
        val,
        style: Theme.of(context).textTheme.headline2,
      ),
      Text(
        'Bier getrunken.',
        style: Theme.of(context).textTheme.headline6,
      ),
    ];
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: textChildren,
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
