import 'package:firbase_chat/core/models/friendListInfo.dart';

class UserInfo {
  String id;
  String userName;
  String profilePic;
  List<FriendListInfo> friendsList;

  UserInfo({this.id, this.userName, this.profilePic});

  UserInfo.fromMap(Map snapshot, String documentId) {
    id = documentId ?? "";
    String name = snapshot["userName"][0].toUpperCase() +
        snapshot["userName"].substring(1);
    userName = name ?? "";
    profilePic = snapshot["profilePic"] ?? "";
    friendsList = (snapshot["friendsList"] as List) != null
        ? (snapshot["friendsList"] as List)
            .map((friendInfo) => FriendListInfo.fromMap(friendInfo))
            .toList()
        : List<FriendListInfo>();
  }

  tojson() {
    return {
      "id": id,
      "userName": userName,
      "profilePic": profilePic,
    };
  }
}
