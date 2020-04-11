import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/entity/ArticleEntity.dart';
import 'package:wanandroidwjz/entity/TopArticleDataEntity.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/NetUtils.dart';
import 'package:wanandroidwjz/widget/common_article_item.dart';

class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  final _refreshController = RefreshController();
  final List<ArticleItemEntity> _articleItemList = List();
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _getCollect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "我的收藏",
          style: TextStyle(color: ColorUtil.white),
        ),
      ),
      body: SmartRefresher(
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: _refreshController,
        child: ListView.builder(
          itemBuilder: (context, index) =>
              CommonArticleItem(_articleItemList[index]),
          itemCount: _articleItemList.length,
        ),
      ),
    );
  }

  _getCollect({isRefresh = true}) {
    NetUtils.get("${Api.GET_COLLECT_LIST}/$_page/json").then((value) async {
      var data = json.decode(value);
      var entity = ArticleEntity.fromJson(data);
      setState(() {
        if (isRefresh) {
          _articleItemList.clear();
        }
        _articleItemList.addAll(entity.data.datas);
      });
    });
  }

  _onRefresh() {
    _getCollect();
    _refreshController.refreshCompleted();
  }

  _onLoading() {
    _getCollect(isRefresh: false);
    _refreshController.loadComplete();
  }
}
