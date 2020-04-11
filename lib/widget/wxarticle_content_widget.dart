import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/entity/ArticleEntity.dart';
import 'package:wanandroidwjz/entity/TopArticleDataEntity.dart';
import 'package:wanandroidwjz/utils/NetUtils.dart';

import 'common_article_item.dart';

class WxarticleContentWidget extends StatefulWidget {
  final int _id;

  const WxarticleContentWidget(this._id, {Key key}) : super(key: key);

  @override
  _WxarticleContentWidgetState createState() => _WxarticleContentWidgetState();
}

class _WxarticleContentWidgetState extends State<WxarticleContentWidget> {
  List<ArticleItemEntity> _articleList = List();
  int _page = 0;
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SmartRefresher(
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: _refreshController,
        child: ListView.builder(
            itemCount: _articleList.length,
            itemBuilder: (context, index) =>
                CommonArticleItem(_articleList[index])),
      ),
    );
  }

  _getData({isRefresh = true}) {
    NetUtils.get("${Api.GET_WXARTICLE_CONTENT_LIST}${widget._id}/$_page/json")
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

  _onRefresh() {
    _getData();
    _refreshController.refreshCompleted();
  }

  _onLoading() {
    _getData(isRefresh: false);
    _refreshController.loadComplete();
  }
}
