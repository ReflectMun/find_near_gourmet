import 'package:find_near_gurume/map_screen/widgets/search_condition_setting_panel.dart';
import 'package:find_near_gurume/notifiers/search_condition_notifier.dart';
import 'package:find_near_gurume/search_gourmet/model/restaurant_simple_info.dart';
import 'package:find_near_gurume/services/gourmet_api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../services/geolocation_service.dart';
import 'widgets/collapsed_panel.dart';

// アプリを最初起動する際に表示される画面
class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  late GoogleMapController _googleMapController; // 地図の初期設定に使う
  Future<Set<Marker>> _markersSet = Future(() => {}); // 地図に表示するマーカーのデータ
  CameraPosition? _currentCameraPosition; // 地図の現在画面の中心座標のデータ

  // 地図が最初にローディングする際に行われる
  void _onMapCreated(GoogleMapController controller){
    _googleMapController = controller;
  }

  // 地図のカメラが移されると
  void _editMarkerWhenCameraMoved({required double latitude, required double longitude}) async {
    setState(() {
      _markersSet = _editMarker(latitude: latitude, longitude: longitude);
    });
  }

  // パネルを閉じるとパネルから設定した情報によって新しいレストランの情報を取得し、マーカーを更新する機能
  void _editMarkerWhenPanelClosed() async {
    late final double latitude, longitude;

    // 起動際から一度も地図を移さなかった場合、地図の中心座標情報がないので
    // 地図の中心座標の代わりに利用者の現在位置情報を使用してレストランの検索に使う
    if(_currentCameraPosition != null){
      latitude = _currentCameraPosition!.target.latitude;
      longitude = _currentCameraPosition!.target.longitude;
    }
    else{
      final currentPosition = await GeolocationService.getCurrentPosition();

      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
    }

    // 設定した座標を基盤にてマーカーを修正する
    setState(() {
      _markersSet = _editMarker(latitude: latitude, longitude: longitude);
    });
  }

  // 座標情報をもらって、その座標の周りのレストランを検索し、取得した情報によってマーカーを再配置する
  Future<Set<Marker>> _editMarker({required double latitude, required double longitude}) async {
    // レストラン情報を取得
    final restaurantList =
        await GourmetApiService.getRestaurantListByLocation(
          lati: latitude, lngi: longitude,
          range: Provider.of<SearchConditionNotifier>(context, listen: false).rangeDistance,
          page: 0,
          count: 100,
          genre: Provider.of<SearchConditionNotifier>(context, listen: false).genre,
          budget: Provider.of<SearchConditionNotifier>(context, listen: false).budget,
        );

    // 再配置するマーカーのデータをこもる変数
    Set<Marker> newMarkerSet = {};

    for(final restaurant in restaurantList){
      newMarkerSet.add(
        Marker(
          markerId: MarkerId(restaurant.id),
          position: LatLng(restaurant.latitude, restaurant.longitude),
          infoWindow: InfoWindow(
            title: restaurant.restaurantName,
            snippet: restaurant.genre,
          ),
        )
      );
    }

    // 作られた新しいマーカーリストデータを返信
    return newMarkerSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: 650, // パネルの上がり上限
        minHeight: 125, // パネルの下がり下限
        backdropEnabled: true, // パネルを上げた際にバックグラウンドのタッチを防ぐ
        renderPanelSheet: false,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
        ),
        panel: SearchConditionSettingPanel(position: _currentCameraPosition,), // パネルを上げた際に表示するウィジェット
        collapsed: const CollapsedPanel(), // パネルを下げた際に表示するウィジェット
        onPanelClosed: (){
          _editMarkerWhenPanelClosed();
          GourmetApiService.getRestaurantTest();
        },
        body: FutureBuilder(
          future: GeolocationService.getCurrentPosition(),
          builder: (context, snapshot){
            if(snapshot.hasData){
             return FutureBuilder(
               future: _markersSet,
               builder: (context, snap){
                 if(snap.hasData){
                   // 位置情報に接近できると地図をローディング
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: snap.data!,
                    initialCameraPosition: CameraPosition(
                      // 利用者の位置を最初の中心座標に設定する
                      target: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                      zoom: 15.5
                    ),
                    // カメラが動く都度に地図の中心座標を検索基準座標に設定
                    onCameraMove: (movedPosition){
                      // 移った画面の中心座標を現在の座標に設定
                      _currentCameraPosition = movedPosition;

                      // 地図の
                      _editMarkerWhenCameraMoved(
                        latitude: movedPosition.target.latitude,
                        longitude: movedPosition.target.longitude,
                      );
                    },
                  );
                 }
                 else if(snap.hasError){
                   // マーカーに表示する情報を取得するのに失敗するとエラーメッセージを表示
                   return const Text("通信中に問題が発生しました!");
                 }
                 else{
                   // 通信中であるとローディングアイコンを表示
                   return const CircularProgressIndicator();
                 }
               },
             );
            }
            else if(snapshot.hasError){
              // 位置情報の接近できないとエラーメッセージを表示
              return const Text("位置情報の使用を許可してください!");
            }
            else{
              // 位置情報の取得を待っているとローディングアイコンを表示
              return const CircularProgressIndicator();
            }

          },
        ),
      ),
      // bottomNavigationBar: BottomAppBar(),
    );
  }
}
