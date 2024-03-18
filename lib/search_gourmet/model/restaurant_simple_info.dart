class RestaurantSimpleInfoModel{
  final String id;
  final String restaurantName;
  final String thumbnailURI;
  final String accessRoute;
  final String serviceArea;
  final String genre;
  final String budget;

  RestaurantSimpleInfoModel({
    required this.id,
    required this.restaurantName,
    required this.thumbnailURI,
    required this.accessRoute,
    required this.serviceArea,
    required this.genre,
    required this.budget,
  });

  factory RestaurantSimpleInfoModel.fromJson(Map<String, dynamic> json) =>
      RestaurantSimpleInfoModel(
          id: json['id'],
          restaurantName: json['name'],
          thumbnailURI: json['photo']['mobile']['s'],
          accessRoute: json['mobile_access'],
          serviceArea: json['middle_area']['name'],
          genre: json['genre']['name'],
          budget: json['budget']['name']
      );
}