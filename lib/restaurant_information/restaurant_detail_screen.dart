import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_near_gurume/services/gourmet_api_service.dart';
import 'package:flutter/material.dart';

// レストランの詳細情報を表示する画面
class RestaurantDetailScreen extends StatelessWidget {
  final String id; // レストランの詳細情報を取得するのに使うID値

  const RestaurantDetailScreen({super.key, required this.id});

  // 文字列で一番後ろのパタン一つを改行文字に変える
  String replaceLast(String str, String pattern){
    try {
      String newString = "${str.substring(0, str.lastIndexOf(pattern))}\n${str.substring(str.lastIndexOf(pattern) + 1)}";
      return newString;
    } catch (e) {
      // 一行の文字列であると改行しない
      return str;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBarを使わないながら戻りボタンを付けるため、Stackを使用
      body: Stack(
        children: [
          // レストランの詳細情報全体
          FutureBuilder(
            future: GourmetApiService.getRestaurantInfoById(id: id),
            builder: (bctx, snapshot){
              if(snapshot.hasData){
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 最上段に表示する代表イメージ
                      SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          snapshot.data!.photo,
                          fit: BoxFit.fill,
                        ),
                      ),
                      // 最上段に表示する代表イメージ

                      // レストランの詳細情報一覧
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // レストランの名
                            Column(
                              children: [
                                // 店名
                                AutoSizeText(
                                  replaceLast(snapshot.data!.restaurantName.replaceFirst(" ", "\n"), " "),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 28,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  stepGranularity: 10,
                                  minFontSize: 20,
                                ),
                                // 店名
                        
                                // かな名
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    snapshot.data!.kanaName.replaceAll("　", " "),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                                // かな名
                              ],
                            ),
                            // レストランの名

                            // 店名と詳細情報一覧間のスペース
                            const SizedBox(height: 20,),
                            // 店名と詳細情報一覧間のスペース

                            // 詳細情報一覧
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // レストランの住所 ・ アクセス領域
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.withOpacity(0.125),
                                    borderRadius: const BorderRadius.all(Radius.circular(25))
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 住所
                                      const Text(
                                        "住所",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          snapshot.data!.address,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18
                                          ),
                                        ),
                                      ),
                                      // 住所

                                      // アクセス
                                      const Text(
                                        "アクセス",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20
                                        ),
                                      ),

                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          snapshot.data!.accessRoute,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18
                                          ),
                                        ),
                                      ),
                                      // アクセス
                                    ],
                                  ),
                                ),
                                // レストランの住所 ・ アクセス領域

                                // 住所アクセス領域と営業時間領域間のスペース
                                const SizedBox(height: 20,),
                                // 住所アクセス領域と営業時間領域間のスペース

                                // 営業時間と休み情報の領域
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFEEEE),
                                    borderRadius: BorderRadius.all(Radius.circular(25))
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 営業時間
                                      const Text(
                                        "営業時間",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          snapshot.data!.open,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18
                                          ),
                                        ),
                                      ),
                                      // 営業時間

                                      // 休み情報
                                      const Text(
                                        "休み",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20
                                        ),
                                      ),
                                      Text(
                                        snapshot.data!.close,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18
                                        ),
                                      ),
                                      // 休み情報

                                    ],
                                  ),
                                ),
                                // 営業時間と休み情報の領域

                              ],
                            ),
                            // 詳細情報一覧

                          ],
                        ),
                      ),
                      // レストランの詳細情報一覧

                    ],
                  ),
                );
              }
              else if(snapshot.hasError){
                return const Text("エラーが発生しました");
              }
              else{
                return const CircularProgressIndicator();
              }
            },
          ),
          // レストランの詳細情報全体

          // 戻りボタン
          Positioned(
            top: 70,
            left: 30,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 21,
                  right: 12,
                  bottom: 12
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 戻りボタン

        ],
      ),
    );
  }
}
