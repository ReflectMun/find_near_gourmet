import 'package:find_near_gurume/search_gourmet/widgets/restaurant_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/geolocation_service.dart';

class SearchResultListScreen extends StatefulWidget {
  const SearchResultListScreen({super.key});

  @override
  State<SearchResultListScreen> createState() => _SearchResultListScreenState();
}

class _SearchResultListScreenState extends State<SearchResultListScreen> {
  late final Future<Position?> _currentPosition = _initializeCurrentPosition(); // 現在地の位置情報取得

  @override
  void initState() {
    super.initState();
  }

  static Future<Position?> _initializeCurrentPosition() async {
    try {
      final position = await GeolocationService.getCurrentPosition();
      return position;
    } catch (e) {
      print("에러: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("現在地周りのレストラン"),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _currentPosition,
              builder: (bctx, snapshot){
                if(snapshot.hasData){
                  return RestaurantListViewWidget(
                    longitude: snapshot.data!.longitude,
                    latitude: snapshot.data!.latitude,
                  );
                }
                else if(snapshot.hasError){
                  return const Column(
                    children: [
                      Center(
                          child: Text("位置情報に接近できません！")
                      ),
                    ],
                  );
                }
                else{
                  return const CircularProgressIndicator();
                }

              },
            ),
          ),
        ],
      ), // パネルの後ろに見えるウィジェット,
    );
  }
}
