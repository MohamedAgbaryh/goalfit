import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class WorkoutsScreen extends StatefulWidget {
  @override
  _WorkoutsScreenState createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  List workouts = [];

  Future<void> loadWorkouts() async {
    String jsonString = await rootBundle.loadString('assets/data/workouts.json');
    setState(() {
      workouts = json.decode(jsonString);
    });
  }

  @override
  void initState() {
    super.initState();
    loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workouts")),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(workouts[index]['name']),
            subtitle: Text("Duration: ${workouts[index]['duration']}"),
          );
        },
      ),
    );
  }
}
