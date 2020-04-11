import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/entity/ArticleEntity.dart';
import 'package:wanandroidwjz/entity/BannerEntity.dart';
import 'package:wanandroidwjz/entity/TopArticleDataEntity.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/NetUtils.dart';
import 'package:wanandroidwjz/widget/common_article_item.dart';
import 'package:wanandroidwjz/widget/home_banner.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ArticleItemEntity> _articleTopDataList = List();
  final List<ArticleItemEntity> _articleDataList = List();
  final List<ArticleItemEntity> _articleList = List();
  final List<BannerItem> _bannerList = List();
  final _refreshController = RefreshController();
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页", style: TextStyle(color: ColorUtil.white)),
      ),
      body: _initView(),
    );
  }

  _initView() {
    return SmartRefresher(
      enablePullUp: true,
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: HomeBanner(_bannerList),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => CommonArticleItem(_articleList[index]),
                childCount: _articleList.length),
          ),
        ],
      ),
    );
  }

  _initData() {
    _getArticleList();
    _getBanner();
  }

  _getBanner() {
    NetUtils.get(Api.GET_BANNER_LIST).then((value) async {
      var data = json.decode(value);
      var entity = BannerEntity.fromJson(data);
      if (entity.errorCode == 0) {
        _bannerList.clear();
        _bannerList.addAll(entity.data);
      }
    });
  }

  _getArticleList({isRefresh = true}) {
    //获取置顶信息
    if (isRefresh) {
      NetUtils.get(Api.GET_TOP_ARTICLE_LIST).then((value) async {
        var data = json.decode(value);
        var entity = TopArticleEntity.fromJson(data);
        if (entity.errorCode == 0) {
          _articleTopDataList.clear();
          _articleTopDataList.addAll(entity.data);
          setState(() {
            _articleList.clear();
            _articleList.addAll(_articleTopDataList);
            _articleList.addAll(_articleDataList);
          });
        }
      });
    }
    //获取首页内容
    NetUtils.get("${Api.GET_ARTICLE_LIST}/$_page/json").then((value) {
      var data = json.decode(value);
      var entity = ArticleEntity.fromJson(data);
      if (entity.errorCode == 0) {
        if (isRefresh) {
          _articleDataList.clear();
        }
        _articleDataList.addAll(entity.data.datas);
        if (mounted) {
          setState(() {
            _articleList.clear();
            _articleList.addAll(_articleTopDataList);
            _articleList.addAll(_articleDataList);
          });
        }
      }
    });
  }

  _onRefresh() async {
    _page = 0;
    _getArticleList();
    _getBanner();
    _refreshController.refreshCompleted();
  }

  _onLoading() async {
    _page++;
    _getArticleList(isRefresh: false);
    _refreshController.loadComplete();
  }
}
