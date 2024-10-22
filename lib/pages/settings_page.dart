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
          child: ValueListenableBuilder(
            valueListenable: Settings.publishToDiscord.notifier,
            builder: (context, value, child) => ListView(
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
                    icon: Icons.more_time),
                BooleanSettingWidget(
                  Settings.publishToDiscord,
                  description: "Verkünde auf Discord Raumer 7, wenn du ein Bier trinkst.",
                  icon: Icons.sports_sharp,
                ),
                if (Settings.publishToDiscord.value)
                  TextSettingWidget(Settings.publishToDiscordName,
                      description: "Dein Name für Discord.", icon: Icons.account_circle)
              ],
            ),
          ),
        ));
  }
}
