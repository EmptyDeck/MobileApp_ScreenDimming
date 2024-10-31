import 'package:flutter/material.dart';
import '../widgets/color_picker.dart';
import '../widgets/time_selector.dart';
import 'dimming_page.dart';

class SleepSettingsPage extends StatefulWidget {
  @override
  _SleepSettingsPageState createState() => _SleepSettingsPageState();
}

class _SleepSettingsPageState extends State<SleepSettingsPage> {
  Color selectedColor = Colors.orange;
  int totalTimeInSeconds = 0;

  void updateTime(int seconds) {
    setState(() {
      totalTimeInSeconds += seconds;
      if (totalTimeInSeconds < 0) totalTimeInSeconds = 0;
    });
  }

  void clearTime() {
    setState(() {
      totalTimeInSeconds = 0;
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Settings'),
      ),
      backgroundColor: const Color.fromARGB(
          255, 159, 192, 207), // Replace with your desired color
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          // Center the content horizontally and vertically
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content vertically
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              // Color Picker
              ColorPickerWidget(
                initialColor: selectedColor,
                onColorSelected: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
              SizedBox(height: 20),
              // Time Selector
              TimeSelectorWidget(
                onTimeAdded: updateTime,
                onClear: clearTime,
              ),
              SizedBox(height: 10),
              // Display Selected Time
              Text(
                'Total Time: ${formatTime(totalTimeInSeconds)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20), // Add space before the button
              // Start Button
              ElevatedButton(
                onPressed: totalTimeInSeconds > 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DimmingPage(
                              totalTime: totalTimeInSeconds,
                              color: selectedColor,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 30, // Set font size
                    fontWeight: FontWeight.bold, // Optional: Set font weight
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
