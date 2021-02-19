import 'package:flutter/foundation.dart';

class prograssHud extends ChangeNotifier{

  bool isLoading=false;

  changeLoading(bool value){
    isLoading=value;
    notifyListeners();
  }
}