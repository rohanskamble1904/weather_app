import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/weather_model_class.dart';


/// it is local database using sqflite to create the database, column and fetch the column
class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  factory LocalDatabase() => _instance;
  LocalDatabase._internal();

  static Database? _database;

 static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'weather3.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE weather(
            id INTEGER PRIMARY KEY,
            cloud_pct INTEGER,
            temp INTEGER,
            feels_like INTEGER,
            humidity INTEGER,
            min_temp INTEGER,
            max_temp INTEGER,
            wind_speed REAL,
            wind_degrees INTEGER,
            sunrise INTEGER,
            sunset INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> saveWeatherData(WeatherModel data) async {
   print("saving data${data.toMap()}");
    final db = await database;
   final tableInfo = await db.rawQuery("PRAGMA table_info(weather)");
   print("Table schema: $tableInfo");
    await db.delete('weather'); // Clear old data
    await db.insert('weather', data.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

 static Future<WeatherModel?> getWeatherData() async {
    final db = await database;
    final result = await db.query('weather', limit: 1);
    if(result.isNotEmpty) {
      print(result);
      return WeatherModel.fromJson(result.first);
    }
    return null;

  }
}
