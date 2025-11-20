import 'package:flutter/material.dart';
import 'package:health_mate/features/health_records/providers/health_record_provider.dart';
import '../db/db_helper.dart';
import '../models/health_record.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ViewRecordsPage extends StatefulWidget {
  @override
  _ViewRecordsPageState createState() {
    return _ViewRecordsPageState();
  }
}

class _ViewRecordsPageState extends State<ViewRecordsPage> {
  TextEditingController searchController = TextEditingController();
  bool _recordsChanged = false;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      Provider.of<HealthRecordProvider>(context, listen: false).loadAllRecords();
      _isLoaded = true;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }


  Future<void> _editRecordDialog(int index) async {
    final provider = Provider.of<HealthRecordProvider>(context, listen: false);
    HealthRecord record = provider.records[index];

    TextEditingController stepsController = TextEditingController(text: record.steps.toString());
    TextEditingController caloriesController = TextEditingController(text: record.calories.toString());
    TextEditingController waterController = TextEditingController(text: record.waterLevel.toString());
    TextEditingController sleepController = TextEditingController(text: record.sleepHours.toString());

    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Record",
            style: TextStyle(
              fontFamily: 'Lato',
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: stepsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Steps walked"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Calories Burned"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: waterController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Water Intake (ml)"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: sleepController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Sleep Duration (hrs)"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
              style: TextButton.styleFrom(foregroundColor: Colors.brown),
            ),
            ElevatedButton(
              onPressed: () async {
                HealthRecord updated = HealthRecord(
                  id: record.id,
                  date: record.date,
                  steps: int.tryParse(stepsController.text) ?? record.steps,
                  calories: double.tryParse(caloriesController.text) ?? record.calories,
                  waterLevel: double.tryParse(waterController.text) ?? record.waterLevel,
                  sleepHours: double.tryParse(sleepController.text) ?? record.sleepHours,
                );

                await provider.updateRecord(updated);
                _recordsChanged = true;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Record updated successfully!"),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRecordDialog(int index) async {
    final provider = Provider.of<HealthRecordProvider>(context, listen: false);
    HealthRecord record = provider.records[index];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Record",
            style: TextStyle(
              fontFamily: 'Lato',
            ),
          ),
          content: Text("Are you sure you want to delete this record?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
              style: TextButton.styleFrom(foregroundColor: Colors.brown),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                await provider.deleteRecord(record.id!);
                _recordsChanged = true;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Record deleted successfully!"),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecordCard(int index) {
    final provider = Provider.of<HealthRecordProvider>(context, listen: false);
    HealthRecord record = provider.records[index];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              formatDate(DateTime.parse(record.date)),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Steps Walked: " + record.steps.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Calories Burned: " + record.calories.toString() + " kcal",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD65831),
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Water Intake: " + record.waterLevel.toString() + " ml",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A90E2),
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Sleep Duration: " + record.sleepHours.toString() + " hrs",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9F4EAD),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _editRecordDialog(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteRecordDialog(index);
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _recordsChanged);
        return false;
      },
      child: Consumer<HealthRecordProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: AppBar(
                title: Text(
                  "Health Records",
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                      hintText: "Select a date to search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );

                      if (picked != null) {
                        String dbFormatted = DateFormat('yyyy-MM-dd').format(picked);
                        String displayFormatted = DateFormat('dd MMM yyyy').format(picked);
                        searchController.text = displayFormatted;
                        await provider.filterByDate(dbFormatted);
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.records.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildRecordCard(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
