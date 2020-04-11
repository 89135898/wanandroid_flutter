import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/entity/UserEntity.dart';

class UserUtils {
  static UserData _user;

  static login({UserData user}) async {
    if (user == null) {
       _getUserInfo().then((value) async{
         _user = value;
      });
      return;
    }

    _user = user;

    await SharedPreferences.getInstance()
      ..setBool("admin", user.admin)
      ..setString("email", user.email)
      ..setString("icon", user.icon)
      ..setInt("id", user.id)
      ..setString("nickname", user.nickname)
      ..setString("password", user.password)
      ..setString("publicName", user.publicName)
      ..setString("token", user.token)
      ..setInt("type", user.type)
      ..setString("username", user.username)
      ..setBool("isLogin", true)
      ..setString(Api.SP_COOKIE, "loginUserName=${user.username};loginUserPassword=${user.password}");
  }

  static _getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var isLogin = sp.getBool("isLogin");
    if (isLogin == null || !isLogin) {
      return;
    }
    return UserData(
      admin: sp.getBool("admin"),
      email: sp.getString("email"),
      icon: sp.getString("icon"),
      id: sp.getInt("id"),
      nickname: sp.getString("nickname"),
      password: sp.getString("password"),
      publicName: sp.getString("publicName"),
      token: sp.getString("token"),
      type: sp.getInt("type"),
      username: sp.getString("username"),
    );
  }

  static UserData user(){
    if(_user == null){
      _user = UserData();
    }
    return _user;
  }

  static loginOut() async {
    _user = null;

    await SharedPreferences.getInstance()
      ..setBool("admin", null)
      ..setString("email", "")
      ..setString("icon", "")
      ..setInt("id", -1)
      ..setString("nickname", "")
      ..setString("password", "")
      ..setString("publicName", "")
      ..setString("token", "")
      ..setInt("type", -1)
      ..setString("username", "")
      ..setBool("isLogin", false)
      ..setString(Api.SP_COOKIE, null);
  }

  static bool isLogin() => _user != null;
}
