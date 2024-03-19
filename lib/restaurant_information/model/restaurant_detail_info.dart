class RestaurantDetailInfoModel{
  final String restaurantName;
  final String kanaName;
  final String address;
  final String open;
  final String close;
  final String photo;
  final String accessRoute;

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