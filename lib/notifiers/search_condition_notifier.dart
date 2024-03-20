import 'package:flutter/cupertino.dart';

class SearchConditionNotifier extends ChangeNotifier {
  // 選択した検索半径
  int _selectedRangeDistance = 3;
  int get rangeDistance => _selectedRangeDistance;
  set rangeDistance(int distance){
    if(distance < 0 || distance > 4){
      throw Exception("正しくない値が伝わっている");
    }
    _selectedRangeDistance = distance + 1;
    notifyListeners();
  }

  // 選択したレストランのジャンル
  String? _selectedGenre;
  String? get genre => _selectedGenre;
  set genre(String? genre){
    _selectedGenre = genre;
    notifyListeners();
  }

  // 選択した価格範囲
  String? _selectedBudget;
  String? get budget => _selectedBudget;
  set budget(String? budget){
    _selectedBudget = budget;
    notifyListeners();
  }
}