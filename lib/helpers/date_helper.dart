import 'package:intl/intl.dart';
import 'dart:io';

class WeekdaysNames {
  static List<String> _longList = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
  static List<String> _shortList = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

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
