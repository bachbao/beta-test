import 'package:flutter/material.dart';

import 'UI_CustomMode.dart';
import 'UI_StandardMode.dart';
import 'package:flutter/cupertino.dart';

import 'UI_StandardMode.dart';
import 'UI_StandardMode.dart';

class LoginState extends StatefulWidget {
  @override
  _LoginStateState createState() => _LoginStateState();
}

class _LoginStateState extends State<LoginState> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    final standard = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            new StandardPageRoute(),
          );
        },
        child: Text("Standard",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
    final customize = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            new CustomModeRoute(),
          );
        },
        child: Text("Custom",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              children: <Widget>[
                SizedBox(height:50),
                Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold
                  )
                ),
                Text(
                  'FreeTime',
                  style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: 20),
                Image(
                  image: AssetImage('assets/icon.png')
                ),
                SizedBox(height:80),
                Text(
                  "Choose your plan",
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Lato',
                  ),
                ),
                SizedBox(height: 25.0),
                standard,
                SizedBox(
                  height: 25.0,
                ),
                customize,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StandardPageRoute extends CupertinoPageRoute {
  StandardPageRoute()
      : super(builder: (BuildContext context) => new StandardPage());
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new StandardPage());
  }
}

class CustomModeRoute extends CupertinoPageRoute {
  CustomModeRoute()
      : super(builder: (BuildContext context) => new CustomMode());
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new CustomMode());
  }
}