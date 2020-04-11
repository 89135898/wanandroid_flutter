import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wanandroidwjz/api/Api.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/NetUtils.dart';
import 'package:wanandroidwjz/utils/UserUtils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String title;
  final String url;
  final bool collect;
  final int id;

  const WebPage({Key key, this.title, this.url, this.collect, this.id})
      : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final List<String> _titles = List();
  final List<IconData> _iconDataList = List();
  bool collect;
  WebViewController _webViewController;
  @override
  void initState() {
    super.initState();
    collect = widget.collect;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: ColorUtil.white),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        actions: actions(context),
      ),
      body: WebView(
        initialUrl: widget.url,
        // 启用 js交互，默认不启用JavascriptMode.disabled
        javascriptMode: JavascriptMode.unrestricted,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        onWebViewCreated: (controller){
          _webViewController = controller;
        },
        onPageStarted: (url){

        },
        navigationDelegate: (NavigationRequest request){

          return NavigationDecision.navigate;
        },
        //是否开启左划关闭，默认false
        gestureNavigationEnabled: true,
      ),
    );
  }

  _initList() {
    _titles.clear();
    _iconDataList.clear();
    if (collect != null && widget.id > 0) {
      _titles.add(collect ? "取消收藏" : "收藏");
      _iconDataList.add(collect ? Icons.favorite : Icons.favorite_border);
    }
    _titles.add("复制链接");
    _iconDataList.add(Icons.link);
    _titles.add("浏览器打开");
    _iconDataList.add(Icons.open_in_browser);
    _titles.add("微信分享");
    _iconDataList.add(Icons.share);
    _titles.add("刷新");
    _iconDataList.add(Icons.refresh);
  }

  actions(BuildContext context) {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => StatefulBuilder(
                builder: (c, state) {
                  _initList();
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    itemCount: _titles.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) =>
                        _buildActionItem(index, state),
                  );
                },
              ),
            );
          },
          child: Icon(Icons.more_vert),
        ),
      ),
    ];
  }

  _buildActionItem(int index, state) {
    return InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            _iconDataList[index],
            size: 40,
          ),
          Text(_titles[index]),
        ],
      ),
      onTap: () {
        switch (index) {
          case 0:
            if (UserUtils.isLogin()) {
              collect ? _unCollect(state) : _collect(state);
            } else {
              BotToast.showText(text: "请先登录");
            }
            break;
          case 1:
            _copyLink();
            break;
          case 2:
            _openBrowser(widget.url);
            break;
          case 3:

            break;
          case 4:
            _webViewController.reload();
            break;
        }
      },
    );
  }

  _collect(state) {
    if (widget.id <= 0) return;
    BotToast.showLoading(allowClick: false, crossPage: false);
    NetUtils.post("${Api.GET_COLLECT_ARTICLE}/${widget.id}/json")
        .then((value) async {
      BotToast.closeAllLoading();
      var data = json.decode(value);
      if (data["errorCode"] == 0) {
        BotToast.showText(text: "收藏成功");
        state(() {
          collect = !collect;
        });
      } else {
        BotToast.showText(text: data["errorMsg"]);
      }
    });
  }

  _unCollect(state) {
    if (widget.id <= 0) return;
    BotToast.showLoading(allowClick: false, crossPage: false);
    NetUtils.post("${Api.GET_UN_COLLECT_ARTICLE}/${widget.id}/json")
        .then((value) async {
      BotToast.closeAllLoading();
      var data = json.decode(value);
      if (data["errorCode"] == 0) {
        BotToast.showText(text: "取消成功");
        state(() {
          collect = !collect;
        });
      } else {
        BotToast.showText(text: data["errorMsg"]);
      }
    });
  }

  // 复制链接
  _copyLink() {
    ClipboardData data = new ClipboardData(text: widget.url);
    Clipboard.setData(data);
    BotToast.showText(text: "复制成功");
  }

  //打开外部浏览器
  _openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}