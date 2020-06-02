import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firbase_chat/appconstants.dart';

class FirebaseApi {
  final Firestore _db = Firestore.instance;

//getting current user uid or userid
  Future<DocumentReference> _getUserDoc() async {
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

// Creting new user on login
  Future<String> setNewUser(Map userInfo) async {
    DocumentReference docId = await _getUserDoc();
    DocumentSnapshot data = await docId.get();
    if (!data.exists) {
      docId.setData(userInfo);
    }
    return docId.documentID;
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
