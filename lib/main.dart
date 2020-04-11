import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroidwjz/page/home_view.dart';
import 'package:wanandroidwjz/page/splash_page.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/UserUtils.dart';
import 'package:wanandroidwjz/utils/Utils.dart';

import 'entity/EventEntity.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _showSplashPage = true;

  @override
  void initState() {
    super.initState();
    UserUtils.login();
    Utils.getThemeColor().then((value) {
      setState(() {
        ColorUtil.currentThemeColor = value;
      });
    });
    eventBus.on<EventEntity>().listen((data) {
      if (data.code == EventEntity.CHANGE_THEME) setState(() {});
    });
    _countDown();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => WaterDropHeader(),
      // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
      footerBuilder: () => ClassicFooter(),
      // 配置默认底部指示器
      headerTriggerDistance: 80.0,
      // 头部触发刷新的越界距离
      springDescription:
      SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
      // 自定义回弹动画
      maxOverScrollExtent: 100,
      //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
      maxUnderScrollExtent: 0,
      // 底部最大可以拖动的范围
      enableScrollWhenRefreshCompleted: true,
      //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
      enableLoadingWhenFailed: true,
      //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
      hideFooterWhenNotFull: false,
      // Viewport不满一屏时,禁用上拉加载更多功能
      enableBallisticLoad: true,
      // 可以通过惯性滑动触发加载更多
      child: BotToastInit(
        child: MaterialApp(
          //取消显示debug
          debugShowCheckedModeBanner: false,
          //注册路由观察者
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: ThemeData(
            primaryColor: ColorUtil.currentThemeColor,
            //右滑返回
            platform: TargetPlatform.iOS,
          ),
          title: "玩安卓",
          home: _showSplashPage ? SplashPage() : HomeView(),
        ),
      ),
    );
  }


  _countDown() {
    var duration = Duration(seconds: 3);
    Future.delayed(duration, () {
        setState(() {
          _showSplashPage = !_showSplashPage;
        });
    });
  }
}
