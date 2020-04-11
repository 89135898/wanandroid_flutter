import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/entity/WxarticleEntity.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/NetUtils.dart';
import 'package:wanandroidwjz/widget/wxarticle_content_widget.dart';

class WxarticlePage extends StatefulWidget {
  @override
  _WxarticlePageState createState() => _WxarticlePageState();
}

class _WxarticlePageState extends State<WxarticlePage>
    with TickerProviderStateMixin {
  List<WxarticleItem> _tabsList = List();
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabsList.length, vsync: this);
    _tabTabs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          tabs: _tabsList.map((tab) {
            return Tab(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(tab.name),
              ),
            );
          }).toList(),
          controller: _tabController,
          isScrollable: true,
          indicatorColor: ColorUtil.white,
          labelColor: ColorUtil.white,
          unselectedLabelColor: ColorUtil.white,
          indicatorWeight: 2,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: EdgeInsets.all(5),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _createPages(),
      ),
    );
  }

  _createPages(){
    List<Widget> widgets = List();
    _tabsList.forEach((v){
      widgets.add(WxarticleContentWidget(v.id));
    });
    return widgets;
  }

  _tabTabs({isRefresh = true}) {
    NetUtils.get(Api.GET_WXARTICLE_LIST).then((value) async {
      var data = json.decode(value);
      var entity = Wxarticle.fromJson(data);
      if (entity.errorCode == 0) {
        setState(() {
          if (isRefresh) {
            _tabsList.clear();
          }
          _tabsList.addAll(entity.data);
          _tabController = TabController(length: _tabsList.length, vsync: this);
        });
      }
    });
  }
}
