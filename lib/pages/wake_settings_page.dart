// wake_settings_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/color_picker.dart';
import '../widgets/time_selector.dart';
import 'brightening_page.dart';

class WakeSettingsPage extends StatefulWidget {
  @override
  _WakeSettingsPageState createState() => _WakeSettingsPageState();
}

class _WakeSettingsPageState extends State<WakeSettingsPage> {
  Color selectedColor = Colors.orange; // Default color set to orange
  TimeOfDay wakeUpTime = TimeOfDay.now();
  int brightenDurationInSeconds = 0; // Brighten duration in seconds

  @override
  void initState() {
    super.initState();
    // You can load saved preferences here if needed
  }

  void pickWakeUpTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: wakeUpTime,
    );
    if (time != null) {
      setState(() {
        wakeUpTime = time;
      });
    }
  }

  void startWakeUpSequence() {
    if (brightenDurationInSeconds > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrighteningPage(
            wakeUpTime: wakeUpTime,
            brightenDuration: brightenDurationInSeconds,
            color: selectedColor,
          ),
        ),
      );
    } else {
      // Show an alert if brighten duration is not set
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Duration'),
          content: Text('Please select a brighten duration.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    // Format the wake-up time for display
    final now = DateTime.now();
    final wakeUpDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      wakeUpTime.hour,
      wakeUpTime.minute,
    );
    final formattedTime = DateFormat('h:mm a').format(wakeUpDateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Wake-Up Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
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
            // Wake-Up Time Picker
            ListTile(
              title: Text('Wake-Up Time: $formattedTime'),
              trailing: Icon(Icons.access_time),
              onTap: pickWakeUpTime,
            ),
            SizedBox(height: 20),
            // Time Selector for Brighten Duration
            TimeSelectorWidget(
              onTimeAdded: (seconds) {
                setState(() {
                  brightenDurationInSeconds += seconds;
                  if (brightenDurationInSeconds < 0) {
                    brightenDurationInSeconds = 0;
                  }
                });
              },
              onClear: () {
                setState(() {
                  brightenDurationInSeconds = 0;
                });
              },
            ),
            SizedBox(height: 10),
            // Display Selected Brighten Duration
            Text(
              'Brighten Duration: ${formatTime(brightenDurationInSeconds)}',
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            // Start Button
            ElevatedButton(
              onPressed: startWakeUpSequence,
              child: Text('Set Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}
