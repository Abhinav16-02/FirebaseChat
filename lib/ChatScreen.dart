import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_chat/CommonClasses/CircularImage.dart';
import 'package:firbase_chat/Utilities/Utility.dart';
import 'package:firbase_chat/appconstants.dart';
import 'package:firbase_chat/core/models/messageInfo.dart';
import 'package:firbase_chat/core/models/userInfo.dart';
import 'package:firbase_chat/core/viewmodels/chatModel.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'CommonClasses/imagePickerHandler.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final UserInfo userInfo;
  ChatScreen(this.chatId, this.currentUserId, this.userInfo);
  //const ChatScreen({ Key key }) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  String chatId;
  String currentUserId;
  List<MessageInfo> allMessages;
  final modal = locator<ChatModel>();
  TextEditingController _txtfieldMsgController;
  ScrollController _msgListController;
  ImagePickerHandler imagePicker;
  AnimationController _controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _msgListController = ScrollController();
    _txtfieldMsgController = TextEditingController();
    chatId = widget.chatId;
    currentUserId = widget.currentUserId;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  _sendMessage({String imageUrl}) {
    setState(() {
      if (_txtfieldMsgController.text.isNotEmpty) {
        String msg = _txtfieldMsgController.text;
        _txtfieldMsgController.text = "";
        Map info = MessageInfo(msg, "M", "", widget.currentUserId).toMap();
        modal.sendMessageToFirebase(chatId, info).then((value) {
          _msgListController.animateTo(0.0,
              duration: Duration(microseconds: 2), curve: Curves.easeOut);
        });
      } else if (imageUrl != "" && imageUrl != null) {
        Map info = MessageInfo("", "I", imageUrl, widget.currentUserId).toMap();
        modal.sendMessageToFirebase(chatId, info).then((value) {
          _msgListController.animateTo(0.0,
              duration: Duration(microseconds: 2), curve: Curves.easeOut);
        });
      } else {
        print("Errorrrrrrrrr");
        // SnackBar error = SnackBar(
        //   content: Text("Please enter some message"),
        // );
        //Scaffold.of(context).showSnackBar(error);
      }
    });
  }

  _sendImage(String imagePath) async {
    setState(() {
      isLoading = true;
    });
    String url = await modal.uploadFile(imagePath);
    setState(() {
      isLoading = false;
    });
    _sendMessage(imageUrl: url);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => modal,
        child: Scaffold(
            body: Stack(children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Column(children: <Widget>[
                Container(
                  height: Utility().screenHeight(context) * 0.24,
                  child: GradientAppBar(widget.chatId, widget.userInfo),
                ),
                Expanded(
                  child: Consumer<ChatModel>(
                      builder: (context, model, widget) => StreamBuilder(
                            stream: model.fetchAllMessages(chatId),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                allMessages = snapshot.data.documents
                                    .map((details) =>
                                        MessageInfo.fromMap(details.data))
                                    .toList();
                                return ListView.builder(
                                    reverse: true,
                                    controller: _msgListController,
                                    itemCount: allMessages.length,
                                    itemBuilder: (context, index) {
                                      MessageInfo msg = allMessages[index];
                                      String msgBy = msg.sentBy == currentUserId
                                          ? "self"
                                          : "";

                                      return msg.messageType == AppConstants.msg
                                          ?
                                          //Message
                                          Column(
                                              crossAxisAlignment: msgBy ==
                                                      "self"
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(height: 5),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth: Utility()
                                                            .screenWidth(
                                                                context,
                                                                multipliedBy:
                                                                    0.75)),
                                                    child: Container(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment: msgBy ==
                                                                "self"
                                                            ? MainAxisAlignment
                                                                .end
                                                            : MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child: Text(
                                                              msg.message,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "${msg.sentTime}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                          ),
                                                        ],
                                                      ),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15.0,
                                                              10.0,
                                                              15.0,
                                                              10.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft: msgBy ==
                                                                      "self"
                                                                  ? Radius.circular(
                                                                      10)
                                                                  : Radius
                                                                      .circular(
                                                                          0),
                                                              bottomRight: msgBy ==
                                                                      "self"
                                                                  ? Radius.circular(0)
                                                                  : Radius.circular(10))),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 20, 0),
                                                    )),
                                                SizedBox(height: 5),
                                                //Text(msg.sentTime)
                                              ],
                                            )
                                          : //Image
                                          Column(
                                              crossAxisAlignment: msgBy ==
                                                      "self"
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(height: 5),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth: Utility()
                                                            .screenWidth(
                                                                context,
                                                                multipliedBy:
                                                                    0.75)),
                                                    child: Container(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: Material(
                                                            child: RoundedImage(
                                                          msg.fileUrl,
                                                          10,
                                                          200,
                                                          showLoader: true,
                                                        )),
                                                      ),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 20, 0),
                                                    )),
                                                SizedBox(height: 5),
                                              ],
                                            );
                                    });
                              } else {
                                return Container();
                              }
                            },
                          )),
                ),
                //bottom message bar
                Container(
                    
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    alignment: Alignment.center,
                                    height: 60,
                                    padding: EdgeInsets.fromLTRB(10, 0, 15, 5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                child: Image.asset(
                                                    "icons/plus.png"),
                                              ),
                                              onTap: () {
                                                imagePicker.showDialog(context);
                                              }),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                              child: TextField(
                                            maxLines: 1,
                                            controller: _txtfieldMsgController,
                                            decoration: InputDecoration(
                                                fillColor: Colors.green,
                                                hintText:
                                                    "Type your message here",
                                                enabledBorder: InputBorder.none,
                                                focusedBorder:
                                                    InputBorder.none),
                                          ))
                                        ])))),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: GestureDetector(
                              child: Container(
                                width: 40,
                                height: 40,
                                child: Image.asset("icons/send@2x.png"),
                              ),
                              onTap: _sendMessage),
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ))
              ])),
          (isLoading == true)
              ? Container(
                  color: Colors.black26,
                  child: Center(child: CircularProgressIndicator()))
              : Container()
        ])));
  }

  @override
  userImage(File _image) {
    if (_image != null) {
      _sendImage(_image.path);
    }
  }
}

class GradientAppBar extends StatelessWidget {
  final String chatId;
  final UserInfo userDetails;
  GradientAppBar(this.chatId, this.userDetails);

  @override
  Widget build(BuildContext context) {
    double screenHeight = Utility().screenHeight(context);
    return Container(
      height: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              height: screenHeight * 0.24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular((screenHeight * 0.24) * 0.4),
                      bottomRight:
                          Radius.circular((screenHeight * 0.24) * 0.4)),
                  gradient: LinearGradient(colors: <Color>[
                    Color.fromRGBO(69, 191, 140, 1),
                    Color.fromRGBO(19, 146, 130, 1)
                  ])), // height of AppBar
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset("icons/back_white.png"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 60,
                              height: 60,
                              // child: userDetails.profilePic != ""
                              //     ? Image.network(
                              //         userDetails.profilePic,
                              //         fit: BoxFit.cover,
                              //       ).image
                              //     : Image.asset("icons/chat_profile_user.png"),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: userDetails.profilePic != ""
                                          ? Image.network(
                                              userDetails.profilePic,
                                              fit: BoxFit.cover,
                                            ).image
                                          : Image.asset(
                                                  "icons/chat_profile_user.png")
                                              .image),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                  border: Border.all(
                                      width: 1, color: Colors.white))),
                          SizedBox(height: 5),
                          Text(
                            userDetails.userName,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
