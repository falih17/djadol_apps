import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class Store {
  static final Store _instance = Store._internal();
  factory Store() => _instance;
  Store._internal();

  String? _token;
  String? _userId;
  String? _username;

  String? get token => _token;
  String? get userId => _userId;
  String? get username => _username;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userId = prefs.getString('userid');
    _username = prefs.getString('username');
    if (_token != null) {
      ApiService().setToken(_token!);
    }
  }

  Future<void> setUsername(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', value);
    _username = value;
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> clearUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    _username = null;
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
