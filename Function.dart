import 'package:flutter/material.dart';

class AppList extends StatefulWidget{
  @override
  _AppListState createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        else return Container(
          color: Colors.white,

          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                children: <Widget>[
                  Icon(Icons.apps),
                  Text("app_name")
                ],
              )),
              RaisedButton(
                child: Text("Disable"),
                  onPressed: null)
            ],
          ),
          
        );
        
      },
    );
  }
}



