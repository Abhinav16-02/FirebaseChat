
import 'package:firbase_chat/core/services/firebaseapi.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:flutter/material.dart';


class ProfileViewModel extends ChangeNotifier {
  FirebaseApi _firApi = locator<FirebaseApi>();

  Future<String> uploadFile(String filePath) async {
    return _firApi.uploadFileToFirebase(filePath);
  }

  Future<String> createNewUser(Map userinfo) async {
    return _firApi.setNewUser(userinfo);
  }
}
