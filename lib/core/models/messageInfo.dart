import 'package:cloud_firestore/cloud_firestore.dart';

class MessageInfo {
  String message;
  String messageType;
  String fileUrl;
  Timestamp timeStamp;
  String sentBy;

  MessageInfo(this.message, this.messageType, this.fileUrl, this.sentBy);

  MessageInfo.fromMap(Map snapshot) {
    this.message = snapshot["message"] ?? "";
    this.messageType = snapshot["messageType"] ?? "";
    this.fileUrl = snapshot["fileUrl"] ?? "";
    this.timeStamp = snapshot["timeStamp"] ?? "";
    this.sentBy = snapshot["sentBy"] ?? "";
  }

  toMap() {
    return {
      "message": message,
      "messageType": messageType,
      "fileUrl": fileUrl,
      "timeStamp": Timestamp.now(),
      "sentBy": sentBy,
    };
  }
}
