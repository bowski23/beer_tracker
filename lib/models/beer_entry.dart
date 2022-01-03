import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class BeerEntry {
  final String? id;
  final String brand;
  final DateTime date;
  final double volume;
  final String? form;
  final bool hasImage;
  final String? note;

  BeerEntry(
      {this.id,
      required this.brand,
      required this.date,
      this.volume = 0.5,
      this.hasImage = false,
      this.note = '',
      this.form = ''});

  BeerEntry.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        brand = map['brand'],
        date = DateTime.fromMillisecondsSinceEpoch(map['date'], isUtc: true),
        volume = map['volume'],
        hasImage = map['hasImage'] != 0,
        note = map['note'],
        form = map['form'];

  Map<String, dynamic> toMap() {
    String lId;
    if (id == null || id!.isEmpty) {
      lId = Uuid().v1();
    } else {
      lId = id!;
    }
    return {
      'id': lId,
      'brand': brand,
      'date': date.millisecondsSinceEpoch,
      'volume': volume,
      'hasImage': hasImage,
      'note': note,
      'form': form
    };
  }
}
