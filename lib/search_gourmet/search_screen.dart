import 'package:find_near_gurume/search_gourmet/restaurant_list_view_widget.dart';
import 'package:find_near_gurume/search_gourmet/search_condition_setting_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../services/geolocation_service.dart';
import 'collapsed_panel.dart';

class SearchGourmetScreen extends StatefulWidget {
  const SearchGourmetScreen({super.key});

  @override
  State<SearchGourmetScreen> createState() => _SearchGourmetScreenState();
}

class _SearchGourmetScreenState extends State<SearchGourmetScreen> {
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
            const SizedBox(height: 230,)
          ],
        ), // パネルの後ろに見えるウィジェット
      ),
      // bottomNavigationBar: BottomAppBar(),
    );
  }
}
