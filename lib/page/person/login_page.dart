import 'dart:collection';
import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/entity/UserEntity.dart';
import 'package:wanandroidwjz/page/person/register_page.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/UserUtils.dart';
import 'package:wanandroidwjz/utils/NetUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "登录",
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
              _buildRegisterButton(),
              SizedBox(height: 30),
              _buildLoginButton(),
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

  _buildRegisterButton() {
    return Center(
      child: Container(
        width: 320,
        padding: EdgeInsets.only(top: 10),
        child: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            child: Text("还没有账号？点击注册"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
          ),
        ),
      ),
    );
  }

  _buildLoginButton() {
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
            "登录",
            style: TextStyle(color: ColorUtil.white, fontSize: 18),
          ),
        ),
      ),
      onPressed: () {
        _login();
      },
    );
  }

  _login() {
    String name = _userNameController.value.text;
    if (name.isEmpty) {
      BotToast.showText(text: "帐号不能为空");
      return;
    }
    String password = _passwordController.value.text;
    if (password.isEmpty) {
      BotToast.showText(text: "密码不能为空");
      return;
    }
    Map<String, String> map = HashMap();
    map["username"] = name;
    map["password"] = password;
    NetUtils.post(Api.LOGIN, params: map).then((value) async {
      var data = json.decode(value);
      if(data["errorCode"] == 0){
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
  }
}
