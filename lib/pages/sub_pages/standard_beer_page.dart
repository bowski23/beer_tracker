import 'package:beer_tracker/models/beer_consumptionForms.dart';
import 'package:beer_tracker/models/beer_volumes.dart';
import 'package:beer_tracker/models/standard_beer_entry.dart';
import 'package:flutter/material.dart';

import '../../entry_storage.dart';

class StandardBeerPage extends StatefulWidget {
  StandardBeerPage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _StandardBeerPageState createState() => _StandardBeerPageState();
}

class _StandardBeerPageState extends State<StandardBeerPage> {
  _StandardBeerPageState();

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
          brand: this.brand,
          validUntil: DateTime.now().add(Duration(hours: 16)),
          volume: this.chosenVolume,
          form: this.chosenDrinkForm));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Text("Dein Bier für die nächsten 16 Stunden."),
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
                  dropdownColor: Theme.of(context).popupMenuTheme.color,
                  decoration: const InputDecoration(labelText: 'Volumen'),
                  items: getBeerVolumes(context),
                  onChanged: (double? value) {
                    if (value != null) this.chosenVolume = value;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: chosenDrinkForm,
                  elevation: 0,
                  dropdownColor: Theme.of(context).popupMenuTheme.color,
                  items: getBeerConsumptionForms(context),
                  decoration: const InputDecoration(labelText: 'Form'),
                  onChanged: (String? value) {
                    if (value != null) this.chosenDrinkForm = value;
                  },
                ),
              ]),
            ),
            ElevatedButton(
                onPressed: () {
                  saveStandardBeer();
                },
                child: Text('Speichern'))
          ],
        ),
        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16));
  }
}
