import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidwjz/entity/UserInfoEntity.dart';
import 'package:wanandroidwjz/page/person/login_page.dart';
import 'package:wanandroidwjz/page/person/user_info_page.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/UserUtils.dart';

class PersonHeadWidget extends StatefulWidget {
  final UserInfoData _userInfoData;

  const PersonHeadWidget(this._userInfoData, {Key key}) : super(key: key);

  @override
  _PersonHeadWidgetState createState() => _PersonHeadWidgetState();
}

class _PersonHeadWidgetState extends State<PersonHeadWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtil.currentThemeColor,
      padding: EdgeInsets.only(top: 50, bottom: 20),
      child: Center(
          child: GestureDetector(
            onTap: () =>
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                UserUtils.isLogin()
                    ? UserInfoPage()
                    : LoginPage())),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildHead(),
                SizedBox(height: 10),
                Text(
                  UserUtils.isLogin() ? UserUtils
                      .user()
                      .nickname : "点击登录",
                  style: TextStyle(fontSize: 16, color: ColorUtil.white),
                ),
                SizedBox(height: 6),
                Text(
                  "等级 ${widget._userInfoData != null ? widget._userInfoData
                      .level : ""}    排名 ${widget._userInfoData != null ? widget
                      ._userInfoData.rank : ""}    积分 ${widget._userInfoData !=
                      null ? widget._userInfoData.coinCount : ""}    ",
                  style: TextStyle(fontSize: 14, color: ColorUtil.white),
                ),
              ],
            ),
          )),
    );
  }

  _buildHead() {
    return Container(
      child: CircleAvatar(
        radius: 45,
        backgroundImage:
        widget._userInfoData == null || UserUtils
            .user()
            .icon
            .isEmpty
            ? AssetImage("assets/images/default_avatar.png")
            : NetworkImage(UserUtils
            .user()
            .icon),
      ),
    );
  }
}
