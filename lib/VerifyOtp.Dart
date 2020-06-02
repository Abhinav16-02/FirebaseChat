//import 'package:firbase_chat/ChatList.dart';
import 'package:firbase_chat/appconstants.dart';
import 'package:flutter/material.dart';
import 'package:firbase_chat/Utilities/Utility.dart';
import 'package:firbase_chat/Extensions/Extensions.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'CommonClasses/GradientButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyOtp extends StatefulWidget {
  final String verificationID;
  VerifyOtp({Key key, this.verificationID}) : super(key: key);
  @override
  _VerifyOtpState createState() => _VerifyOtpState(id: verificationID);
}

class _VerifyOtpState extends State<VerifyOtp> {
  _VerifyOtpState({this.id});

  Utility utility;
  String mobileNumber = "test";
  String id;
  String smsCode;

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
    return Container(
        // padding: EdgeInsets.only(bottom: 60),
        //color: Colors.red,

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
                            maxHeight:
                                utility.screenWidth(context, multipliedBy: 0.6),
                            maxWidth:
                                utility.screenWidth(context, multipliedBy: 0.6),
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
                                  text: "$mobileNumber",
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
                                    style: TextStyle().getStyleButton(context),
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
                    ]))));
  }

  void _signInWithPhoneNumber() {
    
    AuthCredential credential =
        PhoneAuthProvider.getCredential(verificationId: id, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(credential).catchError((error) {
      setState(() {
        // status = 'Something has gone wrong, please try later';
        print("error");
      });
    }).then((user) async {
      setState(() {
        if (user.user != null) {}
        // status = 'Authentication successful';
        Navigator.pushNamed(context, AppConstants.profile);
        //    Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => ChatList()));
        // });
        //onAuthenticationSuccessful();
      });
    });
  }
}
