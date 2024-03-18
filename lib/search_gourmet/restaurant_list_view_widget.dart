import 'package:find_near_gurume/notifiers/search_condition_notifier.dart';
import 'package:find_near_gurume/search_gourmet/model/restaurant_simple_info.dart';
import 'package:find_near_gurume/search_gourmet/restaurant_simple_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/gourmet_api_service.dart';

class RestaurantListViewWidget extends StatefulWidget {
  final double longitude;
  final double latitude;

  const RestaurantListViewWidget({
    super.key,
    required this.longitude,
    required this.latitude,
  });

  @override
  State<RestaurantListViewWidget> createState() => _RestaurantListViewWidgetState();
}

// レストランのリストを画面に表示するリストウィジェット
class _RestaurantListViewWidgetState extends State<RestaurantListViewWidget> {
  final List<RestaurantSimpleInfoModel> _shopList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchConditionNotifier>(
      builder: (context, searchOption, child){
        return FutureBuilder(
          future: GourmetApiService.getRestaurantListByLocation(
              lngi: 139.767125, lati: 35.681236,
              range: searchOption.selectedRangeDistance
          ),
          builder: (context, snapshot){
            if(snapshot.hasData){
              // 問題なく通信に成功すると画面にレストランのリストを表示
              if (snapshot.data!.isNotEmpty) {
                _shopList.addAll(snapshot.data!);
                return ListView.separated(
                    itemBuilder: (ctx, index){
                      return RestaurantSimpleInfoWidget(
                        id: _shopList[index].id,//
                        thumbnailURI: _shopList[index].thumbnailURI,
                        restaurantName: _shopList[index].restaurantName,
                        accessRoute: _shopList[index].accessRoute,
                        serviceArea: _shopList[index].serviceArea,
                        genre: _shopList[index].genre,
                        budget: _shopList[index].budget,
                      );
                    },
                    separatorBuilder: (bc, i) =>
                        Divider(
                          height: 2,
                          color: Colors.grey.withOpacity(0.35),
                        ),
                    itemCount: snapshot.data!.length
                );
              } else {
                return const Text("結果がありません");
              }
            }
            else if(snapshot.hasError){
              return const Text("エラーが発生しました!!");
            }
            else{
              return const CircularProgressIndicator();
            }
          }
        );
      },
    );
  }
}