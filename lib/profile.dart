import 'package:firbase_chat/CommonClasses/GradientButton.dart';
import 'package:flutter/material.dart';
import 'Utilities/Utility.dart';
import 'package:firbase_chat/Extensions/Extensions.dart';

import 'appconstants.dart';

class Proflie extends StatefulWidget {
  @override
  _ProflieState createState() => _ProflieState();
}

class _ProflieState extends State<Proflie> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = Utility().screenHeight(context);
    double screenWidth = Utility().screenWidth(context);
    var sizedBox = SizedBox(
      height: 80,
    );
    return SafeArea(
        child: Scaffold(
            body: Container(
                height: double.infinity,
                child: Stack(alignment: Alignment.topCenter, children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.24,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular((screenHeight * 0.24) * 0.4),
                              bottomRight:
                                  Radius.circular((screenHeight * 0.24) * 0.4)),
                          gradient: LinearGradient(colors: <Color>[
                            Color.fromRGBO(69, 191, 140, 1),
                            Color.fromRGBO(19, 146, 130, 1)
                          ]))),
                  Positioned(
                    top: (screenHeight * 0.24) / 2 - 20,
                    height: 40,
                    width: 40,
                    left: 10,
                    child: IconButton(
                      icon: Image.asset("icons/back_white.png"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    top: (screenHeight * 0.24 -
                        ((screenHeight * 0.24) /
                            2.4)), //2.4=divisor in image width * 2
                    left: (screenWidth / 2) - (((screenHeight * 0.24) / 2.4)),
                    child: Container(
                        child: Image.asset(
                          'icons/user_profilr_pic@3x.png',
                          width: (screenHeight * 0.24) / 1.2,
                          height: (screenHeight * 0.24) / 1.2,
                          fit: BoxFit.cover,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // boxShadow: [
                            //   BoxShadow(
                            //     blurRadius: 5,
                            //       color: Colors.black.withOpacity(0.06), 
                            //       offset: Offset(0, 5))
                            // ]
                            )),
                  ),
                  Positioned(
                    //width: (screenWidth / 2),
                    top: (screenHeight * 0.24 + ((screenHeight * 0.24) / 3)),
                    child: Column(
                      children: <Widget>[
                        sizedBox,
                        Text("User Name"),
                        Container(
                          width: (screenWidth / 2),
                          child: TextField(
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        RaisedGradientButton(
                          width: (screenWidth * 0.75),
                          child: Text(
                            "SAVE",
                            style: TextStyle().getStyleButton(context),
                          ),
                          gradient: LinearGradient(colors: <Color>[
                            Color.fromRGBO(69, 191, 140, 1),
                            Color.fromRGBO(19, 146, 130, 1)
                          ]),
                          onPressed: () {
                            Navigator.pushNamed(context, AppConstants.chatList);
                          },
                        )
                      ],
                    ),
                  ),
                  // Positioned(
                  //     child: Container(
                  //   width: Utility().screenWidth(context, multipliedBy: 0.5),
                  //   child: Column(
                  //     children: <Widget>[
                  //       Text("User Name"),
                  //       TextField(
                  //         decoration: InputDecoration(),
                  //       )
                  //     ],
                  //   ),
                  // ))
                ]))));
  }
}
