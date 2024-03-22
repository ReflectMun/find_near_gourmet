// レストランの詳細情報画面で表示するのに使用するデータ
class RestaurantDetailInfoModel{
  final String restaurantName; // レストランの名
  final String kanaName; // レストランの仮名遣い
  final String address; // レストランの住所
  final String open; // レストランの営業時間
  final String close; // レストランの休みの日
  final String photo; // 最上段に表示する写真
  final String accessRoute; // アクセス

  RestaurantDetailInfoModel({
    required this.restaurantName,
    required this.kanaName,
    required this.address,
    required this.open,
    required this.close,
    required this.photo,
    required this.accessRoute,
  });

  factory RestaurantDetailInfoModel.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailInfoModel(
        restaurantName: json['name'],
        kanaName: json['name_kana'],
        address: json['address'],
        open: json['open'],
        close: json['close'],
        photo: json['photo']['pc']['l'],
        accessRoute: json['access']
      );
}