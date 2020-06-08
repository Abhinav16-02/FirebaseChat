import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  // static final SharedData _shared = SharedData();
  // factory SharedData() => _shared;
  
  //final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  _getSharedPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
   // SharedPreferences pref = await _pref;
    return pref;
  }

   saveCurrentUUID(String id) async{
    //SharedPreferences pref = _getSharedPref();
   final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("uuid", id);
  }

 Future<bool>saveCurrentUserID(String id) async{
    //SharedPreferences pref = _getSharedPref();
   final SharedPreferences pref = await SharedPreferences.getInstance();
   return await pref.setString("userId", id);
  }

  saveCurrentUserName(String name) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("name", name);
  }
 saveCurrentUserImage(String image) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
   pref.setString("image", image);
 }
 Future<String> getCurrentUIID() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    //SharedPreferences pref = _getSharedPref();
    return pref.getString("uuid");
  }
  Future<String> getCurrentUserId() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("userId");
  }
  Future<String> getCurrentName() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    //SharedPreferences pref = _getSharedPref();
    return pref.getString("name");
  }
  Future<String> getCurrentUserImage() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    //SharedPreferences pref = _getSharedPref();
    return pref.getString("image");
  }

  clearData() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.clear();
  }
}
