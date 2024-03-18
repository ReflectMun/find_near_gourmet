import 'package:find_near_gurume/notifiers/search_condition_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_distance_radio_button.dart';

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
          SingleChildScrollView(
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
          // 検索条件リスト、おわり
        ],
      ),
    );
  }
}
