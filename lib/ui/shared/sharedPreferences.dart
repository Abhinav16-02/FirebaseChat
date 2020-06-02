import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static final _shared = SharedData();
  factory SharedData() => _shared;

  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  _getSharedPref() async {
    SharedPreferences pref = await _pref;
    return pref;
  }

  saveCurrentUserID(String id) async{
    //SharedPreferences pref = _getSharedPref();
    SharedPreferences pref = await _pref;
    pref.setString("userId", id);
  }

  Future<String> getCurrentUserId() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    //SharedPreferences pref = _getSharedPref();
    return pref.getString("userId");
  }
}
