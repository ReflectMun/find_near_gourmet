import 'package:find_near_gurume/search_gurume/search_condition_setting_panel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../services/geolocation_service.dart';
import 'collapsed_panel.dart';

class SearchGurumeScreen extends StatefulWidget {
  const SearchGurumeScreen({super.key});

  @override
  State<SearchGurumeScreen> createState() => _SearchGurumeScreenState();
}

class _SearchGurumeScreenState extends State<SearchGurumeScreen> {
  late final Future<Position?> _currentPosition = _initializeCurrentPosition(); // 변수를 선언할 때 초기화

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
        title: const Text("周りの食堂検索"),
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
        body: FutureBuilder(
          future: _currentPosition,
          builder: (bctx, snapshot){
            if(snapshot.hasData){
              return Column(
                children: [
                  const SizedBox(height: 20,),
                  Center(
                    child: Text(
                      "現在地の経度: ${snapshot.data!.longitude}\n現在地の緯度: ${snapshot.data!.latitude}"
                    )
                  ),
                ],
              );
            }
            else{
              return const Column(
                children: [
                  Center(
                    child: Text("位置情報に接近できません！")
                  ),
                ],
              );
            }
          },
        ), // パネルの後ろに見えるウィジェット
      ),
      // bottomNavigationBar: BottomAppBar(),
    );
  }
}
