import 'package:firbase_chat/ChatList.dart';
import 'package:firbase_chat/ChatScreen.dart';
import 'package:firbase_chat/main.dart';
import 'package:firbase_chat/profile.dart';
import 'package:flutter/material.dart';
import 'package:firbase_chat/VerifyOtp.Dart';
import 'package:firbase_chat/appconstants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map arguments = settings.arguments;
    switch (settings.name) {
      case AppConstants.enterNumber:
        return MaterialPageRoute(builder: (_) => ChatApp());
      case AppConstants.verifyCode:
        return MaterialPageRoute(builder: (_) => VerifyOtp());
      case AppConstants.chatList:
        return MaterialPageRoute(builder: (_) => ChatList());
      case AppConstants.chatScreen:
        return MaterialPageRoute(
            builder: (_) =>
                ChatScreen(arguments["chatId"], arguments["userId"],arguments["profilePic"]));
      case AppConstants.profile:
        return MaterialPageRoute(builder: (_) => Proflie(arguments["back"],name: arguments["name"],image:arguments["image"]));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                    body: Center(
                  child: Text("NO Route added"),
                )));
    }
  }
}
