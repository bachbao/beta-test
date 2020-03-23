import 'package:flutter/material.dart';
import 'package:appusageexample/SettingPage.dart';

class CustomMode extends StatefulWidget{
  @override
  _CustomModeState createState() => _CustomModeState();
}

class _CustomModeState extends State<CustomMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Custome Mode"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed:() => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              ))
        ],
      ),
      body: Center(
        child: Text("I am regretting my life choice"),
      ),
    );
  }
}