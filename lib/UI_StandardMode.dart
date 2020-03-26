import 'dart:async';

import 'package:app_usage/app_usage.dart';
import 'package:appusageexample/SettingPage.dart';
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
  bool isPressed = false;
  AppUsage appUsage = new AppUsage();
  double apps;
  String mins;
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
      mins = (apps / 60).toStringAsFixed(2);
      usage.forEach((k, v) {
        if (v > 3300) {
          DateTime now = DateTime.now().add(
            Duration(seconds: 5),
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
              fontFamily: 'Lato', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              onPressed: () => Navigator.of(context).push(
                    new SettingPageRoute(),
                  ))
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Notification',
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 180),
              Switch(
                activeTrackColor: Colors.black45,
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
          SizedBox(height: 390),
          Text(
            isPressed ? 'Total time on mobile: $mins minutes' : '',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold
            ),
          ),
          Text(
            isPressed ? '(renew every 24 hours)' : '',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(width: 120),
              FlatButton(
                highlightColor: Colors.black12,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: isPressed ? Colors.black26 : Colors.black,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                child: Text(
                  isPressed ? 'ENABLED' : 'ENABLE',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  Timer.periodic(new Duration(seconds: 10), (timer) {
                    getUsageStats();
                    print('You have spend $mins minutes');
                    if (apps > 3300) {
                      DateTime now = DateTime.now().add(
                        Duration(seconds: 5),
                      );
                      singleNotification(
                        now,
                        "Notification",
                        "You have been using your phone for too long!! Get up and do some thing",
                        98123871,
                      );
                    } else if (apps > 3900) {
                      timer.cancel();
                    }
                    if (isSwitched == false) {
                      timer.cancel();
                    }
                  });

                  setState(() {
                    isPressed = true;
                  });
                },
              ),
            ],
          ),
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
    );
  }
}

class SettingPageRoute extends CupertinoPageRoute {
  SettingPageRoute()
      : super(builder: (BuildContext context) => new SettingPage());
}
