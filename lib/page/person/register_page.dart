import 'dart:collection';
import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/entity/UserEntity.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/UserUtils.dart';
import 'package:wanandroidwjz/utils/NetUtils.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();

  bool _obscureText = true;
  bool _obscureAgainText = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "注册",
          style: TextStyle(color: ColorUtil.white),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              _buildUserNameEdit(),
              _buildPasswordEdit(),
              _buildPasswordAgainEdit(),
              SizedBox(height: 30),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  _buildUserNameEdit() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300,
          child: TextField(
            maxLines: 1,
            maxLength: 18,
            controller: _userNameController,
            decoration: InputDecoration(
              icon: Icon(Icons.perm_identity),
              labelText: '请输入帐号',
            ),
          ),
        ),
        InkWell(
          onTap: () => _userNameController.clear(),
          child: Icon(
            Icons.clear,
            size: 20,
          ),
        ),
      ],
    );
  }

  _buildPasswordEdit() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300,
          child: TextField(
            obscureText: _obscureText,
            maxLines: 1,
            maxLength: 18,
            controller: _passwordController,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: '请输入密码',
            ),
          ),
        ),
        InkWell(
          child: Icon(
            Icons.remove_red_eye,
            size: 20,
          ),
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ],
    );
  }

  _buildPasswordAgainEdit() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300,
          child: TextField(
            obscureText: _obscureAgainText,
            maxLines: 1,
            maxLength: 18,
            controller: _passwordAgainController,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: '请确认密码',
            ),
          ),
        ),
        InkWell(
          child: Icon(
            Icons.remove_red_eye,
            size: 20,
          ),
          onTap: () {
            setState(() {
              _obscureAgainText = !_obscureAgainText;
            });
          },
        ),
      ],
    );
  }

  _buildRegisterButton() {
    return RaisedButton(
      disabledColor: Colors.grey,
      color: ColorUtil.currentThemeColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        width: 320,
        height: 50,
        child: Center(
          child: Text(
            "注册",
            style: TextStyle(color: ColorUtil.white, fontSize: 18),
          ),
        ),
      ),
      onPressed: () {
        _register();
      },
    );
  }

  _register(){
    String userName = _userNameController.value.text.trim();
    if(userName.isEmpty){
      BotToast.showText(text: "账号不能为空");
      return;
    }
    String pwd = _passwordController.value.text.trim();
    if(pwd.isEmpty){
      BotToast.showText(text: "密码不能为空");
      return;
    }
    String pwd2 = _passwordAgainController.value.text.trim();
    if(pwd2.isEmpty){
      BotToast.showText(text: "密码不能为空");
      return;
    }
    if(pwd != pwd2){
      BotToast.showText(text: "密码不一致");
      return;
    }
    Map<String, String> map = HashMap();
    map["username"] = userName;
    map["password"] = pwd;
    map["repassword"] = pwd2;
    NetUtils.post(Api.REGISTER, params: map).then((value) async{
      var data = json.decode(value);
      if (data["errorCode"] == 0) {
        var entity = UserEntity.fromJson(data);
        UserUtils.login(user: entity.data);
        Navigator.pop(context);
      }else{
        BotToast.showText(text: data["errorMsg"]);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _passwordAgainController.dispose();
  }
}
