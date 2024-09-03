import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPrefUserLoggedKey = "ISLOGGEDIN";
  static String sharedPrefUserNameKey = "USERNAMEKEY";
  static String sharedPrefUserEmailKey = "USEREMAILKEY";

  ///setters

  static Future<bool> saveUserLoggedInSharedPref(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefUserLoggedKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPref(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPref(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserEmailKey, userEmail);
  }

  ///getters

  static Future<bool> getUserLoggedInSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefUserLoggedKey)!;
  }

  static Future<String> getUserNameSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefUserNameKey)!;
  }

  static Future<String> getUserEmailSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefUserEmailKey)!;
  }
}
