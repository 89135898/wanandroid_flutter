import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidwjz/entity/EventEntity.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';
import 'package:wanandroidwjz/utils/UserUtils.dart';
import 'package:wanandroidwjz/utils/Utils.dart';

class ChangeThemePage extends StatefulWidget {
  @override
  _ChangeThemePageState createState() => _ChangeThemePageState();
}

class _ChangeThemePageState extends State<ChangeThemePage> {

  List<Color> colors = ColorUtil.supportColors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "切换主题",
          style: TextStyle(
            color: ColorUtil.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(ColorUtil.supportColors.length, (index){
            return InkWell(
              child: Container(
                color: colors[index],
              ),
              onTap: (){
                Utils.setThemeColor(colors[index]);
                ColorUtil.currentThemeColor = colors[index];
                eventBus.fire(EventEntity(code: EventEntity.CHANGE_THEME));
              },
            );
          }),
        ),
      ),
    );
  }
}
