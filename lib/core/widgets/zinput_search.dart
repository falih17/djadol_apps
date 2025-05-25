import 'package:flutter/material.dart';

class ZInputSearch extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const ZInputSearch({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      onSubmitted: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        suffixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        hintText: 'Search ',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
    );
  }
}
