import 'package:flutter/cupertino.dart';

class SearchConditionNotifier extends ChangeNotifier {
  int _selectedRangeDistance = 3;

  int get selectedRangeDistance => _selectedRangeDistance;

  set selectedRangeDistance(int distance){
    if(distance < 0 || distance > 4){
      throw Exception("正しくない値が伝わっている");
    }
    _selectedRangeDistance = distance + 1;
  }

  void notify(){
    notifyListeners();
  }
}