import 'package:flutter/material.dart';

import 'zinput_style.dart';

class ZInputSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool)? onChanged;
  const ZInputSwitch(
      {super.key, required this.label, required this.value, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.only(top: 10),
      title: Text(
        label,
        style: inputLabelStyle,
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
