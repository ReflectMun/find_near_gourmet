import 'package:find_near_gurume/map_screen/search_condition_setting_panel.dart';
import 'package:find_near_gurume/notifiers/search_condition_notifier.dart';
import 'package:find_near_gurume/search_gourmet/model/restaurant_simple_info.dart';
import 'package:find_near_gurume/services/gourmet_api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../services/geolocation_service.dart';
import 'collapsed_panel.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  late GoogleMapController _googleMapController;
  final Set<Marker> _markersSet = {};

  void _onMapCreated(GoogleMapController controller){
    _googleMapController = controller;
  }

  void _addMarker() async {
    final currentLocation = await GeolocationService.getCurrentPosition();
    final restaurantList =
        await GourmetApiService.getRestaurantMarkerListByLocation(
          // lati: currentLocation.latitude, lngi: currentLocation.longitude,
          lati: 34.7024, lngi: 135.4959,
          range: Provider.of<SearchConditionNotifier>(context, listen: false).selectedRangeDistance,
          page: 1
        );

    for(final restaurnat in restaurantList){
      _markersSet.add(
        Marker(
          markerId: MarkerId(restaurnat.id),
        )
      );
    }
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
        panel: const SearchConditionSettingPanel(), // パネルを上げた際に表示するウィジェット
        collapsed: const CollapsedPanel(), // パネルを下げた際に表示するウィジェット
        onPanelClosed: (){
          _addMarker();
        },
        body: FutureBuilder(
          future: GeolocationService.getCurrentPosition(),
          builder: (context, snapshot){
            if(snapshot.hasData){
             return GoogleMap(
               onMapCreated: _onMapCreated,
               markers: _markersSet,
               initialCameraPosition: const CameraPosition(
                 // target: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                 target: LatLng(34.7024, 135.4959),
                 zoom: 15.5
               ),
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
