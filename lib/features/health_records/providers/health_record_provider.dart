import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_helper.dart';
import '../models/health_record.dart';
import 'package:intl/intl.dart';

class HealthRecordProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  List<HealthRecord> _records = [];
  HealthRecord? _latestRecord;
  double? bmi;
  String bmiStatus = "Not calculated yet";
  List<HealthRecord> get records {
    return _records;
  }
  HealthRecord? get latestRecord {
    return _latestRecord;
  }
  int get steps {
    return _latestRecord?.steps ?? 0;
  }
  double get calories {
    return _latestRecord?.calories ?? 0.0;
  }
  double get waterLevel {
    return _latestRecord?.waterLevel ?? 0.0;
  }
  double get sleepHours {
    return _latestRecord?.sleepHours ?? 0.0;
  }
  HealthRecordProvider() {
    _loadBMIPrefs();
  }
  // Load all records
  Future<void> loadAllRecords() async {
    _records = await dbHelper.getAllRecords();
    await _updateLatestRecord();
    notifyListeners();
  }
  // Load latest record
  Future<void> loadLatestRecord() async {
    await _updateLatestRecord();
    notifyListeners();
  }
  // Update latest record
  Future<void> _updateLatestRecord() async {
    if (_records.isNotEmpty) {
      final dateFormat = DateFormat('yyyy-MM-dd');
      _records.sort((a, b) {
        final dateA = dateFormat.parse(a.date);
        final dateB = dateFormat.parse(b.date);
        return dateB.compareTo(dateA);
      });
      _latestRecord = _records.first;
    }
  }
  // Filter by date
  Future<void> filterByDate(String date) async {
    if (date.isEmpty) {
      await loadAllRecords();
      return;
    }
    _records = await dbHelper.getRecordsByDate(date);
    await _updateLatestRecord();
    notifyListeners();
  }
  // Add record
  Future<void> addRecord(HealthRecord record) async {
    await dbHelper.insertRecord(record);
    await loadAllRecords();
  }
  // Update record
  Future<void> updateRecord(HealthRecord record) async {
    await dbHelper.updateRecord(record);
    await loadAllRecords();
  }
  // Delete record
  Future<void> deleteRecord(int id) async {
    await dbHelper.deleteRecord(id);
    await loadAllRecords();
  }
  // BMI calculation
  void calculateBMI(double heightCm, double weightKg) {
    double heightM = heightCm / 100;
    double result = weightKg / (heightM * heightM);
    bmi = double.parse(result.toStringAsFixed(1));
    if (bmi! < 18.5) {
      bmiStatus = "Underweight";
    } else if (bmi! < 25) {
      bmiStatus = "Normal";
    } else if (bmi! < 30) {
      bmiStatus = "Overweight";
    } else {
      bmiStatus = "Obese";
    }
    notifyListeners();
    _saveBMIPrefs();
  }
  Future<void> _saveBMIPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bmi', bmi!);
    await prefs.setString('bmiStatus', bmiStatus);
  }
  Future<void> _loadBMIPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bmi = prefs.getDouble('bmi');
    bmiStatus = prefs.getString('bmiStatus') ?? "Not calculated yet";
    notifyListeners();
  }
}
