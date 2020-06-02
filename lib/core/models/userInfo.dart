import 'package:firbase_chat/core/models/friendListInfo.dart';

class UserInfo {
  String id;
  String userName;
  String profilePic;
  List<FriendListInfo> friendsList;

  UserInfo({this.id, this.userName, this.profilePic});

  UserInfo.fromMap(Map snapshot,String documentId) {
    id = documentId ?? "";
    userName = snapshot["userName"] ?? "";
    profilePic = snapshot["profilePic"] ?? "";
    friendsList = (snapshot["friendsList"] as List) != null  ? 
        (snapshot["friendsList"] as List).map((friendInfo) => FriendListInfo.fromMap(friendInfo))
        .toList() : List<FriendListInfo>() ;
  }

  tojson() {
    return {
      "id": id,
      "userName": userName,
      "profilePic": profilePic,
    };
  }
}
