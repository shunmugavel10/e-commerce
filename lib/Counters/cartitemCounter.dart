import 'package:flutter/foundation.dart';
import 'package:shop_app/Config/config.dart';

class CartItemCounter extends ChangeNotifier
{
  int _counter = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1;
  int get count => _counter;

  Future<void> displayResult() async
  {

    await Future.delayed(const Duration(milliseconds: 100), (){
      notifyListeners();
    });
  }
}