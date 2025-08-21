import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class Store {
  static final Store _instance = Store._internal();
  factory Store() => _instance;
  Store._internal();

  String? _token;
  String? _userId;

  String? get token => _token;
  String? get userId => _userId;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userId = prefs.getString('userid');
    if (_token != null) {
      ApiService().setToken(_token!);
    }
  }

  Future<void> setToken(String v, String c) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', v);
    _token = v;
    prefs.setString('userid', c);
    _userId = c;
    ApiService().setToken(v);
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _token = null;
    _userId = null;
  }
}
