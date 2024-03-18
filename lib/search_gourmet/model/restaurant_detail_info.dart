class RestaurantDetailInfoModel{
  final String restaurantName;
  final String address;
  final String open;
  final String close;
  final String photo;

  RestaurantDetailInfoModel({
    required this.restaurantName,
    required this.address,
    required this.open,
    required this.close,
    required this.photo
  });

  factory RestaurantDetailInfoModel.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailInfoModel(
        restaurantName: json['name'],
        address: json['address'],
        open: json['open'],
        close: json['close'],
        photo: json['photo']['pc']['l']
      );
}