import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/entity/UserInfoEntity.dart';
import 'package:wanandroidwjz/page/person/change_theme_page.dart';
import 'package:wanandroidwjz/page/person/collect_page.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/NetUtils.dart';
import 'package:wanandroidwjz/utils/UserUtils.dart';
import 'package:wanandroidwjz/widget/person_head_widget.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final _refreshController = RefreshController();
  UserInfoData _userInfoData;
  final List _menuTitles = [
    "我的积分",
    "我的收藏",
    "我的博客",
    "主题设置",
    "关于作者",
    "退出登录",
  ];
  final List _menuIcons = [
    Icons.message,
    Icons.map,
    Icons.account_balance_wallet,
    Icons.settings,
    Icons.info,
    Icons.backspace,
  ];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("我的", style: TextStyle(color: ColorUtil.white)),
        ),
        body: SmartRefresher(
          onRefresh: _onRefresh,
          controller: _refreshController,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: PersonHeadWidget(_userInfoData),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildMenuItem(index),
                  childCount: _menuTitles.length,
                ),
              ),
            ],
          ),
        ));
  }

  _buildMenuItem(int index) {
    return ListTile(
      leading: Icon(_menuIcons[index]),
      title: Text(_menuTitles[index]),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
      ),
      onTap: (){
        switch(index){
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => CollectPage()));
            break;
          case 3:
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeThemePage()));
            break;
          case 5:
            setState(() {
              _userInfoData = null;
              UserUtils.loginOut();
            });
            break;
        }
      },
    );
  }

  _getUserInfo() {
    if (!UserUtils.isLogin()) return;
    NetUtils.get(Api.GET_USERINFO).then((value) async {
      var data = json.decode(value);
      var entity = UserInfoEntity.fromJson(data);
      if (entity.errorCode == 0) {
        setState(() {
          _userInfoData = entity.data;
        });
      }
    });
  }

  _onRefresh() {
    _getUserInfo();
    _refreshController.refreshCompleted();
  }
}
