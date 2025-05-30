import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Flexible(
              child: Center(
            child: Icon(
              Icons.menu_book,
              size: 200,
              color: Colors.blueGrey,
            ),
          )),
          Text(
            'Empty',
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
            'No data avaiable',
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
