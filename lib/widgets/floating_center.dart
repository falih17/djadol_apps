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
      padding: const EdgeInsets.only(bottom: 45.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 40,
          width: 200, // Reduced height
          child: FloatingActionButton.extended(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: onPressed,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20, // Optionally reduce icon size
            ),
            label: const Text(
              'Tambah',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white), // Optionally reduce font size
            ),
          ),
        ),
      ),
    );
  }
}
