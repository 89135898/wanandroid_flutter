import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtil.white,
      child: Image(
        fit: BoxFit.fitWidth,
        image: AssetImage("assets/images/ic_launch.png"),
      ),
    );
  }
}
