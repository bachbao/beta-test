import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'UI_CustomMode.dart';
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
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StandardMode()),
          );
        },
        child: Text("Standard",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final customize = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomMode()),
          );
        },
        child: Text("Customize",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
<<<<<<< Updated upstream
                SizedBox(
                    height: 155.0,
                    child: Text(
                      "Welcome to FREEtiME",
                      style: TextStyle(
                          color: Color.fromARGB(200, 80, 80, 120),
                          fontSize: 50),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(height: 100.0),
                Text(
                  "Choose your plan",
                  style: TextStyle(fontSize: 40),
=======
                SizedBox(height: 50),
                Text('Welcome to',
                    style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold)),
                Text('FreeTime',
                    style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Image(image: AssetImage('assets/icon.png')),
                SizedBox(height: 80),
                Text(
                  "Choose your plan",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Lato',
                  ),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======

class StandardPageRoute extends CupertinoPageRoute {
  StandardPageRoute()
      : super(builder: (BuildContext context) => new StandardPage());

  //OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new StandardPage());
  }
}

class CustomModeRoute extends CupertinoPageRoute {
  CustomModeRoute()
      : super(builder: (BuildContext context) => new CustomMode());

  //OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new CustomMode());
  }
}
>>>>>>> Stashed changes
