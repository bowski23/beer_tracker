import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static Settings? _instance;

  static Setting<CounterMode> counterMode = Setting("counterMode", CounterMode.year, enumValues: CounterMode.values);

  static Settings get settings {
    return _instance ?? _createInstance();
  }

  static Settings _createInstance() {
    _instance = Settings._();
    return _instance!;
  }

  Settings._();
}

class Setting<T> {
  String _key;
  T? _value;
  T _defaultValue;
  SharedPreferences? _prefs;
  List<T>? _enumValues;
  ValueNotifier<T> notifier;

  //as generic enums aren't easily handable in flutter we use as a workaround the passing of the enum values at definition as a parameter.
  Setting(this._key, this._defaultValue, {List<T>? enumValues})
      : this._enumValues = enumValues,
        notifier = ValueNotifier<T>(_defaultValue) {
    _init();
  }

  _init() async {
    _prefs = await SharedPreferences.getInstance();
    assert(_prefs != null, "Shared Preferences couldn't be loaded");
    switch (T) {
      case String:
        _value = _prefs!.getString(_key) as T;
        break;
      case int:
        _value = _prefs!.getInt(_key) as T;
        break;
      case double:
        _value = _prefs!.getDouble(_key) as T;
        break;
      case bool:
        _value = _prefs!.getBool(_key) as T;
        break;
      default:
        if (_defaultValue is Enum && _enumValues != null) {
          var index = _prefs!.getInt(_key);
          _value = index != null ? _enumValues![index] : null;
          break;
        }
        assert(false, "Setting of type " + T.toString() + " with key " + _key + "is not viable");
    }
    notifier.value = this.value;
  }

  T get value {
    if (_value != null) {
      return _value!;
    } else {
      return _defaultValue;
    }
  }

  set value(T? val) {
    if (val == null) {
      _value = null;
      _prefs!.remove(_key);
      notifier.value = this.value;
      return;
    } else {
      _value = val;
      notifier.value = this.value;
    }

    switch (T) {
      case String:
        _prefs!.setString(_key, _value! as String);
        break;
      case int:
        _prefs!.setInt(_key, _value! as int);
        break;
      case double:
        _prefs!.setDouble(_key, _value! as double);
        break;
      case bool:
        _prefs!.setBool(_key, _value! as bool);
        break;
      default:
        if (val is Enum) {
          _prefs!.setInt(_key, (_value as Enum).index);
          break;
        }
        assert(false, "Setting of type " + T.toString() + " with key " + _key + "is not viable");
    }
  }

  bool get isUsingDefaultValue {
    return _value == null;
  }

  List<T>? get enumValues {
    if (T is Enum) {
      return this._enumValues;
    } else {
      return null;
    }
  }
}

enum CounterMode { total, year }
