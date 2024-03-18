import 'package:find_near_gurume/services/gourmet_api_service.dart';
import 'package:flutter/material.dart';

// レストランの詳細情報を表示する画面
class RestaurantDetailScreen extends StatelessWidget {
  final String id; // レストランの詳細情報を取得するのに使うID値

  const RestaurantDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: GourmetApiService.getRestaurantInfoById(id: id),
            builder: (bctx, snapshot){
              if(snapshot.hasData){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        snapshot.data!.photo,
                        fit: BoxFit.fill,
                      ),
                    ),

                    // レストランの名
                    Text(snapshot.data!.restaurantName),
                    // レストランの名

                    Text(snapshot.data!.address),
                    Text(snapshot.data!.open),

                  ],
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
          // レストラン情報おわり

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
                  color: Colors.white, // 흰색 배경 설정
                  shape: BoxShape.circle, // 동그란 모양 설정
                ),
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 21,
                  right: 12,
                  bottom: 12
                ), // 안쪽 여백 설정
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black, // 아이콘 색상 설정
                ),
              ),
            ),
          ),
          // 戻りボタンおわり
        ],
      ),
    );
  }
}
