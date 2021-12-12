import 'package:flutter/foundation.dart';

class StandardBeerEntry {
  final String brand;
  final double volume;
  final String form;
  final DateTime validUntil;

  StandardBeerEntry(
      {@required this.brand,
      @required this.validUntil,
      @required this.volume,
      @required this.form});

  StandardBeerEntry.fromMap(Map<String, dynamic> map)
      : brand = map['brand'],
        validUntil =
            DateTime.fromMillisecondsSinceEpoch(map['validUntil'], isUtc: true),
        volume = map['volume'],
        form = map['form'];

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'validUntil': validUntil.millisecondsSinceEpoch,
      'volume': volume,
      'form': form
    };
  }
}
