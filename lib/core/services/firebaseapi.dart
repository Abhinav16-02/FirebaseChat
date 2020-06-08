import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firbase_chat/appconstants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseApi {
  final Firestore _db = Firestore.instance;
  final StorageReference _storage = FirebaseStorage.instance.ref();

//getting current user uid or userid
  Future<DocumentReference> _getCurrentUserDocId() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref =
        _db.collection(AppConstants.firUserPath).document(user.uid);
    return ref;
  }

//get user list
  Stream<QuerySnapshot> getAllUsers() {
    return _db.collection(AppConstants.firUserPath).snapshots();
  }

// add users to eachothers friendlist
  Future<void> setFriendlist(Map friendInfo, String toId) async {
    final docRef = _db.collection(AppConstants.firUserPath).document(toId);
    return docRef.updateData({
      AppConstants.friendList: FieldValue.arrayUnion([friendInfo])
    });
  }

//check current user exist
  Future<bool> checkUserExist() async {
    DocumentReference docId = await _getCurrentUserDocId();
    DocumentSnapshot data = await docId.get();
    return data.exists;
  }

// Creting new user on login
  Future<String> setNewUser(Map userInfo) async {
    DocumentReference docId = await _getCurrentUserDocId();
    bool userExist = await checkUserExist();
    
    if (!userExist) {
      docId.setData(userInfo);
    } else {
      docId.updateData({
        "userName": userInfo["userName"],
        "profilePic": userInfo["profilePic"]
      });
    }
    return docId.documentID;
  }

  //Upload image to firebase Storage
  Future<String> uploadFileToFirebase(String filePath) async {
    final file = File(filePath);
    String childName = basename(filePath);
    final StorageReference ref = _storage.child("profilePics").child(childName);
    StorageTaskSnapshot getUrlFrom = await ref.putFile(file).onComplete;
    String url = await getUrlFrom.ref.getDownloadURL();
    return url;
  }

  //send messages to firebase
  Future sendMessage(String toId, Map data) {
    return _db
        .collection(AppConstants.allMessages)
        .document(toId)
        .collection("messages")
        .add(data);
  }

//fetch messages from firebase
  Stream<QuerySnapshot> getMessages(String ofId) {
    return _db
        .collection(AppConstants.allMessages)
        .document(ofId)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }
}
