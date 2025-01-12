import 'package:flutter/material.dart';

class BeerButton extends StatelessWidget {
  BeerButton({required this.onPressed, this.onLongPress});

  final GestureTapCallback onPressed;
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'beerAdd',
        child: new RawMaterialButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          fillColor: Theme.of(context).appBarTheme.backgroundColor,
          splashColor: Colors.amber,
          shape: CircleBorder(),
          child: Image.asset('assets/beerAdd.png', height: 128),
        ));
  }
}
