import 'package:flutter/material.dart';

class ZIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  final Color? color;
  const ZIconButton({
    super.key,
    this.onPressed,
    this.icon = const Icon(Icons.add),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(10),
          backgroundColor: color ?? Theme.of(context).colorScheme.primary,
          iconColor: Colors.white,
          iconSize: 20),
      child: icon,
    );
  }
}
