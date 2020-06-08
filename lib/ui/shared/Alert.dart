import 'package:flutter/material.dart';

class AlertForm extends StatefulWidget {
  @override
  AlertFormState createState() => AlertFormState();
}

class AlertFormState extends State<AlertForm> {

    void showDialogBox(BuildContext context,  String title, String mgs) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(mgs),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}