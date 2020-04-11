import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/entity/ArticleEntity.dart';
import 'package:wanandroidwjz/entity/SetupTreeEntity.dart';
import 'package:wanandroidwjz/entity/TopArticleDataEntity.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/NetUtils.dart';
import 'package:wanandroidwjz/widget/common_article_item.dart';
import 'package:wanandroidwjz/widget/tree_tab_widget.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _refreshController = RefreshController();
  final _articleList = List<ArticleItemEntity>();
  final _treeList = List<SetupTreeItem>();
  int _page = 0;
  int _currentTagId = 60;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("体系", style: TextStyle(color: ColorUtil.white)),
      ),
      body: Column(
        children: <Widget>[
          _treeList.length > 0 ? TreeTabWidget(_treeList, _onTabChange) : Container(),
          _initListView(),
        ],
      ),
    );
  }

  _onTabChange(int tagId){
    _currentTagId = tagId;
    _page = 0;
    _getArticleList();
  }

  _initListView() {
    return Flexible(
      child: SmartRefresher(
        enablePullUp: true,
        controller: _refreshController,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _articleList.length,
          itemBuilder: (context, index) =>
              CommonArticleItem(_articleList[index]),
        ),
      ),
    );
  }

  _getTreeTags() {
    NetUtils.get(Api.GET_TREE_LIST).then((value) async {
      var data = json.decode(value);
      var entity = SetupTreeEntity.fromJson(data);
      setState(() {
        if (entity.errorCode == 0) {
          _treeList.clear();
          _treeList.addAll(entity.data);
          if (_treeList.isNotEmpty && _treeList[0].children.isNotEmpty) {
            _currentTagId = _treeList[0].children[0].id;
            _getArticleList();
          }
        }
      });
    });
  }

  _getArticleList({isRefresh = true}) {
    NetUtils.get("${Api.GET_ARTICLE_LIST}/$_page/json?cid=$_currentTagId")
        .then((value) async {
      var data = json.decode(value);
      var entity = ArticleEntity.fromJson(data);
      if (entity.errorCode == 0) {
        setState(() {
          if (isRefresh) {
            _articleList.clear();
          }
          _articleList.addAll(entity.data.datas);
        });
      }
    });
  }

  _onRefresh() async {
    _getTreeTags();
    _refreshController.refreshCompleted();
  }

  _onLoading() async {
    _page++;
    _getArticleList(isRefresh: false);
    _refreshController.loadComplete();
  }
}
