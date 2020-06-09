//import 'package:firbase_chat/ChatList.dart';
import 'package:firbase_chat/appconstants.dart';
import 'package:firbase_chat/core/services/firebaseapi.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:firbase_chat/ui/shared/Alert.dart';
import 'package:firbase_chat/ui/shared/sharedPreferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firbase_chat/Utilities/Utility.dart';
import 'package:firbase_chat/Extensions/Extensions.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'CommonClasses/GradientButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtp extends StatefulWidget {
  final String verificationID;
  final String mobileNumber;
  VerifyOtp({Key key, this.verificationID, this.mobileNumber})
      : super(key: key);
  @override
  _VerifyOtpState createState() => _VerifyOtpState(id: verificationID);
}

class _VerifyOtpState extends State<VerifyOtp> {
  _VerifyOtpState({this.id});
  var firAuth = FirebaseAuth.instance;
  String verificationID;
  Utility utility;
  String id;
  String smsCode;
  bool isLoading = false;
  FirebaseApi _firApi = locator<FirebaseApi>();

  @override
  void initState() {
    super.initState();
    utility = Utility();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: verifyOtpSetup(),
    );
  }

  Widget verifyOtpSetup() {
    return Stack(children: <Widget>[
      Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          // color: Colors.black,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: utility.screenWidth(context,
                                  multipliedBy: 0.6),
                              maxWidth: utility.screenWidth(context,
                                  multipliedBy: 0.6),
                            ),
                            child: Image(
                              image: AssetImage("icons/otp_enter.png"),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        Container(
                            //color: Colors.black,
                            child: Column(children: <Widget>[
                          Text("OTP Verification",
                              style: TextStyle().getStyleBody1(context)),
                          SizedBox(
                            height: 20,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: TextStyle().getStyleBody2(context),
                                  children: <TextSpan>[
                                TextSpan(text: "Enter the OTP sent to "),
                                TextSpan(
                                    text: "${widget.mobileNumber}",
                                    style: TextStyle(color: Colors.black)),
                              ])),
                          PinEntryTextField(
                            fields: 6,
                            fontSize: 24.0,
                            onSubmit: (String pin) {
                              smsCode = pin;
                            },
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ])),

                        Container(
                          child: Column(
                            children: <Widget>[
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle().getStyleBody2(context),
                                      children: <TextSpan>[
                                    TextSpan(text: "Don't receive the OTP?"),

                                    TextSpan(
                                      recognizer:TapGestureRecognizer()
                                      ..onTap = () {
                                        resendCode();
                                        },
                                        text: " Resend OTP",
                                        style: TextStyle(color: Colors.black)),
                                  ])),
                              SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                  width: utility.screenWidth(context,
                                      multipliedBy: 0.75),
                                  height: 50,
                                  child: RaisedGradientButton(
                                    child: Text(
                                      "VERIFY & PROCEED",
                                      style:
                                          TextStyle().getStyleButton(context),
                                    ),
                                    gradient: LinearGradient(colors: <Color>[
                                      Color.fromRGBO(69, 191, 140, 1),
                                      Color.fromRGBO(19, 146, 130, 1)
                                    ]),
                                    onPressed: () {
                                      _signInWithPhoneNumber();
                                    },
                                  ))
                            ],
                          ),
                        ),
                      ])))),
      isLoading
          ? Container(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()))
          : Container()
    ]);
  }

  Future<bool> saveInfo(String uuid) async {
    return await SharedData().saveCurrentUUID(uuid);
  }

  void _signInWithPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    AuthCredential credential =
        PhoneAuthProvider.getCredential(verificationId: id, smsCode: smsCode);

    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((user) async {
        if (user.user != null) {
          await saveInfo(user.user.uid);
          bool userExist = await _firApi.checkUserExist();
          setState(() {
            isLoading = false;
          });
          if (userExist) {
            Navigator.pushNamed(context, AppConstants.chatList);
          } else {
            //Navigator.pushNamed(context, AppConstants.profile);
            Navigator.pushNamed(context, AppConstants.profile,
                arguments: {"back": false, "name": "", "image": ""});
          }
        }
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      AlertFormState().showDialogBox(context, "Error", error.message);
    }
  }

   resendCode() {
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verificationID) {
      this.verificationID = verificationID;
    };

    final PhoneVerificationCompleted verified = (AuthCredential credential) {
      FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        saveInfo(user.user.uid);
        Navigator.of(context).pushReplacementNamed(AppConstants.profile);
      }).catchError((e) => print(e));
    };
    final PhoneCodeSent codeSent = (verificationID, [int forceResendToken]) {
      this.verificationID = verificationID;
      AlertFormState().showDialogBox(context, "Message", "Code sent Successfully");
    };

    final PhoneVerificationFailed verificationFailed = (AuthException error) {
      print("${error.message}");
      AlertFormState().showDialogBox(context, "Error", error.message);
    };

    firAuth.verifyPhoneNumber(
        phoneNumber: widget.mobileNumber,
        timeout: Duration(seconds: 120),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrive);
  }
}
