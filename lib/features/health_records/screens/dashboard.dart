import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_record_provider.dart';
import 'add_record.dart';
import 'view_records.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthRecordProvider>(context, listen: false)
          .loadLatestRecord();
    });
  }

  void _showBMIDialog() {
    TextEditingController heightController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("BMI Calculator",
            style: TextStyle(
              fontFamily: 'Lato',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Height (cm)"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Weight (kg)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
              style: TextButton.styleFrom(foregroundColor: Colors.brown),
            ),
            ElevatedButton(
              onPressed: () {
                double? h = double.tryParse(heightController.text);
                double? w = double.tryParse(weightController.text);

                if (h != null && w != null) {
                  Provider.of<HealthRecordProvider>(context, listen: false)
                      .calculateBMI(h, w);
                }
                Navigator.pop(context);
              },
              child: Text("Calculate"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          elevation: 2,
          flexibleSpace: Stack(
            children: [
              Positioned(
                left: 2,
                top: 26,
                child: Container(
                  width: 130,
                  height: 130,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            "HealthMate",
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Consumer<HealthRecordProvider>(
          builder: (BuildContext context, HealthRecordProvider healthData, Widget? child) {
            return Column(
              children: [
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Today's Health Overview...",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      color: Colors.brown,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 26,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.9),
                    children: [
                      _buildMetricCard("Steps Today",
                          healthData.steps.toString(), Color(0xFF4CAF50), "assets/steps.png"),
                      _buildMetricCard("Energy Burn",
                          "${healthData.calories} kcal", Color(0xFFD65831), "assets/cals.png"),
                      _buildMetricCard("Water Intake",
                          "${healthData.waterLevel} ml", Color(0xFF4A90E2), "assets/water.png"),
                      _buildMetricCard("Sleep Hours",
                          "${healthData.sleepHours} hrs", Color(0xFF9F4EAD), "assets/sleep.png"),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: _showBMIDialog,
                        child: Container(
                          height: 220,
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/bmi.png",
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "BMI",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                healthData.bmi == null
                                    ? "Tap to calculate"
                                    : "${healthData.bmi} (${healthData.bmiStatus})",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 50),
                          ElevatedButton.icon(
                            onPressed: () async {
                              bool? recordAdded = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return AddRecordPage();
                                }),
                              );
                              if (recordAdded == true) {
                              }
                            },
                            icon: Icon(Icons.add, color: Colors.white, size: 26),
                            label: Text("Add Health Record"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                            ),
                          ),
                          SizedBox(height: 18),
                          ElevatedButton.icon(
                            onPressed: () async {
                              bool? recordChanged = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return ViewRecordsPage();
                                }),
                              );
                              if (recordChanged == true) {
                                healthData.loadLatestRecord();
                              }
                            },
                            icon: Icon(Icons.list, color: Colors.white, size: 26),
                            label: Text("View Health Records"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color, String assetImage) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 45, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            assetImage,
            width: 40,
            height: 40,
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
