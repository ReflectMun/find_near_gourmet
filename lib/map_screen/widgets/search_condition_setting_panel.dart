import 'package:find_near_gurume/notifiers/search_condition_notifier.dart';
import 'package:find_near_gurume/search_gourmet/search_result_list_screen.dart';
import 'package:find_near_gurume/services/gourmet_api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'custom_radio_button.dart';

// 検索条件を定めることができるパネルウィジェット
class SearchConditionSettingPanel extends StatefulWidget {
  CameraPosition? position;

  SearchConditionSettingPanel({
    super.key,
    required this.position,
  });

  @override
  State<SearchConditionSettingPanel> createState() => _SearchConditionSettingPanelState();
}

class _SearchConditionSettingPanelState extends State<SearchConditionSettingPanel> {
  // 選択できる検索半径のリスト
  static const List<String> _ranges = ["300m", "500m", "1km", "2km", "3km"];

  // 選択した検索半径。最初は「1km」にする
  int _selectedRangeDistance = _ranges.indexOf("1km");
  // 選択したレストランのジャンル。最初は「全て」にする
  int _selectedGenre = 0;
  // 選択した価格帯。最初は「全て」にする
  int _selectedBudget = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          color: Color(0xFFFDFDFD),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Colors.grey
            )
          ]
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        children: [
          // スワイプができる要素であることを示す手元アイコン
          const Icon(Icons.dehaze_outlined),
          // スワイプができる要素であることを示す手元アイコン

          // 検索条件パネルのタイトル
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
          // 検索条件パネルのタイトル

          // 検索条件を定めることができるところ
          Expanded(
            // 将来にオプションの追加が容易にできるようするため、SingleChildScrollViewを選択
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
                    // 検索半径選択ボタンリスト領域
                    Column(
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
                        // 検索半径のタイトル

                        // 検索半径選択ボタンリスト
                        SizedBox(
                          height: 66,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                return CustomRadioButtonWidget(
                                  label: _ranges[index],
                                  // ボタンの番号と選択番号が一致する場合、選択したボタンにする
                                  // 逆の場合、選択していないボタンにする
                                  isSelected: index == _selectedRangeDistance,
                                  onChanged: (isNotSelected){
                                    setState(() {
                                      isNotSelected ?
                                      // すでに選択しておいたボタンの場合、何もしない
                                      _selectedRangeDistance = _selectedRangeDistance :
                                      // 選択していないボタンの場合、選択したボタンを変える
                                      _selectedRangeDistance = index;
                                    });
                                    // 選択したボタンの番号を渡す
                                    Provider
                                        .of<SearchConditionNotifier>(context, listen: false)
                                        .rangeDistance = _selectedRangeDistance;
                                  },
                                );
                              },
                              itemCount: _ranges.length
                          ),
                        ),
                        // 検索半径選択ボタンリスト

                      ],
                    ),
                    // 検索半径選択ボタンリスト領域

                    // 検索半径領域とジャンル領域間のスペース
                    const SizedBox(height: 20,),
                    // 検索半径領域とジャンル領域間のスペース

                    // ジャンル選択ボタンのリスト領域
                    Column(
                      children: [
                        // ジャンルのタイトル
                        const Center(
                          child: Text(
                            "ジャンル",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20
                            ),
                          ),
                        ),
                        // ジャンルのタイトル

                        // ジャンル選択ボタンのリスト
                        FutureBuilder(
                          future: GourmetApiService.getGenreList(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              return SizedBox(
                                height: 66,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, index) {
                                      return CustomRadioButtonWidget(
                                        label: snapshot.data![index].keys.first,
                                        isSelected: index == _selectedGenre,
                                        onChanged: (isNotSelected){
                                          setState(() {
                                            isNotSelected ?
                                            _selectedGenre = _selectedGenre :
                                            _selectedGenre = index;
                                          });
                                          Provider
                                              .of<SearchConditionNotifier>(context, listen: false)
                                              .genre = snapshot.data![_selectedGenre].values.first;
                                        },
                                      );
                                    },
                                    itemCount: snapshot.data!.length
                                ),
                              );
                            }
                            else if(snapshot.hasError){
                              return const Text("エラー発生");
                            }
                            else{
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                        // ジャンル選択ボタンのリスト

                      ],
                    ),
                    // ジャンル選択ボタンのリスト領域

                    // ジャンル領域と価格帯領域間のスペース
                    const SizedBox(height: 20,),
                    // ジャンル領域と価格帯領域間のスペース

                    // 価格帯選択ボタンのリスト領域
                    Column(
                      children: [
                        // 価格帯のタイトル
                        const Center(
                          child: Text(
                            "価格範囲",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20
                            ),
                          ),
                        ),
                        // 価格帯のタイトル

                        // 価格帯選択ボタンのリスト
                        FutureBuilder(
                          future: GourmetApiService.getBudgetList(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              return SizedBox(
                                height: 66,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, index) {
                                      return CustomRadioButtonWidget(
                                        label: snapshot.data![index].keys.first,
                                        isSelected: index == _selectedBudget,
                                        backgroundColorWhenSelected: Colors.yellow,
                                        textColorWhenSelected: Colors.black,
                                        onChanged: (isNotSelected){
                                          setState(() {
                                            isNotSelected ?
                                            _selectedBudget = _selectedBudget :
                                            _selectedBudget = index;
                                          });
                                          Provider
                                              .of<SearchConditionNotifier>(context, listen: false)
                                              .budget = snapshot.data![_selectedBudget].values.first;
                                        },
                                      );
                                    },
                                    itemCount: snapshot.data!.length
                                ),
                              );
                            }
                            else if(snapshot.hasError){
                              return const Text("エラー発生");
                            }
                            else{
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                        // 価格帯選択ボタンのリスト

                      ],
                    ),
                    // 価格帯選択ボタンのリスト領域

                  ],
                ),
              ),
            ),
          ),
          // 検索条件を定めることができるところ

          // リストへ移動するボタン
          GestureDetector(
            onTapUp: (details){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  // リストへ移動する際に地図の現在中心座標を渡す
                    SearchResultListScreen(
                      longitude: widget.position!.target.longitude,
                      latitude: widget.position!.target.latitude,
                    )
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
