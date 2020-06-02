import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_chat/Utilities/Utility.dart';
import 'package:firbase_chat/core/models/messageInfo.dart';
import 'package:firbase_chat/core/viewmodels/chatModel.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  ChatScreen(this.chatId, this.currentUserId);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatId;
  String currentUserId;
  List<MessageInfo> allMessages;
  final modal = locator<ChatModel>();
  TextEditingController _txtfieldMsgController;
  ScrollController _msgListController;

  @override
  void initState() {
    super.initState();
    _msgListController = ScrollController();
    _txtfieldMsgController = TextEditingController();
    chatId = widget.chatId;
    currentUserId = widget.currentUserId;
  }

  _sendMessage() {
    setState(() {
      if (_txtfieldMsgController.text.isNotEmpty) {
        String msg = _txtfieldMsgController.text;
        _txtfieldMsgController.text = "";
        Map info = MessageInfo(msg, "M", "", widget.currentUserId).toMap();
        modal.sendMessageToFirebase(chatId, info).then((value) {
          _msgListController.animateTo(0.0,
              duration: Duration(microseconds: 2), curve: Curves.easeOut);
        });
      } else {
        SnackBar error = SnackBar(
          content: Text("Please enter some message"),
        );
        Scaffold.of(context).showSnackBar(error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => modal,
        child: SafeArea(
            child: Scaffold(
                body: Container(
                    alignment: Alignment.center,
                    child: Column(children: <Widget>[
                      Container(
                        height: Utility().screenHeight(context) * 0.24,
                        child: 
                        GradientAppBar(widget.chatId),
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
                                            String msgBy =
                                                allMessages[index].sentBy ==
                                                        currentUserId
                                                    ? "self"
                                                    : "";

                                            return Column(
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
                                                      child: Text(
                                                        "${allMessages[index].message}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
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
                                              ],
                                            );
                                          });
                                    } else {
                                      return Container();
                                    }
                                  },
                                )),
                      ),
                      Container(
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                      height: 60,
                                      padding:
                                          EdgeInsets.fromLTRB(40, 0, 15, 5),
                                      child: TextField(
                                        maxLines: 1,
                                        controller: _txtfieldMsgController,
                                        decoration: InputDecoration(
                                          fillColor: Colors.green,
                                          hintText: "Enter message",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.grey[200],
                                                width: 2),
                                          ),
                                        ),
                                      ))),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: GestureDetector(
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: Image.asset("icons/send@2x.png"),
                                    ),
                                    onTap: _sendMessage),
                              ),
                              SizedBox(
                                width: 40,
                              )
                            ],
                          ))
                    ])))));
  }
}

class GradientAppBar extends StatelessWidget {
  final String chatId;
  GradientAppBar(this.chatId);

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
                              child: Image.asset(
                                'icons/user_profilr_pic@3x.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1, color: Colors.white))),
                          SizedBox(height: 5),
                          Text(
                            "UserName",
                            style: TextStyle(color: Colors.white),
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
