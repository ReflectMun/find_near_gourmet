// レストランのリストを表示する画面で簡単な情報を表示するウィジェット
// そして、地図上のマーカーで使うデータ
class RestaurantSimpleInfoModel{
  final String id; // レストランのID
  final String restaurantName; // レストランの名
  final String thumbnailURI; // サムネイルのリンク先
  final String accessRoute; // 簡単アクセス
  final String serviceArea; // レストランの所在地域
  final String genre; // レストランのジャンル
  final String budget; // 価格帯
  final double latitude, longitude; // レストランの位置座標

  RestaurantSimpleInfoModel({
    required this.id,
    required this.restaurantName,
    required this.thumbnailURI,
    required this.accessRoute,
    required this.serviceArea,
    required this.genre,
    required this.budget,
    required this.latitude,
    required this.longitude
  });

  factory RestaurantSimpleInfoModel.fromJson(Map<String, dynamic> json) =>
      RestaurantSimpleInfoModel(
          id: json['id'],
          restaurantName: json['name'],
          thumbnailURI: json['photo']['mobile']['s'],
          accessRoute: json['mobile_access'],
          serviceArea: json['middle_area']['name'],
          genre: json['genre']['name'],
          // 価格帯の情報がない場合がある
          budget: json['budget']['name'] != "" ? json['budget']['name'] : "予算情報無し",
          latitude: json['lat'],
          longitude: json['lng'],
      );
}