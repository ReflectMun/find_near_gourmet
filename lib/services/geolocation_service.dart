import 'package:geolocator/geolocator.dart';

class GeolocationService{
  // 位置情報を取得する機能
  // 位置情報機能がオフにしている又は拒否にしていると再設定を求める
  static Future<Position> getCurrentPosition() async {
    bool isGeolocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isGeolocationServiceEnabled){
      return Future.error("位置情報にオフにしております!");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission != LocationPermission.always || permission != LocationPermission.whileInUse){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
        return await Geolocator.getCurrentPosition();
      }
      return Future.error("位置情報の使用を許可してください!");
    }

    return await Geolocator.getCurrentPosition();
  }

  // 位置情報を再度求める
  static Future<bool> requestGeolocationPermissionAgain() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
        return true;
      }
      else{
        return false;
      }
    }
    else {
      return true;
    }
  }
}