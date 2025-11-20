import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HealthRecord {
  int? id;
  String date;
  int steps;
  double calories;
  double waterLevel;
  double sleepHours;

  HealthRecord({
    this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.waterLevel,
    required this.sleepHours,
  });

  /// Format a DateTime into a string using intl
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['date'] = date;
    map['steps'] = steps;
    map['calories'] = calories;
    map['waterLevel'] = waterLevel;
    map['sleepHours'] = sleepHours;
    return map;
  }

  static HealthRecord fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      steps: map['steps'] as int,
      calories: (map['calories'] as num).toDouble(),
      waterLevel: (map['waterLevel'] as num).toDouble(),
      sleepHours: (map['sleepHours'] as num).toDouble(),
    );
  }
}
