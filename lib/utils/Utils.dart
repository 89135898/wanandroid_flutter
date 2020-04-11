import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';

class Utils {
  static setThemeColor(Color color) async {
    String str = "${color.alpha},${color.red},${color.green},${color.blue}";
    var sp = await SharedPreferences.getInstance();
    sp.setString(Api.SP_THEME_CHANGE, str);
  }

  static Future<Color> getThemeColor() async {
    var sp = await SharedPreferences.getInstance();
    var str = sp.getString(Api.SP_THEME_CHANGE).split(",");
    return str.length == 0
        ? ColorUtil.defaultThemeColor
        : Color.fromARGB(int.parse(str[0]), int.parse(str[1]),
            int.parse(str[2]), int.parse(str[3]));
  }
}
