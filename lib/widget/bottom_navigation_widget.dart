import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatefulWidget {
  ValueChanged tabCallBack;

  BottomNavigationWidget(this.tabCallBack);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>();
  int _currentIndex = 0;

  @override
  void initState() {
    _initItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            widget.tabCallBack(_currentIndex);
          });
        },
        items: items,
      ),
    );
  }

  _initItems() {
    items
      ..add(BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text("首页"),
      ))
      ..add(BottomNavigationBarItem(
        icon: Icon(Icons.business),
        title: Text("体系"),
      ))
      ..add(BottomNavigationBarItem(
        icon: Icon(Icons.school),
        title: Text("公众号"),
      ))
      ..add(BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text("我的"),
      ));
    return items;
  }
}
