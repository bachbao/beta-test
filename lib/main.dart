import 'dart:async';

import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppUsage appUsage = new AppUsage();
  double apps;
  bool isStopped = false;

  void getUsageStats() async {
    try {
      DateTime endDate = new DateTime.now();
      DateTime startDate =
          DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
      Map<String, double> usage = await appUsage.fetchUsage(startDate, endDate);
      usage.removeWhere((key, val) => val == 0);
      setState(() => apps = calculate(usage));
      usage.forEach((k, v) {
        if (v > 3300) {
          DateTime now = DateTime.now().add(
            Duration(seconds: 60),
          );
          singleNotification(
            now,
            "Notification",
            "You have been using the app key:$k for too $v please ",
            98123872,
          );
        }
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  double calculate(Map<String, double> usage) {
    double sum = 0;
    usage.forEach((k, v) {
      sum = sum + v;
    });
    return sum;
  }

  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializeNotifications() async {
    var initializeAndroid = AndroidInitializationSettings('ic_launcher');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(initializeAndroid, initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  singleNotification(
      DateTime datetime, String message, String subtext, int hashcode,
      {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.Max,
      priority: Priority.Max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    localNotificationsPlugin.schedule(
        hashcode, message, subtext, datetime, platformChannel,
        payload: hashcode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification/Alarm Example'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notifications),
        onPressed: () async {
          Timer.periodic(new Duration(seconds: 90), (timer) {
            getUsageStats();
            print('You have spend $apps second');
            if (apps > 6900) {
              DateTime now = DateTime.now().add(
                Duration(seconds: 60),
              );
              singleNotification(
                now,
                "Notification",
                "You have been using your phone for too long!! Get up and do some thing",
                98123871,
              );
            } else if (apps > 7500) {
              isStopped = true;
            }
          });
        },
      ),
    );
  }
}
