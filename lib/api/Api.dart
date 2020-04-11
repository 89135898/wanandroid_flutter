
abstract class Api{

  static const String SP_COOKIE = "Cookie";

  static const String SP_THEME_CHANGE = "SP_THEME_CHANGE";

  static const String BASE_URL = "https://www.wanandroid.com/";

  // 首页文章列表
  static const String GET_ARTICLE_LIST = BASE_URL + 'article/list/';

  // 首页置顶文章列表
  static const String GET_TOP_ARTICLE_LIST = BASE_URL + 'article/top/json';
  //首页banner
  static const String GET_BANNER_LIST = BASE_URL + 'banner/json';
  //体系数据
  static const String GET_TREE_LIST = BASE_URL + 'tree/json';
  //公众号列表
  static const String GET_WXARTICLE_LIST = BASE_URL + 'wxarticle/chapters/json';
  // 公众号列表 https://wanandroid.com/wxarticle/list/408/1/json
  // 公众号 ID：拼接在 url 中，eg:405
  // 公众号页码：拼接在url 中，eg:1
  static const String GET_WXARTICLE_CONTENT_LIST = BASE_URL + 'wxarticle/list/';
  //登录
  static const String LOGIN = BASE_URL + 'user/login';
  //注册
  static const String REGISTER = BASE_URL + 'user/register';
  //获取个人积分，需要登录后访问
  static const String GET_USERINFO = BASE_URL + 'lg/coin/userinfo/json';
  //收藏列表
  static const String GET_COLLECT_LIST = BASE_URL + 'lg/collect/list';
  //收藏文章
  static const String GET_COLLECT_ARTICLE = BASE_URL + 'lg/collect';
  //收藏文章
  static const String GET_UN_COLLECT_ARTICLE = BASE_URL + 'lg/uncollect_originId';
}