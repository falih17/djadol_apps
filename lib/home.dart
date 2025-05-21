import 'package:djadol_mobile/auth/login_page.dart';
import 'package:djadol_mobile/core/widgets/zcard.dart';
import 'package:flutter/material.dart';
import 'agen/retail/retail_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: ZCard(title: 'Login'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            ),
          ),
          InkWell(
            child: ZCard(title: 'Retail'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RetailListPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
