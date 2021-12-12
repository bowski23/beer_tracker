import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';

class BeerButton extends StatelessWidget {
  BeerButton({@required this.onPressed, this.onLongPress});

  final GestureTapCallback onPressed;
  final GestureLongPressCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return new RawMaterialButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      fillColor: Colors.deepOrange,
      splashColor: Colors.amber,
      shape: CircleBorder(),
      child: Image.asset('assets/beerAdd.png', height: 128),
    );
  }
}
