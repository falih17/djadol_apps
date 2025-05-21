import 'package:flutter/material.dart';

class ZCard extends StatelessWidget {
  final String title;
  final Color? color;
  final Color? textColor;
  const ZCard({
    super.key,
    required this.title,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Controls the shadow depth of the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            15.0), // Defines the border radius of the card
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(title.isEmpty ? '@' : title[0].toUpperCase()),
        ),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
      ),
    );
  }
}
