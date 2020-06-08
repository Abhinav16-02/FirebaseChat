import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_chat/appconstants.dart';
import 'package:firbase_chat/core/services/firebaseapi.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:flutter/material.dart';


class ChatModel extends ChangeNotifier{
  FirebaseApi _firApi = locator<FirebaseApi>();

  Future sendMessageToFirebase(String id, Map message) {
    return _firApi.sendMessage(id, message);
  }

  Stream<QuerySnapshot> fetchAllMessages(String id) {
    return _firApi.getMessages(id);
  }

  Future<String> uploadFile(String filePath) async {
    return await _firApi.uploadFileToFirebase(filePath,ImageType.chatImage);
  }
}
