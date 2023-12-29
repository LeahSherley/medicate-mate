import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditation_app/MyWidgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PillDesign extends StatefulWidget {
  const PillDesign({super.key, required this.pillName, required this.dosage});
  final String pillName;
  final String dosage;

  @override
  State<PillDesign> createState() => _PillDesignState();
}

class _PillDesignState extends State<PillDesign> {
  /*Future<void> _removeMedication(String pillName) async {
    final url = Uri.https("medicationapp-c4830-default-rtdb.firebaseio.com",
        "userMedications/$pillName.json");
    await http.delete(url);
  }*/
  Future<void> _removeMedication(String pillName) async {
    try {
      String userUid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final url = Uri.https(
        "medicationapp-c4830-default-rtdb.firebaseio.com",
        "userMedications/$userUid/medication-list/$pillName.json",
      );

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print("Medication removed successfully");
      } else {
        print(
            "Failed to remove medication. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error removing medication: $error");
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    final settingsAndroid = const AndroidInitializationSettings('medication_removebg_preview');
    final settingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final initializationSettings =
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleDailyNotification(int numberOfTimes) async {
    tz.initializeTimeZones();

    for (int i = 0; i < numberOfTimes; i++) {
      final notificationId = i + 1;

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'daily_reminder',
        'Daily Reminder',
        'Daily reminder for medication',
        importance: Importance.high,
        priority: Priority.high,
        channelShowBadge: true,
      );
      const IOSNotificationDetails iOSPlatformChannelSpecifics =
          IOSNotificationDetails();
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      final now = DateTime.now();
      final scheduledDate = tz.TZDateTime.local(
        now.year,
        now.month,
        now.day,
        0,
        5,
        0,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Medication Reminder',
        'Take your medication!',
        scheduledDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  
  Future<void> _showRepeatOptionsDialog() async {
    int? repeatTimes = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int? selectedValue;

        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: mytext("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (selectedValue != null) {
                  Navigator.pop(context, selectedValue);
                }
              },
              child: mytext("OK"),
            ),
          ],
          backgroundColor: Colors.deepPurple[50],
          title: const Text(
            'Select Reminder',
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<int>(
                  title: Text(
                    'Once',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  value: 1,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: Text(
                    'Twice',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  value: 2,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: Text(
                    'Thrice',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  value: 3,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ],
            );
          }),
        );
      },
    );

    if (repeatTimes != null) {
      _scheduleDailyNotification(repeatTimes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.deepPurple[100],
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
          //top: 5,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade100,
                Colors.deepPurple.shade50,
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                bottom: 16,
              ),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/medication-removebg-preview.png",
                        //fit: BoxFit.cover,
                        height: 130,
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                _showRepeatOptionsDialog();
                              },
                              icon: const Icon(
                                Icons.alarm_add_rounded,
                                size: 30,
                              )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _removeMedication(widget.pillName);
                                });
                              },
                              icon: const Icon(
                                Icons.delete_rounded,
                                size: 30,
                              )),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [mytext("Pill Name: "), mytext(widget.pillName)],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [mytext("Dosage: "), mytext(widget.dosage)],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
