import 'package:flutter/material.dart';

import '../utils/constans.dart';

enum ButtonType { primary, secondary, outlinePrimary, outlineSecondary }

class ZButton extends StatelessWidget {
  final ButtonType buttonType;
  final VoidCallback? onPressed;
  final String text;

  const ZButton({
    super.key,
    this.buttonType = ButtonType.primary,
    this.onPressed,
    this.text = 'Press',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10),
        // height: ScreenUtil().setHeight(48.0),
        decoration: BoxDecoration(
          color: getButtonColor(buttonType),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(169, 176, 185, 0.42),
              spreadRadius: 0,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: getTextColor(buttonType)),
          ),
        ),
      ),
    );
  }
}

Color getButtonColor(ButtonType type) {
  switch (type) {
    case ButtonType.primary:
      return Constants.primaryColor;
    case ButtonType.secondary:
      return Constants.secondary;
    default:
      return Constants.primaryColor;
  }
}

Color getTextColor(ButtonType type) {
  switch (type) {
    case ButtonType.primary:
      return Colors.white;
    case ButtonType.secondary:
      return Colors.white;
    default:
      return Colors.white;
  }
}
