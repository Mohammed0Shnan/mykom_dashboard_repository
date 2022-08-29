
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  Future<void> setCurrentStore(String store) async {
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    await _sharedPreferences.setString('storeID', store);
  }
  Future<String?> getCurrentStore() async {
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
     return  _sharedPreferences.getString('storeID');
  }
  Future<void> setCurrentSubArea(String store) async {
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    await _sharedPreferences.setString('sub_area', store);
  }
  Future<String?> getCurrentSubArea() async {
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    return  _sharedPreferences.getString('sub_area');
  }


  Future<void> setMinimumPurchaseStore(double minimum_purchase) async {
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    await _sharedPreferences.setDouble('minimum_purchase', minimum_purchase);
  }
  Future<double?> getMinimumPurchaseStore() async {
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    return  _sharedPreferences.getDouble('minimum_purchase');
  }


  Future<void> setVipStore(bool vip) async {
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    await _sharedPreferences.setBool('vip_store', vip);
  }
  Future<bool> getVipStore() async {
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    var res =_sharedPreferences.getBool('vip_store');
    if(res == null)
    return false;
    else
    return  res;

  }



}

//  Future<String> getCurrentUsername() async {
//    SharedPreferences _sharedPreferences =
//        await SharedPreferences.getInstance();
//    return _sharedPreferences.getString('username');
//  }

//  Future<void> setUserUID(String uid) async {
//    SharedPreferences _sharedPreferences =
//        await SharedPreferences.getInstance();
//    await _sharedPreferences.setString('uid', uid);
//  }

//  Future<String> getUserUID() async {
//    SharedPreferences _sharedPreferences =
//        await SharedPreferences.getInstance();
//    return _sharedPreferences.getString('uid');
//  }
//   Future<void> setToken(String uid) async {
//    SharedPreferences _sharedPreferences =
//        await SharedPreferences.getInstance();
//    await _sharedPreferences.setString('token', uid);
//  }

//  Future<String> getToken() async {
//    SharedPreferences _sharedPreferences =
//        await SharedPreferences.getInstance();
//    return _sharedPreferences.getString('token');
//  }

//  Future<void> setLanguage(String lang) async {
//    SharedPreferences _sharedPreferences =
//        await SharedPreferences.getInstance();
//    await _sharedPreferences.setString('lang', lang);
//  }

//  Future<String> getLanguage() async {
//    SharedPreferences _sharedPreferences =
//        await SharedPreferences.getInstance();
//    return _sharedPreferences.getString('lang');
//  }

//  Future<bool> clearData() async {
//    SharedPreferences _sharedPreferences =
//        await SharedPreferences.getInstance();
//    return _sharedPreferences.clear();
//  }
// }
