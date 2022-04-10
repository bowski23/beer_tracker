import 'package:flutter/material.dart';
import 'package:beer_tracker/models/settings.dart';

class SettingRow extends StatelessWidget {
  final Widget input;
  final String description;

  const SettingRow(this.input, this.description);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [input, Text(description)],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Einstellungen")),
        body: Container(
          child: ListView(
            children: [
              DropDownSettingWidget<CounterMode>(
                  Settings.counterMode,
                  [
                    DropdownMenuItem<CounterMode>(
                      child: Text('Jährlich'),
                      value: CounterMode.year,
                    ),
                    DropdownMenuItem<CounterMode>(
                      child: Text('Gesamt'),
                      value: CounterMode.total,
                    )
                  ],
                  description: 'Welchen Biercount der Hauptcounter zeigen soll',
                  icon: Icons.more_time)
            ],
          ),
        ));
  }
}

class SettingWidget<T> extends StatelessWidget {
  Setting<T> _setting;
  String description;
  IconData? icon;
  Widget child;

  SettingWidget(this._setting, {required this.child, this.description = '', this.icon}) {
    if (description.isEmpty) {
      description = _setting.value.runtimeType.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))),
        margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Row(
          children: [
            Container(
              child: SizedBox(width: 50, height: 40, child: icon != null ? Icon(icon) : null),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Theme.of(context).dividerColor.withAlpha(128)))),
            ),
            Flexible(
              child: Text(
                description,
                overflow: TextOverflow.fade,
                maxLines: 3,
              ),
            ),
            Container(constraints: BoxConstraints(minWidth: 100), child: child, margin: EdgeInsets.only(left: 10))
          ],
        ));
  }
}

class DropDownSettingWidget<T extends Enum> extends StatelessWidget {
  List<DropdownMenuItem<T>> items;
  Setting<T> setting;
  String description;
  IconData? icon;

  DropDownSettingWidget(
    this.setting,
    this.items, {
    this.description = '',
    this.icon,
  });

  void valueChanged(T? newValue) {
    if (newValue == null) return;
    setting.value = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return SettingWidget<T>(
      setting,
      child: DropdownButton<T>(
        items: items,
        onChanged: valueChanged,
        value: setting.value,
      ),
      description: description,
      icon: icon,
    );
  }
}
