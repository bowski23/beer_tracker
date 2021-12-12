import 'package:beer_tracker/entry_storage.dart';
import 'package:beer_tracker/models/beer_entry.dart';
import 'package:beer_tracker/ui/beer_button.dart';
import '../ui/beer_button.dart';
import 'package:flutter/material.dart';
import 'beer_add_page.dart';
import 'package:intl/intl.dart';
import 'sub_pages/archive_page.dart';
import 'sub_pages/overview_page.dart';
import 'sub_pages/standard_beer_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ValueNotifier<int> _counter = ValueNotifier(0);
  int _navIndex = 0;
  ValueNotifier<List<Text>> _topBeers = ValueNotifier([]);
  Widget shownPage;

  _MainPageState() {
    shownPage = OverviewPage(counter: _counter);
    var storage = EntryStorage.get();
    var countFuture = storage.countEntries();
    countFuture.then((value) => setState(() {
          _counter.value = value;
        }));
    _updateTopBeers();
  }

  void _updateTopBeers({int count = 100}) async {
    var storage = EntryStorage.get();
    var entries = await storage.getEntries(count: count);
    List<Text> topBeers = [];
    final f = new DateFormat('dd.MM.yyyy H:mm');
    for (var entry in entries) {
      topBeers.add(Text(
          '${f.format(entry.date.toLocal())} - ${entry.brand} ${entry.volume}l'));
    }
    setState(() {
      _topBeers.value = topBeers;
    });
  }

  void _addBeer() async {
    var storage = EntryStorage.get();

    final standard = await storage.getStandardEntry();
    await storage.saveEntry(BeerEntry(
        brand: standard.brand,
        date: DateTime.now(),
        form: standard.form,
        volume: standard.volume));
    int entries = await storage.countEntries();
    _counter.value = entries;
    _updateTopBeers();
  }

  void _navigate(int index) async {
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_navIndex) {
      case 0:
        shownPage = OverviewPage(counter: _counter);
        break;
      case 1:
        shownPage = StandardBeerPage();
        break;
      case 2:
        shownPage = ArchivePage(topBeers: _topBeers);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: "Übersicht"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: "Standardbier"),
            BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archiv"),
          ],
          onTap: _navigate,
          currentIndex: _navIndex,
          backgroundColor: Theme.of(context).popupMenuTheme.color,
        ),
        body: shownPage,
        floatingActionButton: BeerButton(
          onPressed: _addBeer,
          onLongPress: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddBeerPage();
            }));
            this._updateTopBeers();
          },
        )); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
