import 'package:flutter/material.dart';

import 'zinput_style.dart';

class ZInputRadio extends StatelessWidget {
  final String? label;
  final List<String> options;
  final String dropdownValue;
  final ValueChanged<String> onChanged;
  const ZInputRadio({
    super.key,
    required this.options,
    this.label,
    required this.dropdownValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                label!,
                style: inputLabelStyle,
              ),
            )
          ],
          Wrap(
            // alignment: WrapAlignment.spaceBetween,
            children: [
              // for (int i = 0; i < options.length; i++) Text(options[i])
              for (int i = 0; i < options.length; i++)
                ButtonOption(
                  text: options[i],
                  selected: dropdownValue == options[i],
                  onPressed: () => onChanged(options[i]),
                )
            ],
          ),
        ],
      ),
    );
  }
}

class ButtonOption extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool selected;

  const ButtonOption({
    super.key,
    this.onPressed,
    this.text = 'Press',
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // width: double.infinity,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(10),
        height: 50,
        width: 170,
        decoration: BoxDecoration(
          color: (selected) ? Colors.orange : Colors.grey,
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
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
