import 'package:find_near_gurume/notifiers/search_condition_notifier.dart';
import 'package:find_near_gurume/search_gourmet/search_result_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../search_gourmet/widgets/custom_distance_radio_button.dart';

class SearchConditionSettingPanel extends StatefulWidget {
  const SearchConditionSettingPanel({
    super.key,
  });

  @override
  State<SearchConditionSettingPanel> createState() => _SearchConditionSettingPanelState();
}

class _SearchConditionSettingPanelState extends State<SearchConditionSettingPanel> {
  static const List<String> _ranges = ["300m", "500m", "1km", "2km", "3km"];
  int _selectedRangeDistance = _ranges.indexOf("1km"); // 最初の距離は1kmに設定

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(45)),
          color: Color(0xFFFDFDFD),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Colors.grey
            )
          ]
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // すワイプができる要素であることを示す手元アイコン
          const Icon(Icons.dehaze_outlined),

          // 検索条件タイトルを表示するコード
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 20),
            child: const Center(
              child: Text(
                "検索条件",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 32
                ),
              ),
            ),
          ),
          // 検索条件タイトルを表示するコード、おわり

          // 検索条件リスト
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  )
                ),
                child: Column(
                  children: [
                    // 検索半径のタイトル
                    const Center(
                      child: Text(
                        "検索半径",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20
                        ),
                      ),
                    ),
                    // 検索半径のタイトル、おわり

                    // 検索半径の選択ボタンリスト
                    SizedBox(
                      height: 66,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return CustomDistanceRadioButtonWidget(
                            label: _ranges[index],
                            isSelected: index == _selectedRangeDistance,
                            onChanged: (isNotSelected){
                              setState(() {
                                isNotSelected ?
                                  _selectedRangeDistance = _selectedRangeDistance :
                                  _selectedRangeDistance = index;
                              });
                              Provider
                                .of<SearchConditionNotifier>(context, listen: false)
                                .selectedRangeDistance = _selectedRangeDistance;
                            },
                          );
                        },
                        itemCount: _ranges.length
                      ),
                    ),
                    // 検索半径の選択ボタンリスト、おわり

                  ],
                ),
              ),
            ),
          ),
          // 検索条件リスト、おわり

          // リストへ移動するボタン
          GestureDetector(
            onTapUp: (details){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                    const SearchResultListScreen()
                )
              );
            },
            child: Container(
              height: 60,
              width: 220,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              child: const Center(
                child: Text(
                  "リストを開ける",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // リストへ移動するボタン

          // ボタンを浮かべる下のスペース
          const SizedBox(height: 15,),
          // ボタンを浮かべる下のスペース
        ],
      ),
    );
  }
}
