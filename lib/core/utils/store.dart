import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class Store {
  static final Store _instance = Store._internal();
  factory Store() => _instance;
  Store._internal();

  String tokenKey = 'token';
  String? _token;
  String? get token => _token;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(tokenKey);
    if (_token != null) {
      ApiService().setToken(_token!);
    }
  }

  Future<void> setToken(String v) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, v);
    _token = v;
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
    _token = null;
  }
}
