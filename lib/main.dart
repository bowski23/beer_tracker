import 'package:beer_tracker/entry_storage.dart';
import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'pages/first_launch_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EntryStorage.checkIfDbExists();
  await initializeDateFormatting(Platform.localeName);
  EntryStorage.openDb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange, brightness: Brightness.dark),
        appBarTheme: AppBarTheme(backgroundColor: Colors.orange.shade800),
        brightness: Brightness.dark,
        popupMenuTheme: PopupMenuThemeData(color: Color(0xEE444444)));

    if (EntryStorage.isDbExisting) {
      return MaterialApp(
        title: 'BeerTracker',
        theme: theme,
        home: MainPage(title: 'BeerTracker'),
      );
    } else {
      return MaterialApp(
        title: 'BeerTracker',
        theme: theme,
        home: FirstLaunchPage(title: 'BeerTracker'),
        routes: <String, WidgetBuilder>{'/main': (BuildContext context) => new MainPage(title: 'BeerTracker')},
      );
    }
  }
}
