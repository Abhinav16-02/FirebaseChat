import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_chat/core/services/firebaseapi.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:flutter/material.dart';

class FirCrudModel extends ChangeNotifier {
  String name = "Abc";
  String image = "";
  // String get image => "";
  // set image(String value){
  //   image = value;
  //   notifyListeners();
  // }
 notify(String url,String userName){
   image = url;
   name = userName;
   notifyListeners();
 }
  FirebaseApi _firApi = locator<FirebaseApi>();

  Stream<QuerySnapshot> fetchAllUser() {
    return _firApi.getAllUsers();
  }

///////
  Future<String> createNewUser(Map userinfo) async {
    return _firApi.setNewUser(userinfo);
  }

  Future addToFriendList(Map friendInfo, String id) async {
    return _firApi.setFriendlist(friendInfo, id);
  }

  
}
