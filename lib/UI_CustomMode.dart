import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:app_usage/app_usage.dart';
import 'package:appusageexample/SettingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomMode extends StatefulWidget {
  @override
  _CustomModeState createState() => _CustomModeState();
}

class _CustomModeState extends State<CustomMode> {
  AppUsage appUsage = new AppUsage();
  double apps;
  bool isPressed = false;
  bool isSwitched = false;
  bool isStopped = false;
  String value1 = "";
  String value2 = "";
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
        if (v > (num.parse(value2) - 300)) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Custome Mode"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              onPressed:() => Navigator.of(context).push(
                new SettingPageRoute(),
              )
          )
        ],
      ),
      body: new Container(
        padding: const EdgeInsets.all(40.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new TextFormField(
                controller: myController0,
                decoration:
                    new InputDecoration(labelText: "Enter your total number"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                onChanged: (val1) =>
                    value1 = val1, // Only numbers can be entered
              ),

              new TextFormField(
                controller: myController,
                decoration:
                    new InputDecoration(labelText: "Enter your apps number"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                onChanged: (val2) =>
                    value2 = val2, // Only numbers can be entered
                ),
              SizedBox(height: 20),
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
                  SizedBox(width: 165),
                  Switch(
                    activeTrackColor: Colors.black45,
                    activeColor: Colors.black,
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 220),
              Text(
                isPressed ? 'Total time on mobile: XXX minutes' : '',                                     //FIX LAI XXX
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
                  SizedBox(width: 150),
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
                      print(value1);
                      print(value2);
                      Timer.periodic(new Duration(seconds: 90), (timer) {
                        getUsageStats();
                        print('You have spend $apps second');
                        if (apps > (num.parse(value1) - 300)) {
                          DateTime now = DateTime.now().add(
                            Duration(seconds: 60),
                          );
                          singleNotification(
                            now,
                            "Notification",
                            "You have been using your phone for too long!! Get up and do some thing",
                            98123871,
                          );
                        } else if (apps > (num.parse(value1) + 300)) {
                          isStopped = true;                                                                 //FIX LAI BIEN O CHO NAY THANH ISPRESSED
                        }
                        if (isStopped) {                                                                    //CHO NAY NUA
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
            ]
        ),
      ),
    );
  }
}

class SettingPageRoute extends CupertinoPageRoute {
  SettingPageRoute()
      : super(builder: (BuildContext context) => new SettingPage());
  /*@override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new SettingPage());
  }*/
}