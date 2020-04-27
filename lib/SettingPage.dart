import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AppUsage appUsage = new AppUsage();
  String apps = " ";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  void getUsageStats() async {
    try {
      DateTime endDate = new DateTime.now();
      DateTime startDate =
          DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
      Map<String, double> usage = await appUsage.fetchUsage(startDate, endDate);
      usage.removeWhere((key, val) => val == 0);
      setState(() => apps = makeString(usage));
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  String makeString(Map<String, double> usage) {
    String result = '';
    usage.forEach((k, v) {
      String appName = k.split('.').last;
      String timeInMins = (v / 60).toStringAsFixed(2);
      result += '$appName : $timeInMins mins\n';
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'App Usage',
              style: TextStyle(
                  fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold
              ),
          ),
          actions: <Widget>[],
        ),

        body:Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Text(
                  apps,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0, // insert your font size here
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: getUsageStats,
            backgroundColor: Colors.black,
            child: Icon(Icons.cached),
        )
      );

  }
}
