import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/UserUtils.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final List<String> titles = ["头像", "昵称", "点子邮箱", "公开名称", "类型", "用户名称"];
  File _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "个人资料",
          style: TextStyle(color: ColorUtil.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _buildColumn(),
        ),
      ),
    );
  }

  _buildColumn(){
    List<Widget> _widgets = List();
    for (int i = 0; i < titles.length; i++) {
      _widgets.add(_buildItemView(i));
      _widgets.add(Divider(
        height: 0.5,
        color: Colors.grey,
      ));
    }
    return _widgets;
  }

  _buildItemView(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: InkWell(
        onTap: () => _chooseAvatar(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              titles[index],
              style: TextStyle(fontSize: 16, color: ColorUtil.textColor),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: _buildRightView(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _chooseAvatar() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 120,
              child: Column(
                children: <Widget>[
                  _chooseAvatarItem("拍照", true),
                  _chooseAvatarItem("相册选择", false),
                ],
              ),
            ));
  }

  _chooseAvatarItem(String title, bool isTakePhoto) {
    return InkWell(
      child: ListTile(
        title: Text(title),
        leading: Icon(isTakePhoto ? Icons.camera_alt : Icons.photo_library),
        onTap: () => _getImage(isTakePhoto),
      ),
    );
  }

  _getImage(bool isTakePhoto) async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(
        source: isTakePhoto ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  _buildRightView(int index) {
    if (index == 0) {
      return CircleAvatar(
          radius: 30,
          backgroundImage: _image == null
              ? AssetImage("assets/images/default_avatar.png")
              : FileImage(_image));
    } else {
      String text;
      switch (index) {
        case 1:
          text = UserUtils.user().nickname;
          break;
        case 2:
          text = UserUtils.user().email;
          break;
        case 3:
          text = UserUtils.user().password;
          break;
        case 4:
          text = UserUtils.user().publicName;
          break;
        case 5:
          text = UserUtils.user().type.toString();
          break;
        case 6:
          text = UserUtils.user().username;
          break;
        default:
          text = "";
      }
      return Text(text);
    }
  }
}
