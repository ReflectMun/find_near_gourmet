import 'package:find_near_gurume/notifiers/search_condition_notifier.dart';
import 'package:find_near_gurume/search_gourmet/model/restaurant_simple_info.dart';
import 'package:find_near_gurume/search_gourmet/widgets/restaurant_simple_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/gourmet_api_service.dart';

// 実際にレストランのリストを画面に描くウィジェット
class RestaurantListViewWidget extends StatefulWidget {
  // 渡された地図の中心座標
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

class _RestaurantListViewWidgetState extends State<RestaurantListViewWidget> {
  final List<RestaurantSimpleInfoModel> _shopList = []; // レストランのリストの情報を籠っておく変数
  // スクロールして一番下に当たると、次のページのデータを取得する機能の実装のため使用
  final ScrollController _scrollController = ScrollController();
  int _page = 0; // 現在何ページまで取得したのかを
  bool _isLastPage = false; // 最後のページまで取得したかどうかの情報を記録する変数

  // スクロール動作を感知するコントローラの初期設定と最初ページの情報を取得する
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // スクロールコントローラに一番下までスクロールすると行う動作を渡す
    _scrollController.addListener(_onScroll);
    // 最初ページのデータを取得し、画面に表示する
    _loadMoreData().then((value){});
  }

  // このウィジェットが閉じたらスクロールコントローラーを除去
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 一番下までスクロールしたら行われる動作
  void _onScroll(){
    // 最後のページではないつつ、一番下までスクロールしたら
    if(!_isLastPage && _scrollController.position.pixels == _scrollController.position.maxScrollExtent){
      setState(() {
        // 次のページを取得するため、ページの番号を上げる
        _page += 1;
      });
      // 次のページのデータを取得し、続けてレストラン情報のウィジェットを画面に追加する
      _loadMoreData();
    }
  }

  // レストランのデータを取得し、画面に取得したレストラン情報のウィジェットを画面に追加する
  Future<void> _loadMoreData() async {
    // APIに次のページのデータを求める
    final newData = await GourmetApiService.getRestaurantListByLocation(
      lngi: widget.longitude, lati: widget.latitude,
      range: Provider.of<SearchConditionNotifier>(context, listen: false).rangeDistance,
      page: _page,
      genre: Provider.of<SearchConditionNotifier>(context, listen: false).genre,
      budget: Provider.of<SearchConditionNotifier>(context, listen: false).budget,
    );

    // データを追加してsetStateを使ってデータの変更があったことを告げたら自動的に追加したデータが続けて表示される
    setState(() {
      // ページ毎に20個のデータを取るので、取得したデータの数が20個に足りなければ最後のページである
      if(newData.length < 20){
        _isLastPage = true;
      }

      // 最後のデータ番号が1201ながら「1201番から20個のデータをお送りください」と求めたら
      // 1個のデータを取得できるので2種類の場合ができる
      if (newData.length == 1) {
        // 中腹データを含めないようにする
        if(!_shopList.contains(newData[0])){
          _shopList.addAll(newData);
        }
      // それ以外の場合は取得したデータをレストランデータリストへ追加する
      } else {
        _shopList.addAll(newData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        controller: _scrollController, // スクロール操作から実行するアクションを定義
        itemBuilder: (ctx, index){
          // 各レストランの情報を含めているウィジェットを表示
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
        // 区分線を表示
        separatorBuilder: (bc, i) =>
            Divider(
              height: 2,
              color: Colors.grey.withOpacity(0.35),
            ),
        itemCount: _shopList.length
    );
  }
}