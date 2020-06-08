class AppConstants {
  //Firebase cloud firestore paths
  static final String firUserPath = "users";
  static final String allMessages = "allMessages";
  //Firebase subpaths
  static final String friendList = "friendList";
  //Firebase storage paths
  static final String profilePics = "profilePics";
  static final String chatImages  = "ChatImages";
  

  //router names
  static const String enterNumber = "/enterNumber";

  static const String verifyCode = "/verifyCode";

  static const String chatList = "/chatList";

  static const String chatScreen = "/chatScreen";

  static const String profile = "/profile";

  //Msg Types
  static final String msg = "M";
  static final String image = "I";
}
enum ImageType{
  profilePic,
  chatImage,
}
