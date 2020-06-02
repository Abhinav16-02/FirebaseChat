class FriendListInfo {
  String userId;
  String chatId;

  FriendListInfo({this.userId, this.chatId});

  FriendListInfo.fromMap(Map snapshot) {
    userId = snapshot["id"] ?? "";
    chatId = snapshot["id"] ?? "";
  }

  tojson() {
    return {
      "id": userId,
      "chatId": chatId,
    };
  }

}
