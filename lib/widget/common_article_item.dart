import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidwjz/entity/TopArticleDataEntity.dart';
import 'package:wanandroidwjz/page/web_page.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';

class CommonArticleItem extends StatelessWidget {
  ArticleItemEntity _bean;

  CommonArticleItem(this._bean);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebPage(
                  title: _bean.title,
                  url: _bean.link,
                  collect: _bean.collect,
                  id: _bean.id,
                ),
              ));
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _bean.title,
                style: TextStyle(fontSize: 16, color: ColorUtil.textColor),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  _bean.type == 1
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.redAccent, width: 0.5),
                            color: ColorUtil.white,
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          child: Text(
                            "置顶",
                            style: TextStyle(
                                fontSize: 12, color: Colors.redAccent),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 2))
                      : Container(),
                  _bean.fresh != null && _bean.fresh
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.redAccent, width: 0.5),
                            color: ColorUtil.white,
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          child: Text(
                            "最新",
                            style: TextStyle(
                                fontSize: 12, color: Colors.redAccent),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 2),
                        )
                      : Container(),
                  Text(
                    _bean.author != null && _bean.author.isNotEmpty
                        ? "作者：${_bean.author}"
                        : _bean.shareUser != null && _bean.shareUser.isNotEmpty
                            ? "分享人：${_bean.shareUser}"
                            : "",
                    style:
                        TextStyle(fontSize: 12, color: ColorUtil.textDarkColor),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _bean.niceShareDate != null ? _bean.niceShareDate : "",
                        style: TextStyle(
                            fontSize: 12, color: ColorUtil.textDarkColor),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
