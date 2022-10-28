import 'package:beer_tracker/entry_storage.dart';
import 'package:beer_tracker/models/beer_entry.dart';
import 'package:beer_tracker/models/settings.dart';
import 'package:beer_tracker/ui/beer_button.dart';
import 'package:flutter/material.dart';
import 'beer_add_page.dart';
import 'package:intl/intl.dart';
import 'settings_page.dart';
import 'sub_pages/archive_page.dart';
import 'sub_pages/overview_page.dart';
import 'sub_pages/standard_beer_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ValueNotifier<int> _counter = ValueNotifier(0);
  int _navIndex = 0;
  ValueNotifier<List<Text>> _topBeers = ValueNotifier([]);
  Widget shownPage = Container();
  GlobalKey<State<StatefulWidget>> shownPageKey = GlobalKey();

  _MainPageState() {
    shownPage = OverviewPage(counter: _counter);
    var countFuture = countEntries();
    countFuture.then((value) => setState(() {
          _counter.value = value;
        }));
    _updateTopBeers();
  }

  Future<int> countEntries() async {
    var storage = EntryStorage.get();
    if (Settings.counterMode.value == CounterMode.total) {
      return await storage.countEntries();
    } else {
      return await storage.countEntries(
          dateRange: DateTimeRange(
              start: DateTime(DateTime.now().toUtc().year), end: DateTime(DateTime.now().toUtc().year + 1)));
    }
  }

// 200 beers should cover a week easily.(thats almost 30 beers a day for a whole week)
  void _updateTopBeers({int count = 200}) async {
    var storage = EntryStorage.get();
    var entries = await storage.getEntries(count: count);
    List<Text> topBeers = [];
    final f = new DateFormat('dd.MM.yyyy H:mm');
    for (var entry in entries) {
      topBeers.add(Text('${f.format(entry.date.toLocal())} - ${entry.brand} ${entry.volume}l'));
    }
    await _refreshCount(storage: storage);
    setState(() {
      _topBeers.value = topBeers;
      refreshSubPage();
    });
  }

  Future<void> _refreshCount({EntryStorage? storage}) async {
    var entryCount = await countEntries();
    _counter.value = entryCount;
  }

  void _addBeer() async {
    var storage = EntryStorage.get();

    final standard = await storage.getStandardEntry();
    await storage.saveEntry(
        BeerEntry(brand: standard.brand, date: DateTime.now(), form: standard.form, volume: standard.volume));
    _updateTopBeers();
  }

  void _navigate(int index) async {
    setState(() {
      _navIndex = index;
      refreshSubPage();
    });
  }

  void refreshSubPage() {
    var context = shownPageKey.currentContext;
    var state = shownPageKey.currentState;
    if (context != null && state != null) state.build(context);
  }

  @override
  Widget build(BuildContext context) {
    switch (_navIndex) {
      case 0:
        shownPage = OverviewPage(
          counter: _counter,
          key: shownPageKey,
        );
        break;
      case 1:
        shownPage = StandardBeerPage(key: shownPageKey);
        break;
      case 2:
        shownPage = ArchivePage(topBeers: _topBeers, key: shownPageKey);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingsPage();
                }));
                _updateTopBeers();
              },
              icon: Icon(Icons.settings))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Übersicht"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Standardbier"),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archiv"),
        ],
        onTap: _navigate,
        currentIndex: _navIndex,
        backgroundColor: Theme.of(context).popupMenuTheme.color,
        selectedItemColor: Theme.of(context).cardColor,
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
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
