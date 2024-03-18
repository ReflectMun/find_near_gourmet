import 'package:find_near_gurume/search_gourmet/model/restaurant_simple_info.dart';
import 'package:find_near_gurume/search_gourmet/restaurant_simple_info_widget.dart';
import 'package:flutter/material.dart';

import '../services/gourmet_api_service.dart';

class RestaurantListViewWidget extends StatelessWidget {
  late final Future<List<RestaurantSimpleInfoModel>> _shopList = GourmetApiService.getRestaurantListByLocation(lngi: 139.767125, lati: 35.681236);
  final double longitude;
  final double latitude;

  RestaurantListViewWidget({
    super.key,
    required this.longitude,
    required this.latitude,
  });

  // レストランのリストを画面に表示するリストウィジェット
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _shopList,
        builder: (bctx, snapshot){
          if(snapshot.hasData){
            // 問題なく通信に成功すると画面にレストランのリストを表示
            return ListView.separated(
                itemBuilder: (ctx, index){
                  return RestaurantSimpleInfoWidget(
                    id: snapshot.data![index].id,
                    thumbnailURI: snapshot.data![index].thumbnailURI,
                    restaurantName: snapshot.data![index].restaurantName,
                    accessRoute: snapshot.data![index].accessRoute,
                    serviceArea: snapshot.data![index].serviceArea,
                    genre: snapshot.data![index].genre,
                    budget: snapshot.data![index].budget,
                  );
                },
                separatorBuilder: (bc, i) =>
                  Divider(
                    height: 2,
                    color: Colors.grey.withOpacity(0.35),
                  ),
                itemCount: snapshot.data!.length
            );
          }
          else if(snapshot.hasError){
            return const Text("エラーが発生しました!!");
          }
          else{
            return const CircularProgressIndicator();
          }
        }
    );
  }
}