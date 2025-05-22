import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/login.png'),
            const SizedBox(height: 20),
            const Text(
              'Djadol',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Aplikasi Absen dan Jurnal',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
