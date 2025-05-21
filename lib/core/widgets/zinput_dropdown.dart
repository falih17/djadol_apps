import 'zinput_style.dart';
import 'package:flutter/material.dart';

import 'zinput.dart';

class ZInputDropdown extends StatelessWidget {
  final String? label;
  final List<String> options;
  final String dropdownValue;
  final ValueChanged<String> onChanged;
  final bool required;
  final String? Function(String?)? validator;

  const ZInputDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.dropdownValue,
    required this.onChanged,
    this.required = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          if (label != null) ...[ZInputLabel(label: label, required: required)],
        ],
        ZInputContainer(
          child: DropdownButtonFormField(
            isExpanded: true,
            validator: (required) ? requiredValidation : validator,
            value: dropdownValue.isEmpty ? null : dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down_outlined),
            elevation: 16,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            // underline: const SizedBox(),
            items: options.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              onChanged(newValue!);
            },
          ),
        ),
      ],
    );
  }
}
