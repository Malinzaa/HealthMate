import 'package:flutter/material.dart';
import '../models/health_record.dart';
import '../db/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:health_mate/features/health_records/providers/health_record_provider.dart';

class AddRecordPage extends StatefulWidget {
  @override
  _AddRecordPageState createState() {
    return _AddRecordPageState();
  }
}

class _AddRecordPageState extends State<AddRecordPage> {
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController waterController = TextEditingController();
  final TextEditingController sleepController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          title: Text(
            "Add Health Records",
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontFamily: 'Nunito',
            ),
          ),
          centerTitle: true,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                // Steps
                TextFormField(
                  controller: stepsController,
                  keyboardType: TextInputType.number,
                  cursorColor: Color(0xFF4CAF50),
                  decoration: InputDecoration(
                    labelText: "Steps Walked",
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFF4CAF50), fontSize: 20),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter steps walked';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                // Calories
                TextFormField(
                  controller: caloriesController,
                  keyboardType: TextInputType.number,
                  cursorColor: Color(0xFFD65831),
                  decoration: InputDecoration(
                    labelText: "Calories Burned",
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD65831), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD65831), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFD65831), fontSize: 20),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter calories burned';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                // Water
                TextFormField(
                  controller: waterController,
                  keyboardType: TextInputType.number,
                  cursorColor: Color(0xFF4A90E2),
                  decoration: InputDecoration(
                    labelText: "Water Intake Level (ml)",
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFF4A90E2), fontSize: 20),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter water level';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                // Sleep
                TextFormField(
                  controller: sleepController,
                  keyboardType: TextInputType.number,
                  cursorColor: Color(0xFF9F4EAD),
                  decoration: InputDecoration(
                    labelText: "Sleep Duration (hrs)",
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9F4EAD), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9F4EAD), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFF9F4EAD), fontSize: 20),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter sleeping hours';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 70),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      HealthRecord newRecord = HealthRecord(
                        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        steps: int.tryParse(stepsController.text.trim()) ?? 0,
                        calories:
                        double.tryParse(caloriesController.text.trim()) ?? 0.0,
                        waterLevel:
                        double.tryParse(waterController.text.trim()) ?? 0.0,
                        sleepHours:
                        double.tryParse(sleepController.text.trim()) ?? 0.0,
                      );

                      await dbHelper.insertRecord(newRecord);

                      Provider.of<HealthRecordProvider>(context, listen: false)
                          .loadAllRecords();
                      Provider.of<HealthRecordProvider>(context, listen: false)
                          .loadLatestRecord();

                      Navigator.pop(context, true);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Health Record Added Successfully!"),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text("Add Record"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
