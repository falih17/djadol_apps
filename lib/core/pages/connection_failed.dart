import '../widgets/zui.dart';
import 'package:flutter/material.dart';

class ConnectionFailed extends StatelessWidget {
  final VoidCallback? onPressed;
  const ConnectionFailed({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Flexible(
              child: Center(
            child: Icon(
              Icons.error_outline_rounded,
              size: 200,
              color: Colors.blueGrey,
            ),
          )),
          const Text(
            'Connection Problem',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Your connection is error,\nplease check your connection.',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          ZButton(
            text: 'Retry',
            onPressed: onPressed,
          ),
          const Spacer()
        ],
      ),
    );
  }
}
