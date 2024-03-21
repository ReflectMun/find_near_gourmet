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

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  late GoogleMapController _googleMapController;
  Future<Set<Marker>> _markersSet = Future(() => {});
  CameraPosition? _currentCameraPosition;

  @override
  void initState(){
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller){
    _googleMapController = controller;
  }

  void _editMarkerWhenCameraMoved({required double latitude, required double longitude}) async {
    setState(() {
      _markersSet = _editMarker(latitude: latitude, longitude: longitude);
    });
  }

  void _editMarkerWhenPanelClosed() async {
    late final double latitude, longitude;

    if(_currentCameraPosition != null){
      latitude = _currentCameraPosition!.target.latitude;
      longitude = _currentCameraPosition!.target.longitude;
    }
    else{
      final currentPosition = await GeolocationService.getCurrentPosition();

      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
    }

    setState(() {
      _markersSet = _editMarker(latitude: latitude, longitude: longitude);
    });
  }

  Future<Set<Marker>> _editMarker({required double latitude, required double longitude}) async {
    final restaurantList =
        await GourmetApiService.getRestaurantListByLocation(
          lati: latitude, lngi: longitude,
          range: Provider.of<SearchConditionNotifier>(context, listen: false).rangeDistance,
          page: 0,
          count: 100,
          genre: Provider.of<SearchConditionNotifier>(context, listen: false).genre,
          budget: Provider.of<SearchConditionNotifier>(context, listen: false).budget,
        );

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

    return newMarkerSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: 650, // パネルの上がり上限
        minHeight: 125, // パネルの下がり下限
        backdropEnabled: true, // パネルを上げた際にバックグラウンドのタッチを防ぐ
        renderPanelSheet: false, // Floatingパネルを実装するため、基本パネルを非表示にする
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
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: snap.data!,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                      // target: LatLng(34.7024, 135.4959),
                      zoom: 15.5
                    ),
                    onCameraMove: (movedPosition){
                      _currentCameraPosition = movedPosition;
                      _editMarkerWhenCameraMoved(
                        latitude: movedPosition.target.latitude,
                        longitude: movedPosition.target.longitude,
                      );
                    },
                  );
                 }
                 else if(snap.hasError){
                   return const Text("Map pin Error");
                 }
                 else{
                   return const CircularProgressIndicator();
                 }
               },
             );
            }
            else if(snapshot.hasError){
              return const Text("Map Error!!");
            }
            else{
              return const CircularProgressIndicator();
            }

          },
        ),
      ),
      // bottomNavigationBar: BottomAppBar(),
    );
  }
}
