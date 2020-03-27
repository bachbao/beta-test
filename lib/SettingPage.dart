import 'dart:collection';

import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AppUsage appUsage = new AppUsage();
  String apps = 'Unknown';

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
      LinkedHashMap<String, double> usage =
          await appUsage.fetchUsage(startDate, endDate);
      usage.removeWhere((key, val) => val == 0);
      setState(() => apps = makeString(usage));
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  String makeString(Map<String, double> usage) {
    String result = '';
    usage.forEach((k, v) {
<<<<<<< Updated upstream
      String appName = k.split('.').last;
      String timeInMins = (v / 60).toStringAsFixed(2);
      result += '$appName : $timeInMins minutes\n';
=======
      if (v > 3600) {
        String appName = k.split('.').last;
        String timeInMins = (v / 60).toStringAsFixed(2);
        result += '$appName : $timeInMins mins\n';
      } else {
        String appName = k.split('.').last;
        String timeInMins = (v / 60).toStringAsFixed(2);
        result += '$appName : $timeInMins mins\n';
      }
>>>>>>> Stashed changes
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Usage Example'),
        ),
        body: Text(
          apps,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20.0, // insert your font size here
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: getUsageStats, child: Icon(Icons.cached)),
      ),
<<<<<<< Updated upstream
      body: Center(
          child: Text(
        "KILL ME PLS",
        style: TextStyle(fontSize: 50),
      )),
=======
>>>>>>> Stashed changes
    );
  }
}
