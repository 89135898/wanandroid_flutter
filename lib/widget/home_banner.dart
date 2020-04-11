import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroidwjz/entity/BannerEntity.dart';
import 'package:wanandroidwjz/page/web_page.dart';

class HomeBanner extends StatelessWidget {
  List<BannerItem> _bannerList;

  HomeBanner(this._bannerList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: Swiper(
        itemCount: _bannerList.length,
        pagination: SwiperPagination(),
        autoplay: _bannerList.isNotEmpty,
        itemBuilder: (context, index) {
          return Image.network(
            _bannerList[index].imagePath,
            fit: BoxFit.fill,
          );
        },
        onTap: (index) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebPage(
                  title: _bannerList[index].title,
                  url: _bannerList[index].url,
                ),
              ));
        },
      ),
    );
  }
}
