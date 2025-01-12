import 'package:beer_tracker/entry_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../ui/beer_button.dart';
import '../models/beer_volumes.dart';
import '../models/beer_entry.dart';
import '../models/beer_consumptionForms.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddBeerPage extends StatefulWidget {
  AddBeerPage({Key? key, this.title = ''}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  AddBeerPageState createState() => AddBeerPageState();
}

class AddBeerPageState extends State<AddBeerPage> {
  double chosenVolume = volumes[0].volume;
  String chosenDrinkForm = consumptionForms.first;
  String brand = '';
  String note = '';
  List<String> beerBrands = [];
  DateTime? chosenDate;
  TextEditingController brandTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AddBeerPageState();

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

  Future<void> getBeerBrands() async {
    beerBrands = await EntryStorage.get().getBeerBrands();
  }

  void addBeer(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final db = EntryStorage.get();
      db.saveEntry(BeerEntry(
          brand: this.brand,
          volume: this.chosenVolume,
          form: this.chosenDrinkForm,
          note: this.note,
          date: chosenDate == null ? DateTime.now() : chosenDate!));
      getBeerBrands();
      Navigator.pop(context, true);
    }
  }

  Future<List<String>> suggestBrand(String pattern) async {
    if (beerBrands.isEmpty) {
      await getBeerBrands();
    }
    RegExp pat = RegExp(pattern, caseSensitive: false, unicode: true);
    List<String> foundBrands = beerBrands.where((str) => str.contains(pat)).toList();
    foundBrands.sort((a, b) {
      bool aStart = a.startsWith(pat);
      bool bStart = b.startsWith(pat);

      if (aStart == bStart) return a.compareTo(b);
      if (aStart) {
        return -1;
      } else {
        return 1;
      }
    });
    return foundBrands;
  }

  Widget buildSuggestion(BuildContext context, String suggestion) {
    return ListTile(title: Text(suggestion));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> forms = [
      TypeAheadField(
        suggestionsCallback: suggestBrand,
        itemBuilder: buildSuggestion,
        onSuggestionSelected: (suggestion) {
          if (suggestion != null) {
            this.brand = suggestion.toString();
            this.brandTextController.text = suggestion.toString();
          }
        },
        textFieldConfiguration: TextFieldConfiguration(
            controller: brandTextController,
            decoration: const InputDecoration(icon: Icon(Icons.local_drink_rounded), labelText: 'Marke'),
            onChanged: (value) {
              this.brand = value;
            }),
        getImmediateSuggestions: true,
        hideOnEmpty: true,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(color: Theme.of(context).popupMenuTheme.color),
      ),
      DropdownButtonFormField<double>(
        elevation: 0,
        value: chosenVolume,
        decoration: const InputDecoration(labelText: 'Volumen'),
        items: getBeerVolumes(context),
        onChanged: (double? value) {
          if (value != null) this.chosenVolume = value;
        },
      ),
      DropdownButtonFormField<String>(
        value: chosenDrinkForm,
        elevation: 0,
        items: getBeerConsumptionForms(context),
        decoration: const InputDecoration(labelText: 'Form'),
        onChanged: (String? value) {
          if (value != null) this.chosenDrinkForm = value;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(icon: Icon(Icons.note_add), labelText: 'Vermerk'),
        onChanged: (newValue) {
          this.note = newValue;
        },
      )
    ];

    if (kDebugMode) {
      forms.add(DateTimeField(
        format: DateFormat.yMMMMd(),
        onShowPicker: (context, currentValue) async {
          var time = await showDatePicker(
              context: context,
              initialDate: currentValue ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(Duration(days: 30)));
          chosenDate = time;
          return time;
        },
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bier Details'),
      ),
      body: Center(
          child: Container(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(children: forms),
              ))),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: BeerButton(
        onPressed: () {
          addBeer(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
