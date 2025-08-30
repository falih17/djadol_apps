import 'package:flutter/material.dart';

class FloatingButtonCenter extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingButtonCenter({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // More rounded
          ),
          onPressed: onPressed,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: const Text('Tambah',
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
