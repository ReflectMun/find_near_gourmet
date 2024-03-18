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
  final List<RestaurantSimpleInfoModel> _shopList = []; // レストランのリストの情報を籠っておく変数
  // スクロールして一番下に当たると、次のページのデータを取得する機能の実装のため使用
  final ScrollController _scrollController = ScrollController();
  int _page = 0; // 現在何ページまで取得したのかを
  bool _isLastPage = false;

  int _currentRangeDistance = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMoreData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll(){
    if(!_isLastPage && _scrollController.position.pixels == _scrollController.position.maxScrollExtent){
      setState(() {
        _page += 1;
      });
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    final newData = await GourmetApiService.getRestaurantListByLocation(
      lngi: 139.767125, lati: 35.681236,
      range: _currentRangeDistance,
      page: _page
    );

    setState(() {
      if(newData.length < 20){
        _isLastPage = true;
      }

      if (newData.length == 1) {
        if(!_shopList.contains(newData[0])){
          _shopList.addAll(newData);
        }
      } else {
        _shopList.addAll(newData);
      }
    });
  }

  void _wipeScreenAndInitialize(){
    _shopList.clear();
    _page = 0;
    _isLastPage = false;
    _loadMoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchConditionNotifier>(
      builder: (context, searchOption, child){
        if (searchOption.selectedRangeDistance != _currentRangeDistance) {
          _currentRangeDistance = searchOption.selectedRangeDistance;
          _wipeScreenAndInitialize();
        }
        return ListView.separated(
            controller: _scrollController,
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
            itemCount: _shopList.length
        );
      },
    );
  }
}