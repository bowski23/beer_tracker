import 'dart:async';

import 'package:beer_tracker/helpers/webhook_helper.dart';
import 'package:beer_tracker/models/settings.dart';
import 'package:beer_tracker/models/standard_beer_entry.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/beer_entry.dart';

class EntryStorage {
  static EntryStorage? _instance;
  static bool isDbExisting = false;
  Future<Database>? database;

  EntryStorage._();

  static void openDb() async {
    if (EntryStorage._instance == null) {
      _instance = EntryStorage._();
      _instance!.database = _instance!.init();
    }
  }

  static Future<void> checkIfDbExists() async {
    isDbExisting = await databaseFactory.databaseExists(join(await getDatabasesPath(), 'beer_entries.db'));
    return;
  }

  static EntryStorage get() {
    if (_instance == null) {
      openDb();
    }
    return _instance!;
  }

  Future<Database> init() async {
    return openDatabase(
      join(await getDatabasesPath(), 'beer_entries.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE beerEntry(id TEXT PRIMARY KEY, brand TEXT, volume REAL, date INTEGER, hasImage INTEGER, note TEXT, form TEXT)');
        await db
            .execute('CREATE TABLE standardEntry(brand TEXT, volume REAL, validUntil INTEGER PRIMARY KEY, form TEXT)');
        return db.execute('CREATE TABLE settings(key TEXT PRIMARY KEY, value TEXT)');
      },
      version: 1,
    );
  }

  Future<void> saveEntry(BeerEntry entry) async {
    final Database db = await database!;

    if (Settings.publishToDiscord.value) publishToDiscord(entry);

    await db.insert('beerEntry', entry.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<BeerEntry> getEntry(String id) async {
    final Database db = await database!;

    final List<Map<String, dynamic>> list = await db.query('beerEntry', where: 'id = ?', whereArgs: [id]);
    return BeerEntry.fromMap(list.first);
  }

  Future<StandardBeerEntry> getStandardEntry() async {
    final Database db = await database!;
    final date = DateTime.now();
    final List<Map<String, dynamic>> list = await db.query('standardEntry',
        where: 'validUntil > ?', whereArgs: [date.millisecondsSinceEpoch], orderBy: "validUntil", limit: 1);
    return StandardBeerEntry.fromMap(list.first);
  }

  Future<void> cleanStandardEntries() async {
    final Database db = await database!;
    final date = DateTime.now();
    await db.delete(
      'standardEntry',
      where: 'validUntil <= ?',
      whereArgs: [date.millisecondsSinceEpoch],
    );
  }

  Future<void> setStandardEntry(StandardBeerEntry entry) async {
    final Database db = await database!;
    await db.insert('standardEntry', entry.toMap());
    return;
  }

  Future<List<String>> getBeerBrands() async {
    final Database db = await database!;

    final List<Map<String, dynamic>> brandsMap =
        await db.query('beerEntry', groupBy: 'brand', orderBy: 'MAX(date) DESC', columns: ['brand']);

    return brandsMap.map<String>((entry) => entry['brand']).toList();
  }

  Future<List<BeerEntry>> getEntries({DateTime? from, DateTime? to, String? brand, int count = -1}) async {
    final Database db = await database!;

    String? whereStr;
    List whereArgs = [];

    if (from != null) {
      whereStr = "date > ?";
      whereArgs.add(from);
    }
    if (to != null) {
      if (whereStr != null)
        whereStr += " AND ";
      else {
        whereStr = '';
      }
      whereStr += "date < ?";
      whereArgs.add(to);
    }
    if (brand != null && brand.isNotEmpty) {
      if (whereStr != null)
        whereStr += " AND ";
      else {
        whereStr = '';
      }
      whereStr += "brand = ?";
      whereArgs.add(brand);
    }

    final List<Map<String, dynamic>> maps =
        await db.query('beerEntry', limit: count, where: whereStr, whereArgs: whereArgs, orderBy: "date DESC");

    return List.generate(maps.length, (i) => BeerEntry.fromMap(maps[i]));
  }

  Future<void> resetDB() async {
    final db = await this.database!;
    db.close();
    await databaseFactory.deleteDatabase(join(await getDatabasesPath(), 'beer_entries.db'));
    this.database = this.init();
  }

  Future<int> countEntries({DateTimeRange? dateRange}) async {
    final Database db = await database!;

    String query = 'SELECT COUNT(*) FROM beerEntry';

    if (dateRange != null) {
      int start = dateRange.start.millisecondsSinceEpoch;
      int end = dateRange.end.millisecondsSinceEpoch;
      query += ' WHERE date > $start AND date < $end';
    }

    int? result = Sqflite.firstIntValue(await db.rawQuery(query));
    return result != null ? result : 0;
  }

  Future<List<int>> countEntriesByDay() async {
    final Database db = await database!;

    String query =
        '''SELECT COUNT(date) as amount, strftime(\'%w\',date([date]/1000,\'unixepoch\',\'localtime\')) as day
FROM beerEntry 
WHERE strftime(\'%W\',date(),\'localtime\')  = strftime(\'%W\',date([date]/1000,\'unixepoch\',\'localtime\')) 
GROUP BY strftime(\'%w\',date([date]/1000,\'unixepoch\',\'localtime\'))''';
    var a = (await db.rawQuery(query));
    List<int> dateCounts = [0, 0, 0, 0, 0, 0, 0];
    for (var b in a) {
      int day = int.parse(b['day'] as String);
      //convert to 0 = monday
      day = (day - 1) % 7;
      dateCounts[day] += b['amount'] as int;
    }
    return dateCounts;
  }
}
