// ignore_for_file: constant_identifier_names
const String url = "https://foodlab.site/api";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();
  //backend_url
  static String signUp() => "/user/signup";
  static String login() => "/login/user";



///profile
  static String profile() => "/profile";




  // static String getShopByCategories(String slug) =>
  //     "/api/shop-categories/$slug/";

    static String example() => "/api/";

  static String products(int pageNum, int perPage) => "/products?page=$pageNum&per_page=$perPage";
  static String productDetails(int id) => "/products/$id";
}
