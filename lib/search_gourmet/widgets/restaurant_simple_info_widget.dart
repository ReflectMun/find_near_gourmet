import 'package:find_near_gurume/restaurant_information/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

// 各レストランの簡単な情報を表示するウィジェット
class RestaurantSimpleInfoWidget extends StatelessWidget {
  final String id; // 詳細情報画面でレストランの詳しい情報を取得するに必要
  final String thumbnailURI; // サムネイルのイメージ先の情報
  final String restaurantName; // レストランの名
  final String accessRoute; // アクセス
  final String serviceArea; // 所在地
  final String genre; // お店ジャンル
  final String budget; //　予算範囲

  const RestaurantSimpleInfoWidget({
    super.key,
    required this.thumbnailURI,
    required this.restaurantName,
    required this.accessRoute,
    required this.serviceArea,
    required this.id,
    required this.genre,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        // レストランの項目をタッチすると詳細画面へ移動する
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (bctx) =>
            // 詳細画面で情報の表示ができるよう、レストランのIDを伝える
             RestaurantDetailScreen(id: id)
          )
        );
      },
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15
        ),
        child: Column(
          children: [
            // レストランの名
            Text(
              restaurantName,
              style: const TextStyle(
                fontSize: 20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            // レストランの名おわり

            // レストランの名とサムネイル、各種情報領域間のスペース
            SizedBox(height: 10, width: MediaQuery.of(context).size.width,),
            // レストランの名とサムネイル、各種情報領域間のスペース

            // サムネイルと各種情報領域
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // サムネール
                SizedBox(
                  height: 80,
                  width: 120,
                  child: Image.network(
                    thumbnailURI,
                    fit: BoxFit.fill,
                  ),
                ),
                // サムネール

                // サムネールと各種情報間のスペース
                const SizedBox(width: 10,),
                // サムネールと各種情報間のスペース

                // 各種情報
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 所在地
                      Text(
                        serviceArea,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      // 所在地

                      // 所在地とジャンル ・ 価格帯情報間のスペース
                      const SizedBox(height: 5,),
                      // 所在地とジャンル ・ 価格帯情報間のスペース

                      // ジャンル ・ 価格帯情報
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // お店のジャンル
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 7.5),
                            child: Text(
                              genre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12
                              ),
                            ),
                          ),
                          // お店のジャンル

                          // 価格帯
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                            child: Text(
                              budget,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          // 価格帯

                        ],
                      ),
                      // ジャンル ・ 価格帯情報

                    ],
                  ),
                ),
                // 各種情報
              ],
            ),
            // サムネイルと各種情報領域

            // サムネイル、各種情報領域とアクセス情報間のスペース
            const SizedBox(height: 10,),
            // サムネイル、各種情報領域とアクセス情報間のスペース

            // アクセス情報
            Container(
              // 左側整列のため、Containerウィジェットで一度包んでおく
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // アクセスルートを表示するテキストウィジェット
                  Text(accessRoute),
                  // アクセスルートを表示するテキストウィジェットおわり
                ],
              ),
            ),
            // アクセス情報

          ],
        ),
      ),
    );
  }
}