import 'package:firbase_chat/ChatList.dart';
import 'package:firbase_chat/CommonClasses/GradientButton.dart';
import 'package:firbase_chat/Utilities/Utility.dart';
import 'package:firbase_chat/appconstants.dart';
import 'package:firbase_chat/profile.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:firbase_chat/ui/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firbase_chat/VerifyOtp.Dart';
import 'package:firbase_chat/Extensions/Extensions.dart';

void main() {
  setupLocator();
  runApp(MaterialApp(
    theme: ThemeData(
      snackBarTheme:
          SnackBarThemeData(backgroundColor: Color.fromRGBO(72, 194, 140, 1)),
      primaryColor: Color.fromRGBO(72, 194, 140, 1),
      accentColor: Color.fromRGBO(72, 194, 140, 1),
      textTheme: TextTheme(
        bodyText1: TextStyle(fontSize: 30.0, color: Colors.black),
        button: TextStyle(fontSize: 18.0, color: Colors.white),
        bodyText2: TextStyle(fontSize: 16.0, color: Colors.grey),
      ),
    ),
    home: Scaffold(backgroundColor: Colors.white, body: ChatApp()),
    //initialRoute: AppConstants.enterNumber,
    onGenerateRoute: Router.generateRoute,
  ));
}

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  Utility utility;
  final myController = TextEditingController();
  String verificationID;
  var firAuth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    utility = Utility();
  }

  //Custom Functions
  Future<void> verifyMobileNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verificationID) {
      this.verificationID = verificationID;
    };

    final PhoneVerificationCompleted verified = (AuthCredential credential) {
      print("Verified");
      print("$credential");
      Navigator.pushNamed(context, AppConstants.chatList);
    };

    final PhoneCodeSent codeSent = (verificationID, [int forceResendToken]) {
      this.verificationID = verificationID;
      // Navigator.pushNamed(context, AppConstants.verifyCode,arguments:this.verificationID);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  VerifyOtp(verificationID: this.verificationID)));
    };

    final PhoneVerificationFailed verificationFailed = (AuthException error) {
      print("${error.message}");
    };

    firAuth.verifyPhoneNumber(
        phoneNumber: myController.text,
        timeout: Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrive);
  }

  TextStyle setTextStyle(double fontSize, Color textColor) {
    return TextStyle(
        fontSize: fontSize, color: textColor, fontStyle: FontStyle.normal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
          child: Column(
        //mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: utility.screenWidth(context, multipliedBy: 0.5),
                    maxWidth: utility.screenWidth(context, multipliedBy: 0.5),
                  ),
                  child: Image(
                    image: AssetImage("icons/phone_no@3x.png"),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text("OTP Verification",
                    style: TextStyle().getStyleBody1(context)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: TextStyle().getStyleBody2(context),
                children: <TextSpan>[
                  TextSpan(text: "We will send you an"),
                  TextSpan(
                      text: " One Time Password",
                      style: TextStyle(color: Colors.black)),
                  TextSpan(text: " \n On this mobile number."),
                ]),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  "Enter Mobile Number",
                  style: TextStyle().getStyleBody2(context),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 70, maxWidth: utility.screenWidth(context) * 0.6),
            child: TextField(
              controller: myController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 22.0),
              decoration: InputDecoration(hintText: "+918008080800"),
              maxLength: 15,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
              width: utility.screenWidth(context, multipliedBy: 0.75),
              child: RaisedGradientButton(
                child: Text(
                  "GET OTP",
                  style: TextStyle().getStyleButton(context),
                ),
                gradient: LinearGradient(colors: <Color>[
                  Color.fromRGBO(69, 191, 140, 1),
                  Color.fromRGBO(19, 146, 130, 1)
                ]),
                onPressed: () {
                  verifyMobileNumber();
                },
              ))
        ],
      )),
    );
  }
}
