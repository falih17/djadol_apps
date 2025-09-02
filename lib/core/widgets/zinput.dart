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

class ZInput extends StatefulWidget {
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
  final bool isPassword;

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
    this.isPassword = false,
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
    this.isPassword = true,
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
    this.isPassword = false,
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
    this.isPassword = false,
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
    this.isPassword = false,
  });

  @override
  State<ZInput> createState() => _ZInputState();
}

class _ZInputState extends State<ZInput> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          ZInputLabel(label: widget.label, required: widget.required)
        ],
        ZInputContainer(
          child: TextFormField(
            onTap: widget.onTap,
            validator: (widget.required) ? requiredValidation : widget.validator,
            controller: widget.controller,
            obscureText: _obscureText,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              prefixIconConstraints: const BoxConstraints(minWidth: 0.0),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffixIcon,
              border: InputBorder.none,
              hintText: widget.hintText,
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
