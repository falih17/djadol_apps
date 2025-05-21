import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Flexible(
              child: Center(
            child: Icon(
              Icons.error_outline_rounded,
              size: 200,
              color: Colors.blueGrey,
            ),
          )),
          Text(
            'Something Problem',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Sorry,\nplease check your connection.',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Spacer()
        ],
      ),
    );
  }
}
