
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wanandroidwjz/api/Api.dart';

class NetUtils{

  static get(String url, {Map<String, String> params}) async{
    if(params != null){
      StringBuffer sb = StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }
    var dio = Dio();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var cookieJar = PersistCookieJar(dir: tempPath);
    dio.interceptors.add(CookieManager(cookieJar));
    Response<String> response = await dio.get(url);
    return response.data;
  }

  static post(String url, {Map<String, String> params}) async{
    var dio = Dio();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var cookieJar = PersistCookieJar(dir: tempPath);
    dio.interceptors.add(CookieManager(cookieJar));
    Response<String> response = await dio.post(url, queryParameters: params);
    return response.data;
  }
}