import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:find_near_gurume/restaurant_information/model/restaurant_detail_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../search_gourmet/model/restaurant_simple_info.dart';

class GourmetApiService{
  static final String _apiKey = dotenv.env['apiKey']!;
  static const String _scheme = "http";
  static const String _host = "webservice.recruit.co.jp";
  static const String _gourmetPath = "/hotpepper/gourmet/v1";
  static const String _genrePath = "/hotpepper/genre/v1";
  static const String _budgetPath = "/hotpepper/budget/v1";
  static const String _jsonFormat = "json";
  static final Dio _dio = Dio();

  // GPS上の座標を基準にして周囲のレストランのリストを取得する機能
  static Future<List<RestaurantSimpleInfoModel>> getRestaurantListByLocation({
    required double lati, required double lngi,
    required int range,
    required int page,
    int count = 20,
    required String? genre,
    required String? budget,
  }) async {
    final String start = (page * 20 + 1).toString();

    // リクエストURLを作る領域
    final Map<String, String> queryParameters = {
      "key": _apiKey,
      "format": _jsonFormat,
      "lng": lngi.toString(),
      "lat": lati.toString(),
      "range": range.toString(),
      "start": start,
      "count": count.toString(),
    };

    if(genre != null){
      queryParameters.addAll({"genre": genre});
    }

    if(budget != null){
      queryParameters.addAll({"budget": budget});
    }

    final Uri requestUri = Uri(
      scheme: _scheme,
      host: _host,
      path: _gourmetPath,
      queryParameters: queryParameters
    );
    // リクエストURLを作る領域

    // APIにリクエストを送る
    late final dynamic response;
    try {
      response = await _dio.get(requestUri.toString());
    } catch (e) {
      throw Exception("接続できません!!");
    }

    // 取得したデータをオブジェクト化
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.data);
      Iterable restaurantList = jsonBody['results']['shop'];

      // レストランの情報リストに作る
      List<RestaurantSimpleInfoModel> result =
        List.from(
          restaurantList.map((restaurant) => RestaurantSimpleInfoModel.fromJson(restaurant))
        );

      return result;
    } else {
      throw Exception("接続できません!!");
    }
  }

  // レストランのIDでレストランの詳細情報を取得する機能
  static Future<RestaurantDetailInfoModel> getRestaurantInfoById({required String id}) async {
    // リクエストURLを作る
    final Uri requestUri = Uri(
        scheme: _scheme,
        host: _host,
        path: _gourmetPath,
        queryParameters: {
          "key": _apiKey,
          "format": _jsonFormat,
          "id": id
        }
    );

    // リクエストURLを送る
    late final Response response;
    try {
      response = await _dio.get(requestUri.toString());
    } catch (e) {
      throw Exception("接続できません!!");
    }

    // 取得したデータをオブジェクト化する
    if(response.statusCode == 200){
      final jsonBody = jsonDecode(response.data);
      RestaurantDetailInfoModel shop = RestaurantDetailInfoModel.fromJson(jsonBody['results']['shop'][0]);
      return shop;
    }
    else{
      throw Exception("情報を取得している途中にエラーが発生しました!!");
    }
  }

  // 検索するに使えるジャンルのリストを取得する機能
  static Future<List<Map<String, String?>>> getGenreList() async {
    // リクエストURLを作る
    final Uri requestUri = Uri(
        scheme: _scheme,
        host: _host,
        path: _genrePath,
        queryParameters: {
          "key": _apiKey,
          "format": _jsonFormat,
        }
    );

    // リクエストURLを送る
    late final Response response;
    try {
      response = await _dio.get(requestUri.toString());
    } catch (e) {
      throw Exception("接続できません!!");
    }

    // 取得したデータを
    if(response.statusCode == 200){
      final jsonBody = jsonDecode(response.data);
      Iterable genreData = jsonBody['results']['genre'];
      final List<Map<String, String?>> genreList = [{"全て": null}];
      genreList.addAll(
          List.from(genreData.map<Map<String, String?>>( (genre) => {genre['name']: genre['code']} ))
      );
      return genreList;
    }
    else{
      throw Exception("接続できません!!");
    }
  }

  // 検索するに使える価格範囲のリストを取得する機能
  static Future<List<Map<String, String?>>> getBudgetList() async {
    // リクエストURLを作る
    final Uri requestUri = Uri(
        scheme: _scheme,
        host: _host,
        path: _budgetPath,
        queryParameters: {
          "key": _apiKey,
          "format": _jsonFormat,
        }
    );

    // リクエストURLを送る
    late final Response response;
    try {
      response = await _dio.get(requestUri.toString());
    } catch (e) {
      throw Exception("接続できません!!");
    }

    if(response.statusCode == 200){
      final jsonBody = jsonDecode(response.data);
      Iterable budgetData = jsonBody['results']['budget'];
      final List<Map<String, String?>> budgetList = [{"全て": null}];
      budgetList.addAll(
          List.from(budgetData.map<Map<String, String?>>( (genre) => {genre['name']: genre['code']} ))
      );

      return budgetList;
    }
    else{
      throw Exception("接続できません!!");
    }
  }

  static dynamic getRestaurantTest() {
    getBudgetList();
  }
}