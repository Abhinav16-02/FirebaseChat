import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_chat/Utilities/Utility.dart';


class MessageInfo {
  String message;
  String messageType;
  String fileUrl;
  String sentTime;
  String sentBy;

  MessageInfo(this.message, this.messageType, this.fileUrl, this.sentBy);

  MessageInfo.fromMap(Map snapshot) {
    this.message = snapshot["message"] ?? "";
    this.messageType = snapshot["messageType"] ?? "";
    this.fileUrl = snapshot["fileUrl"] ?? "";
    this.sentBy = snapshot["sentBy"] ?? "";
    
    Timestamp timeStamp = snapshot["timeStamp"] ?? "";
    this.sentTime = Utility().changeTimeFormat(timeStamp);
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
