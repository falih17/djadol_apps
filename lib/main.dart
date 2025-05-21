import 'package:djadol_mobile/auth/login_page.dart';
import 'package:djadol_mobile/home.dart';
import 'package:flutter/material.dart';

import 'core/utils/api_service.dart';

void main() {
  ApiService().configureDio();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
