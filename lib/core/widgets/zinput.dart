import 'package:flutter/material.dart';

import 'zinput_style.dart';

String? requiredValidation(String? value) {
  if (value?.trim().isEmpty ?? true) {
    return 'Please input data';
  }
  return null;
}

String? emailValidation(String? value) {
  return value?.contains('@') ?? false ? null : 'Please enter a valid email.';
}

String? numberValidation(String? value) {
  if (value == null) {
    return null;
  } else if (int.tryParse(value) == null) {
    return 'Please enter number';
  }
  return null;
  // return value?.contains('@') ?? false ? null : 'Please enter a valid email.';
}

class ZInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final Function()? onTap;
  final bool required;
  final bool obscureText;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final double borderRadius;
  final int maxLines;
  final String? Function(String?)? validator;

  const ZInput({
    super.key,
    this.controller,
    this.label,
    this.hintText = 'Input Text Here',
    this.onTap,
    this.required = false,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius = 8.0,
    this.maxLines = 1,
    this.validator,
  });

  const ZInput.password({
    super.key,
    this.hintText,
    this.obscureText = true,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius = 8.0,
    this.controller,
    this.validator,
    this.label,
    this.onTap,
    this.maxLines = 1,
    this.required = false,
  });

  const ZInput.email({
    super.key,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius = 8.0,
    this.controller,
    this.validator = emailValidation,
    this.label,
    this.onTap,
    this.maxLines = 1,
    this.required = false,
  });

  const ZInput.number({
    super.key,
    this.hintText = '123',
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius = 8.0,
    this.controller,
    this.validator = numberValidation,
    this.label,
    this.onTap,
    this.maxLines = 1,
    this.required = false,
  });

  const ZInput.date({
    super.key,
    this.hintText = '123',
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius = 8.0,
    this.controller,
    this.validator = numberValidation,
    this.label,
    this.onTap,
    this.maxLines = 1,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[ZInputLabel(label: label, required: required)],
        ZInputContainer(
          // margin: const EdgeInsets.symmetric(vertical: 10),
          // width: double.infinity,
          // height: ScreenUtil().setHeight(50.0),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(borderRadius),
          //   boxShadow: const [
          //     BoxShadow(
          //       color: Color.fromRGBO(169, 176, 185, 0.42),
          //       spreadRadius: 0,
          //       blurRadius: 8,
          //       offset: Offset(0, 2), // changes position of shadow
          //     ),
          //   ],
          // ),
          child: TextFormField(
            onTap: onTap,
            validator: (required) ? requiredValidation : validator,
            controller: controller,
            obscureText: obscureText,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              prefixIconConstraints: const BoxConstraints(minWidth: 0.0),
              suffixIcon: suffixIcon,
              // fillColor: Colors.white,
              // filled: true,
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(169, 176, 185, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
