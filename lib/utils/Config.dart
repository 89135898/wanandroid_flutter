
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidwjz/api/Api.dart';

class Config{

  static getCookie() async{
    Map<String, String> map = HashMap();
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(Api.SP_COOKIE);
  }
}