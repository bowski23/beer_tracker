import 'package:beer_tracker/entry_storage.dart';
import 'package:flutter/material.dart';
import '../models/standard_beer_entry.dart';
import '../models/beer_volumes.dart';
import '../models/beer_consumptionForms.dart';

class FirstLaunchPage extends StatefulWidget {
  FirstLaunchPage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _FirstLaunchPageState createState() => _FirstLaunchPageState();
}

class _FirstLaunchPageState extends State<FirstLaunchPage> {
  final _formKey = GlobalKey<FormState>();
  double chosenVolume = volumes[0].volume;
  String chosenDrinkForm = consumptionForms.first;
  String brand = '';

  List<DropdownMenuItem<double>> getBeerVolumes(BuildContext context) {
    List<DropdownMenuItem<double>> items = [];

    for (var volume in volumes) {
      String text = "";
      if (volume.name.isNotEmpty) {
        text = "${volume.name} (${volume.volume}l)";
      } else {
        text = "${volume.volume}l";
      }
      items.add(DropdownMenuItem<double>(child: Text(text, textAlign: TextAlign.center), value: volume.volume));
    }

    return items;
  }

  List<DropdownMenuItem<String>> getBeerConsumptionForms(BuildContext context) {
    List<DropdownMenuItem<String>> items = [];

    for (var form in consumptionForms) {
      String text = form;
      items.add(DropdownMenuItem<String>(child: Text(text, textAlign: TextAlign.center), value: text));
    }

    return items;
  }

  void saveStandardBeer() async {
    if (_formKey.currentState!.validate()) {
      final db = EntryStorage.get();
      db.setStandardEntry(StandardBeerEntry(
          brand: this.brand, validUntil: DateTime.utc(2100), volume: this.chosenVolume, form: this.chosenDrinkForm));
      Navigator.pushNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 64, left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          Text(
            '''Hey, danke, dass du Bier trinkst.\n\nSag uns doch welches Bier du am öftesten trinkst. Dieses Bier wird dann beim Tracker mit einem Klick hinzugefügt. Falls du mal ein anderes Bier trinkst musst du nur den Bier Button etwas länger drücken.''',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(icon: Icon(Icons.local_drink_rounded), labelText: 'Marke'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gib die Marke ein, du كلب.';
                  }
                  return null;
                },
                onChanged: (newValue) {
                  this.brand = newValue;
                },
              ),
              DropdownButtonFormField<double>(
                elevation: 0,
                value: chosenVolume,
                decoration: const InputDecoration(labelText: 'Volumen'),
                items: getBeerVolumes(context),
                onChanged: (double? value) {
                  this.chosenVolume = value ?? this.chosenVolume;
                },
              ),
              DropdownButtonFormField<String>(
                value: chosenDrinkForm,
                elevation: 0,
                items: getBeerConsumptionForms(context),
                decoration: const InputDecoration(labelText: 'Form'),
                onChanged: (String? value) {
                  this.chosenDrinkForm = value ?? this.chosenDrinkForm;
                },
              ),
            ]),
          ),
          ElevatedButton(
              onPressed: () {
                saveStandardBeer();
              },
              child: Text('Los geht\'s mit dem Trinken.'))
        ],
      ),
    ));
  }
}
