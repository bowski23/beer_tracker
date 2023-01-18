import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  //all settings should be defined here

  static Setting<CounterMode> counterMode = Setting("counterMode", CounterMode.year, enumValues: CounterMode.values);
  static Setting<bool> publishToDiscord = Setting("publishToDiscord", false);
  static Setting<String> publishToDiscordName = Setting("publishToDiscordName", "Anonym");

  //below is the actual class definition
  static Settings? _instance;
  static Settings get instance {
    return _instance ?? _createInstance();
  }

  static Settings _createInstance() {
    _instance = Settings._();
    return _instance!;
  }

  static bool ensureInitialized() {
    // ignore: unnecessary_null_comparison
    if (instance != null) return true;
    return false;
  }

  Settings._();
}

class Setting<T> {
  final String _key;
  T? _value;
  final T _defaultValue;
  SharedPreferences? _prefs;
  final List<T>? _enumValues;
  ValueNotifier<T> notifier;

  //as generic enums aren't easily handable in flutter we use as a workaround the passing of the enum values at definition as a parameter.
  Setting(this._key, this._defaultValue, {List<T>? enumValues})
      : _enumValues = enumValues,
        notifier = ValueNotifier<T>(_defaultValue) {
    _init();
  }

  _init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs == null) throw Exception("Shared Preferences couldn't be loaded");

    if (!_prefs!.containsKey(_key)) {
      _value = _defaultValue;
    } else {
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
          throw Exception("Setting of type $T with key ${_key}is not viable");
      }
    }

    notifier.value = value;
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
      notifier.value = value;
      return;
    } else {
      _value = val;
      notifier.value = value;
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
        throw Exception("Setting of type $T with key ${_key}is not viable");
    }
  }

  bool get isUsingDefaultValue {
    return _value == null;
  }

  List<T>? get enumValues {
    if (T is Enum) {
      return _enumValues;
    } else {
      return null;
    }
  }
}

enum CounterMode { total, year }

class SettingWidget<T> extends StatelessWidget {
  // ignore: unused_field
  final Setting<T> _setting;
  final String description;
  final IconData? icon;
  final Widget child;

  SettingWidget(this._setting, {Key? key, required this.child, String description = '', this.icon})
      : description = description.isEmpty ? _setting.value.runtimeType.toString() : description,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Theme.of(context).dividerColor.withAlpha(128)))),
              child: SizedBox(width: 50, height: 40, child: icon != null ? Icon(icon) : null),
            ),
            Flexible(
              child: Text(
                description,
                overflow: TextOverflow.fade,
                maxLines: 3,
              ),
            ),
            Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
                margin: const EdgeInsets.only(left: 10),
                child: child)
          ],
        ));
  }
}

class BooleanSettingWidget extends StatefulWidget {
  final Setting<bool> setting;
  final String description;
  final IconData? icon;
  final VoidCallback? onChanged;

  const BooleanSettingWidget(this.setting, {Key? key, this.description = '', this.icon, this.onChanged})
      : super(key: key);

  @override
  State<BooleanSettingWidget> createState() => _BooleanSettingWidgetState();
}

class _BooleanSettingWidgetState extends State<BooleanSettingWidget> {
  @override
  Widget build(BuildContext context) {
    return SettingWidget<bool>(
      widget.setting,
      description: widget.description,
      icon: widget.icon,
      child: Switch(
          value: widget.setting.value,
          onChanged: (val) => setState(() {
                widget.setting.value = val;
              })),
    );
  }
}

class DropDownSettingWidget<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final Setting<T> setting;
  final String description;
  final IconData? icon;
  final VoidCallback? onChanged;

  const DropDownSettingWidget(this.setting, this.items, {Key? key, this.description = '', this.icon, this.onChanged})
      : super(key: key);

  @override
  State<DropDownSettingWidget<T>> createState() => _DropDownSettingWidgetState<T>();
}

class _DropDownSettingWidgetState<T> extends State<DropDownSettingWidget<T>> {
  void valueChanged(T? newValue) {
    if (newValue == null) return;
    setState(() {
      widget.setting.value = newValue;
    });
    if (widget.onChanged != null) widget.onChanged!.call();
  }

  @override
  Widget build(BuildContext context) {
    return SettingWidget<T>(
      widget.setting,
      description: widget.description,
      icon: widget.icon,
      child: DropdownButton<T>(
        items: widget.items,
        onChanged: valueChanged,
        value: widget.setting.value,
      ),
    );
  }
}

class TextSettingWidget extends StatefulWidget {
  final Setting<String> setting;
  final String description;
  final IconData? icon;
  final VoidCallback? onChanged;

  const TextSettingWidget(this.setting, {Key? key, this.description = '', this.icon, this.onChanged}) : super(key: key);

  @override
  State<TextSettingWidget> createState() => _TextSettingWidgetStatetate();
}

class _TextSettingWidgetStatetate extends State<TextSettingWidget> {
  @override
  Widget build(BuildContext context) {
    String a = widget.setting.value;
    return SettingWidget<String>(
      widget.setting,
      description: widget.description,
      icon: widget.icon,
      child: Container(
        child: TextFormField(
            initialValue: widget.setting.value,
            onFieldSubmitted: (val) => setState(() {
                  widget.setting.value = val;
                })),
      ),
    );
  }
}
