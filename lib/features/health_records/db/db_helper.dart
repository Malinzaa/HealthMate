import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/health_record.dart';

class DBHelper {
  // Singleton instance
  static final DBHelper _instance = DBHelper._internal();

  // Factory constructor
  factory DBHelper() {
    return _instance;
  }

  // Internal constructor
  DBHelper._internal();

  Database? _db;

  // Getter for database
  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDB();
      return _db!;
    }
  }

  // Initialize the database
  Future<Database> initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'healthmate.db');

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL,
        calories REAL NOT NULL,
        waterLevel REAL NOT NULL,
        sleepHours REAL NOT NULL
      )
    ''');

    await db.insert('health_records', <String, dynamic>{
      'date': '2025-11-16',
      'steps': 4500,
      'calories': 300.0,
      'waterLevel': 1200.0,
      'sleepHours': 6.5
    });

    await db.insert('health_records', <String, dynamic>{
      'date': '2025-11-15',
      'steps': 6000,
      'calories': 400.0,
      'waterLevel': 1500.0,
      'sleepHours': 7.0
    });
  }

  // Insert a new record
  Future<int> insertRecord(HealthRecord record) async {
    Database db = await database;
    int id = await db.insert('health_records', record.toMap());
    return id;
  }

  // Get all records
  Future<List<HealthRecord>> getAllRecords() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'health_records',
      orderBy: 'date DESC',
    );

    List<HealthRecord> records = <HealthRecord>[];
    for (int i = 0; i < result.length; i++) {
      records.add(HealthRecord.fromMap(result[i]));
    }

    return records;
  }

  // Get latest record
  Future<HealthRecord?> getLatestRecord() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'health_records',
      orderBy: 'date DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      HealthRecord record = HealthRecord.fromMap(result.first);
      return record;
    } else {
      return null;
    }
  }

  // Get records by date
  Future<List<HealthRecord>> getRecordsByDate(String date) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'health_records',
      where: 'date = ?',
      whereArgs: <dynamic>[date],
      orderBy: 'date DESC',
    );

    List<HealthRecord> records = <HealthRecord>[];
    for (int i = 0; i < result.length; i++) {
      records.add(HealthRecord.fromMap(result[i]));
    }

    return records;
  }

  // Update a record
  Future<int> updateRecord(HealthRecord record) async {
    Database db = await database;
    int count = await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: <dynamic>[record.id],
    );
    return count;
  }

  // Delete a record
  Future<int> deleteRecord(int id) async {
    Database db = await database;
    int count = await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: <dynamic>[id],
    );
    return count;
  }

  // Close the database
  Future<void> close() async {
    Database db = await database;
    await db.close();
    _db = null;
  }
}
