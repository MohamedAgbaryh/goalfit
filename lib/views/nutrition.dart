import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class NutritionScreen extends StatefulWidget {
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  List meals = [];

  Future<void> loadMeals() async {
    String jsonString = await rootBundle.loadString('assets/data/nutrition.json');
    setState(() {
      meals = json.decode(jsonString);
    });
  }

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meal Plan")),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(meals[index]['name']),
            subtitle: Text("Calories: ${meals[index]['calories']}"),
          );
        },
      ),
    );
  }
}
