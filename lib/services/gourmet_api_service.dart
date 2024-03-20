import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:find_near_gurume/restaurant_information/model/restaurant_detail_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../search_gourmet/model/restaurant_simple_info.dart';

class GourmetApiService{
  static final String _apiKey = dotenv.env['apiKey']!;
  static const String _scheme = "http";
  static const String _host = "webservice.recruit.co.jp";
  static const String _path = "/hotpepper/gourmet/v1";
  static const String _jsonFormat = "json";
  static final Dio _dio = Dio();

  // GPS上の座標を基準にして周囲のレストランのリストを取得する機能
  static Future<List<RestaurantSimpleInfoModel>> getRestaurantListByLocation({
    required double lati, required double lngi,
    required int range,
    required int page
  }) async {
    final String start = (page * 20 + 1).toString();
    final Uri requestUri = Uri(
      scheme: _scheme,
      host: _host,
      path: _path,
      queryParameters: {
        "key": _apiKey,
        "format": _jsonFormat,
        "lng": lngi.toString(),
        "lat": lati.toString(),
        "range": range.toString(),
        "start": start,
        "count": "20",
      }
    );

    print(requestUri.toString());

    late final dynamic response;
    try {
      response = await _dio.get(requestUri.toString());
    } catch (e) {
      throw Exception("接続できません!!");
    }

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.data);
      Iterable restaurantList = jsonBody['results']['shop'];

      List<RestaurantSimpleInfoModel> result =
        List.from(
          restaurantList.map((restaurant) => RestaurantSimpleInfoModel.fromJson(restaurant))
        );

      return result;
    } else {
      throw Exception("接続できません!!");
    }
  }

  // GPS上の座標を基準にして周囲のレストランのリストを取得する機能
  static Future<List<RestaurantSimpleInfoModel>> getRestaurantMarkerListByLocation({
    required double lati, required double lngi,
    required int range,
    required int page
  }) async {
    final String start = (page * 20 + 1).toString();
    final Uri requestUri = Uri(
        scheme: _scheme,
        host: _host,
        path: _path,
        queryParameters: {
          "key": _apiKey,
          "format": _jsonFormat,
          "lng": lngi.toString(),
          "lat": lati.toString(),
          "range": range.toString(),
          "start": start,
          "count": "20",
        }
    );

    print(requestUri.toString());

    late final dynamic response;
    try {
      response = await _dio.get(requestUri.toString());
    } catch (e) {
      throw Exception("接続できません!!");
    }

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.data);
      Iterable restaurantList = jsonBody['results']['shop'];

      List<RestaurantSimpleInfoModel> result =
      List.from(
          restaurantList.map((restaurant) => RestaurantSimpleInfoModel.fromJson(restaurant))
      );

      return result;
    } else {
      throw Exception("接続できません!!");
    }
  }

  static Future<RestaurantDetailInfoModel> getRestaurantInfoById({required String id}) async {
    final Uri requestUri = Uri(
        scheme: _scheme,
        host: _host,
        path: _path,
        queryParameters: {
          "key": _apiKey,
          "format": _jsonFormat,
          "id": id
        }
    );

    late final Response response;
    try {
      response = await _dio.get(requestUri.toString());
    } catch (e) {
      throw Exception("接続できません!!");
    }

    if(response.statusCode == 200){
      final jsonBody = jsonDecode(response.data);
      RestaurantDetailInfoModel shop = RestaurantDetailInfoModel.fromJson(jsonBody['results']['shop'][0]);
      return shop;
    }
    else{
      throw Exception("情報を取得している途中にエラーが発生しました!!");
    }
  }

  static String getRestaurantTest() {
    getRestaurantInfoById(id: "J002647973");
    return "DT";
  }
}