// import 'package:flutter_twitter_clone/model/link_media_info.dart';
// import 'dart:convert';
// import 'package:flutter_twitter_clone/model/user.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  Future clearPreferenceValues() async {
    (await SharedPreferences.getInstance()).clear();
  }

// UID
  getUserId() async {
    final String? jsonString =
        (await SharedPreferences.getInstance()).getString("userId");
    if (jsonString == null) return "";
    return jsonString;
  }

  saveUserId(id) async {
    return (await SharedPreferences.getInstance()).setString("userId", id);
  }

  deleteUserId() async {
    return (await SharedPreferences.getInstance()).remove("userId");
  }

  // User Data

  // Future<UserModel?> getUserData() async {
  //   final String? jsonString =
  //       (await SharedPreferences.getInstance()).getString("userData");
  //   if (jsonString == null) return null;
  //   return UserModel.fromJson(json.decode(jsonString));
  // }

  saveUserData(user) async {
    return (await SharedPreferences.getInstance())
        .setString("userData", json.encode(user));
  }

  deleteUserData() async {
    return (await SharedPreferences.getInstance()).remove("userData");
  }
  // Future<bool> saveUserAuthData(UserAuthModel user) async {
  //   return (await SharedPreferences.getInstance())
  //       .setString('userAuthModel', json.encode(user.toJson()));
  // }

  // Future<UserAuthModel?> getUserAuthData() async {
  //   final String? jsonString =
  //       (await SharedPreferences.getInstance()).getString('userAuthModel');
  //   if (jsonString == null) return null;
  //   return UserAuthModel.fromJson(json.decode(jsonString));
  // }
}
