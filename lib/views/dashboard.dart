import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  int _hoverIndex = -1;

  final List<String> motivationalQuotes = [
    "Believe in yourself and all that you are! 💪",
    "Every workout is progress. Keep going! 🚀",
    "Success starts with self-discipline. 🌟",
    "Push yourself, because no one else will. 🔥",
  ];

  String get randomQuote =>
      motivationalQuotes[DateTime.now().second % motivationalQuotes.length];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // ✅ Full-Screen Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/workoutbackground.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Main Dashboard Content
          SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildFitnessOverview(isDarkMode),
                  SizedBox(height: 20),
                  _buildWorkoutSection(),
                  SizedBox(height: 20),
                  _buildMotivationalQuote(),
                  SizedBox(height: 20),
                  _buildWeeklyGraph(isDarkMode),
                ],
              ),
            ),
          ),
        ],
      ),

      // ✅ Animated Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        selectedItemColor: Colors.green.shade600,
        unselectedItemColor: Colors.grey,
        items: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.bar_chart, "Stats", 1),
          _buildNavItem(Icons.person, "Profile", 2),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: (_currentIndex == index)
            ? (Matrix4.identity()..scale(1.3)) // ✅ Correct syntax
            : Matrix4.identity(),
        child: Icon(icon),
      ),
      label: label,
    );
  }


  // ✅ Fitness Progress Overview
  Widget _buildFitnessOverview(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900]?.withOpacity(0.8) : Colors.green.shade100.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Your Daily Progress",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _progressCard("Steps", "7,230", Icons.directions_walk),
              _progressCard("Calories", "1,500 kcal", Icons.local_fire_department),
              _progressCard("Workouts", "3 Sessions", Icons.fitness_center),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.green.shade600),
        SizedBox(height: 5),
        Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(title, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // ✅ Animated Workout Recommendations
  Widget _buildWorkoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommended Workouts",
          style: GoogleFonts.poppins(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black.withOpacity(0.7),
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _workoutCard("Push-ups", "assets/images/pushups.webp", 0)),
            SizedBox(width: 10),
            Expanded(child: _workoutCard("Running", "assets/images/run.jpg", 1)),
            SizedBox(width: 10),
            Expanded(child: _workoutCard("Cycling", "assets/images/cycling.jpg", 2)),
          ],
        ),
      ],
    );
  }

  Widget _workoutCard(String title, String imagePath, int index) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverIndex = index),
      onExit: (_) => setState(() => _hoverIndex = -1),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: _hoverIndex == index ? 170 : 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            color: Colors.black.withOpacity(0.6),
            padding: EdgeInsets.all(8),
            child: Text(
              title,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Motivational Quote
  Widget _buildMotivationalQuote() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.shade600.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          randomQuote,
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ✅ Weekly Progress Graph
  Widget _buildWeeklyGraph(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900]?.withOpacity(0.8) : Colors.green.shade100.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text("Weekly Progress", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [FlSpot(0, 3), FlSpot(1, 5), FlSpot(2, 8), FlSpot(3, 7), FlSpot(4, 6)],
                    isCurved: true,
                    color: Colors.blue,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
