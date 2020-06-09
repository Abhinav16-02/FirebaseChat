import 'package:cloud_firestore/cloud_firestore.dart';

class FriendListInfo {
  String userId;
  String chatId;
  String timeStamp;

  FriendListInfo({this.userId, this.chatId});

  FriendListInfo.fromMap(Map snapshot) {
    userId = snapshot["id"] ?? "";
    chatId = snapshot["id"] ?? "";
  }

  tojson() {
    return {
      "id": userId,
      "chatId": chatId,
    };
  }

}
