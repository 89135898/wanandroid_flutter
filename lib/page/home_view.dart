import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidwjz/page/person/person_page.dart';
import 'package:wanandroidwjz/page/setup/setup_page.dart';
import 'package:wanandroidwjz/page/wxarticle/wxarticle_page.dart';
import 'package:wanandroidwjz/widget/bottom_navigation_widget.dart';

import 'home/home_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Widget> _list = List();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _list.add(HomePage());
    _list.add(SetupPage());
    _list.add(WxarticlePage());
    _list.add(PersonPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _list,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationWidget(onTab),
    );
  }

  onTab(index) {
    _currentIndex = index;
    setState(() {});
  }
}
