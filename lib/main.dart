import 'package:djadol_mobile/auth/login_page.dart';
import 'package:djadol_mobile/core/utils/store.dart';
import 'package:flutter/material.dart';

import 'core/utils/api_service.dart';

void main() {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();
  ApiService().configureDio();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<String?> checkToken() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await Store().init();
    return Store().token;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      // home: FutureBuilder(
      //     future: checkToken(),
      //     builder: (BuildContext context, AsyncSnapshot snapshot) {
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         if (snapshot.hasError) {
      //           return Text(snapshot.error.toString());
      //         } else if (snapshot.hasData) {
      //           return HomePage();
      //         } else {
      //           return LoginPage();
      //         }
      //       }
      //       return SplashPage();
      //     }),
    );
  }
}
