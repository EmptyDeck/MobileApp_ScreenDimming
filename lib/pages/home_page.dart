import 'package:flutter/material.dart';
import 'sleep_settings_page.dart';
import 'wake_settings_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          // Left side - Wake Up
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WakeSettingsPage()),
              );
            },
            child: Container(
              width: width / 2,
              color:
                  Color(0xFFFFFFC5), // Replace with actual light yellow color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
                    SizedBox(height: 20),
                    Text('Wake Up', style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
            ),
          ),
          // Right side - Sleep
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SleepSettingsPage()),
              );
            },
            child: Container(
              width: width / 2,
              color: Colors.indigo[900], // Dark navy color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.nights_stay, size: 100, color: Colors.white),
                    SizedBox(height: 20),
                    Text('Sleep',
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
