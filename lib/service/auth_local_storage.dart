import 'dart:convert';

import 'package:bbvision/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  static const _loginKey = 'login_response';
  static const _passwordKey = 'user_password';
  static const userGroupCode = '';
  static const userId = '';

  //save
  static Future<void> saveLogin(LoginModel model, String password) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_passwordKey, password);
    await pref.setString(_loginKey, jsonEncode(model.toJson()));
  }

  //get data
  static Future<LoginModel?> getLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_loginKey);
    if (data == null) return null;
    return LoginModel.fromJson(jsonDecode(data));
  }

  // Get password
  static Future<String?> getPassword() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_passwordKey);
  }

  // // Get Group code
  static Future<String?> getGroupCode() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userGroupCode);
  }

  //clear datas
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  //already loggedIn
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_loginKey);
  }
}
