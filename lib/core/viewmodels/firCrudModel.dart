import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_chat/core/services/firebaseapi.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:flutter/material.dart';

class FirCrudModel extends ChangeNotifier {
  String name = "Abc";
  String image = "";

  notify(String url, String userName) {
    image = url;
    name = userName;
  }

  FirebaseApi _firApi = locator<FirebaseApi>();

  Stream<QuerySnapshot> fetchAllUser() {
    return _firApi.getAllUsers();
  }

  Future<DocumentSnapshot> fetchCurrentUserProfilePic() async {
    return await _firApi.getCurrentUserImage();
  }

  Future addToFriendList(Map friendInfo, String id) async {
    return _firApi.setFriendlist(friendInfo, id);
  }
  
}
