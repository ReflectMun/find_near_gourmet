import 'package:find_near_gurume/search_gourmet/widgets/restaurant_list_view_widget.dart';
import 'package:flutter/material.dart';

// 地図中心座標の周りのレストランのリストを表示する画面
class SearchResultListScreen extends StatelessWidget {
  final double longitude;
  final double latitude;

  const SearchResultListScreen({
    super.key,
    required this.longitude,
    required this.latitude,
  });

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
            // 実際にリストを画面上に表示するウィジェット
            child: RestaurantListViewWidget(
              longitude: longitude,
              latitude: latitude,
            ),
          ),
        ],
      ), // パネルの後ろに見えるウィジェット,
    );
  }
}
