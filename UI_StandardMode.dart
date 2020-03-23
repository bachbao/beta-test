import 'dart:async';

import 'package:app_usage/app_usage.dart';
import 'package:appusageexample/Function.dart';
import 'package:appusageexample/SettingPage.dart';
import 'package:appusageexample/UI_CustomMode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class StandardMode extends StatefulWidget {
  @override
  _StandardModeState createState() => _StandardModeState();
}

class _StandardModeState extends State<StandardMode> {
  AppUsage appUsage = new AppUsage();
  double apps;
  bool isStopped = false;
  final myController = TextEditingController();
  final myController0 = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    myController0.dispose();
    super.dispose();
  }

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
        title: Text('Standard Mode'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed:() => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              ))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: AppList()),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 70,
                child: Text("You have been using your phone in XXX hours",
                style: TextStyle(
                  fontSize: 15
                ),),
              )
            ],
          )
        ],
      ),
      /*
      Center(
        child: RaisedButton(
            child: Text('Switch mode'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomMode()),
            )),
      )*/


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notifications),
        onPressed: () async {
          Timer.periodic(new Duration(seconds: 90), (timer) {
            getUsageStats();
            print('You have spend $apps second');
            if (apps > 3300) {
              DateTime now = DateTime.now().add(
                Duration(seconds: 60),
              );
              singleNotification(
                now,
                "Notification",
                "You have been using your phone for too long!! Get up and do some thing",
                98123871,
              );
            } else if (apps > 3900) {
              isStopped = true;
            }
            if (isStopped) {
              timer.cancel();
            }
          });
        },
      ),
    );
  }
}