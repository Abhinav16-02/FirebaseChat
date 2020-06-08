import 'package:firbase_chat/ChatList.dart';
import 'package:firbase_chat/CommonClasses/GradientButton.dart';
import 'package:firbase_chat/core/viewmodels/profileViewModel.dart';
import 'package:firbase_chat/core/models/userInfo.dart' as UserData;
import 'package:firbase_chat/service_locator.dart';
import 'package:flutter/material.dart';
import 'Utilities/Utility.dart';
import 'package:firbase_chat/Extensions/Extensions.dart';
import 'CommonClasses/imagePickerHandler.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'ui/shared/Alert.dart';
import 'ui/shared/sharedPreferences.dart';

import 'appconstants.dart';

class Proflie extends StatefulWidget {
  final bool back;
  final String name;
  final String image;
  GetProfilePic userPic;

  Proflie(this.back,{this.name,this.image,this.userPic});
  @override
  _ProflieState createState() => _ProflieState();
}

class _ProflieState extends State<Proflie>
    with TickerProviderStateMixin, ImagePickerListener {
  final viewModel = locator<ProfileViewModel>();
  ImagePickerHandler imagePicker;
  AnimationController _controller;
  TextEditingController controller = TextEditingController();
  File selectedImage;
  String name;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init();
    _getname();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _getname() async {
    var name = await SharedData().getCurrentName();
    var image = await SharedData().getCurrentUserImage();
    setState(() {
      if (name != null) {
        this.name = name;
        controller.text = name;
      }else{
        this.name = widget.name;
        controller.text = name;
      }
      if (image != null) {
        this.selectedImage = File(image);
      }
    });
  }

  Future<String> _saveUserData() async {
    if (this.name != null) {
      SharedData().saveCurrentUserName(this.name);
    }
    if (this.selectedImage != null) {
      SharedData().saveCurrentUserImage(selectedImage.path);
      return viewModel.uploadFile(selectedImage.path);
    } else {
      return "";
    }
  }

  Future<bool> createNewuser(String imgUrl) async {
    Map currentUserDetails =
        UserData.UserInfo(userName: name, profilePic: imgUrl).tojson();
    String userId = await viewModel.createNewUser(currentUserDetails);
    return await SharedData().saveCurrentUserID(userId);
  }

  _signOut() async {
    await FirebaseAuth.instance.signOut().then((_) {
      SharedData().clearData();
      Navigator.of(context).pushNamed(AppConstants.enterNumber);
      // Navigator.of(context).pushNamedAndRemoveUntil(AppConstants.enterNumber, ModalRoute.withName(AppConstants.profile));
    });
  }

  Widget _setBackButton() {
    if (widget.back) {
      return Container(
        child: IconButton(
          icon: Image.asset("icons/back_white.png"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _logout() {
    if (widget.back) {
      return Container(
        child: FlatButton(
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () {
            _signOut();
            Navigator.pop(context);
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _profile(double height) {
    try {
      if (this.selectedImage != null) {
        return Container(
            width: (height * 0.18) / 1.2,
            height: (height * 0.18) / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: FileImage(selectedImage),
                fit: BoxFit.cover,
              ),
            ));
      } else {
        return Container(
            child: widget.image != "" ? Image.network(widget.image) : Image.asset(
              'icons/user_profilr_pic@3x.png',
              width: (height * 0.18) / 1.2,
              height: (height * 0.18) / 1.2,
              fit: BoxFit.cover,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = Utility().screenHeight(context);
    double screenWidth = Utility().screenWidth(context);
    var sizedBox = SizedBox(
      height: 80,
    );
    return Scaffold(
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
                    child: _setBackButton(),
                  ),
                  Positioned(
                    top: (screenHeight * 0.24) / 2 - 20,
                    height: 40,
                    width: 100,
                    right: 10,
                    child: _logout(),
                  ),
                  Positioned(
                    top: (screenHeight * 0.30 -
                        ((screenHeight * 0.32) /
                            2.4)), //2.4=divisor in image width * 2
                    left: (screenWidth / 2) - (((screenHeight * 0.18) / 2.4)),
                    child: GestureDetector(
                      child: _profile(screenHeight),
                      onTap: () {
                        imagePicker.showDialog(context);
                      },
                    ),
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
                            controller: controller,
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.center,
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
                          onPressed: () async {
                            this.name = controller.text;
                            if (this.name != null && this.name != "") {
                              String url = await _saveUserData();
                              if (widget.userPic != null){
                              widget.userPic.getCurrentProfile(url);
                              }
                              await createNewuser(url).then((value) {
                                if ((widget.back == false) && (value == true)) {
                                  Navigator.pushNamed(context, AppConstants.chatList);
                                } else {
                                  Navigator.of(context).pop();
                                }
                              });
                            } else {
                              AlertFormState().showDialogBox(context, "Error",
                                  "Name is required. Please enter your name.");
                            }
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
                ])));
  }

  @override
  userImage(File _image) {
    setState(() {
      this.selectedImage = _image;
    });
  }
}
abstract class GetProfilePic {
  getCurrentProfile(String pic);
}