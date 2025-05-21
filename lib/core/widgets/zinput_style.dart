import 'package:flutter/material.dart';

TextStyle inputLabelStyle = const TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Colors.black,
);

class ZInputLabel extends StatelessWidget {
  const ZInputLabel({
    super.key,
    required this.label,
    required this.required,
  });

  final String? label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            label!,
            style: inputLabelStyle,
          ),
        ),
        if (required)
          const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}

class ZInputContainer extends StatelessWidget {
  final Widget child;

  const ZInputContainer({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      // height: ScreenUtil().setHeight(50.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(169, 176, 185, 0.42),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
