import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ArchivePage extends StatelessWidget {
  ArchivePage({@required this.topBeers, Key key, this.title}) : super(key: key);
  final ValueListenable<List<Text>> topBeers;

  final String title;

  @override
  Widget build(BuildContext context) {
    var textChildren = <Widget>[];
    if (topBeers != null) {
      textChildren.add(Flexible(
          child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 1,
        alignment: Alignment.topCenter,
        child: ListView(
          children: topBeers.value,
          padding: EdgeInsets.only(left: 32),
        ),
      )));
    }
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: textChildren,
      ),
    );
  }
}
