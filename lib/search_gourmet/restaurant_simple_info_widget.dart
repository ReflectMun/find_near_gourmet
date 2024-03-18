import 'package:find_near_gurume/restaurant_information/RestaurantDetailScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        // お店をタッチすると詳細情報へ移る
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (bctx) =>
             RestaurantDetailScreen(id: id)
          )
        );
      },
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15
        ),
        child: Column(
          children: [
            // レストランの店名
            Text(
              restaurantName,
              style: const TextStyle(
                fontSize: 20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            // レストランの店名おわり

            // スペース
            SizedBox(height: 10, width: MediaQuery.of(context).size.width,),
            // スペースおわり

            // サムネイルと各種情報
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // サムネイル
                SizedBox(
                  height: 80,
                  width: 120,
                  child: Image.network(
                    thumbnailURI,
                    fit: BoxFit.fill,
                  ),
                ),
                // サムネイルおわり

                // スペイす
                const SizedBox(width: 12,),
                // スペイす

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

                      const SizedBox(height: 7,),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // お店のジャンル
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              genre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                          // お店のジャンル
                  
                          // 予算
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              budget,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                          // 予算
                        ],
                      ),
                    ],
                  ),
                )
                // 各種情報
              ],
            ),
            // サムネイルと各種情報

            // スペース
            const SizedBox(height: 10,),
            // スペースおわり

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