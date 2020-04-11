import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidwjz/entity/SetupTreeEntity.dart';
import 'package:wanandroidwjz/utils/ColorUtils.dart';

class TreeTabWidget extends StatefulWidget {
  final List<SetupTreeItem> treeList;

  const TreeTabWidget(this.treeList , this.onTabCallBack, {Key key}) : super(key: key);

  final onTabCallBack;

  @override
  _TreeTabWidgetState createState() => _TreeTabWidgetState();
}

class _TreeTabWidgetState extends State<TreeTabWidget> {
  //1级分类当前选项
  int _firstSelectIndex = 0;

  //2级分类当前选项
  int _secondSelectIndex = 0;

  static const FIST_TAB_TYPE = 0x122;
  static const SECOND_TAB_TYPE = 0x211;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtil.currentThemeColor,
      child: Column(
        children: <Widget>[
          _initTabs(FIST_TAB_TYPE),
          Divider(height: 0.5, color: ColorUtil.white,),
          _initTabs(SECOND_TAB_TYPE),
        ],
      ),
    );
  }

  _initTabs(int type) {
    return Container(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _getTabLength(type),
          itemBuilder: (context, index) {
            return _buildFirstTab(type, index);
          }),
    );
  }

  _buildFirstTab(int type, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: _showBorder(type, index), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: InkWell(
          onTap: () => _onTab(type, index),
          child: Text(
            _getTabValue(type, index),
            style: TextStyle(
              fontSize: 14,
              color: ColorUtil.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _onTab(int type, int index){
    if (type == FIST_TAB_TYPE) {
      //1级菜单
      if(index != _firstSelectIndex){
        setState(() {
          _firstSelectIndex = index;
          _secondSelectIndex = 0;
          if(widget.treeList[_firstSelectIndex].children.isNotEmpty){
            widget.onTabCallBack(widget.treeList[_firstSelectIndex].children[_secondSelectIndex].id);
          }
        });
      }
    } else {
      //2级菜单
      if(index != _secondSelectIndex){
        setState(() {
          _secondSelectIndex = index;
          if(widget.treeList[_firstSelectIndex].children.isNotEmpty){
            widget.onTabCallBack(widget.treeList[_firstSelectIndex].children[_secondSelectIndex].id);
          }
        });
      }
    }
  }

  _getTabLength(int type){
    if (type == FIST_TAB_TYPE) {
      //1级菜单
      return widget.treeList.length;
    } else {
      //2级菜单
      return widget.treeList[_firstSelectIndex].children.length;
    }
  }

  _getTabValue(int type, int index) {
    if (type == FIST_TAB_TYPE) {
      //1级菜单
      return widget.treeList[index].name;
    } else {
      //2级菜单
      return widget.treeList[_firstSelectIndex].children[index].name;
    }
  }

  _showBorder(int type, int index) {
    if (type == FIST_TAB_TYPE) {
      //1级菜单
      return _firstSelectIndex == index
          ? ColorUtil.white
          : ColorUtil.currentThemeColor;
    } else {
      //2级菜单
      return _secondSelectIndex == index
          ? ColorUtil.white
          : ColorUtil.currentThemeColor;
    }
  }
}
