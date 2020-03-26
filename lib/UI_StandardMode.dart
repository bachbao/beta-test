import 'dart:async';

import 'package:app_usage/app_usage.dart';
import 'package:appusageexample/Function.dart';
import 'package:appusageexample/SettingPage.dart';
import 'package:appusageexample/UI_CustomMode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'SettingPage.dart';


class StandardPage extends StatefulWidget {
  @override
  _StandardPageState createState() => _StandardPageState();
}

class _StandardPageState extends State<StandardPage> {
  bool isSwitched = false;
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
        title: Text(
            'Standard Mode',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              onPressed:() => Navigator.of(context).push(
                new SettingPageRoute(),
              )
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Notification',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(width: 200),
              Switch(
                activeTrackColor: Colors.black54,
                activeColor: Colors.black,
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });

                },

              )
            ],
          ),
          SizedBox(height: 450),

          Text(
            'Total time on mobile: XXX',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            '(renew every 24 hours)',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.normal
            ),
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

class SettingPageRoute extends CupertinoPageRoute {
  SettingPageRoute()
      : super(builder: (BuildContext context) => new SettingPage());
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new SettingPage());
  }
}