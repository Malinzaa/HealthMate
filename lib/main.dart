import 'package:flutter/material.dart';
import 'features/health_records/screens/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:health_mate/features/health_records/providers/health_record_provider.dart';
import 'package:health_mate/features/health_records/screens/view_records.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) {
              return HealthRecordProvider();
            },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HealthMate",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1BBFA7),
        scaffoldBackgroundColor: Color(0xFFFCF2D4),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1BBFA7),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1BBFA7),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: Dashboard(),
    );
  }
}

