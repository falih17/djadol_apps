import 'zui.dart';
import 'package:flutter/cupertino.dart';

class ZInputDate extends StatefulWidget {
  final String label;
  final DateTime? value;
  final TextEditingController controller;
  final bool required;

  final Function(DateTime)? onChanged;
  const ZInputDate({
    super.key,
    required this.label,
    this.value,
    required this.controller,
    this.onChanged,
    this.required = false,
  });

  @override
  State<ZInputDate> createState() => _ZInputDateState();
}

class _ZInputDateState extends State<ZInputDate> {
  // DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return ZInput(
      label: widget.label,
      controller: widget.controller,
      required: widget.required,
      onTap: () => showIOSDatePicker(context),
    );
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(context: context, initialDate: widget.value , firstDate: DateTime(1980, 8), lastDate: DateTime(2101));
  //   if (picked != null && picked != widget.value) {
  //     setState(() {
  //       widget.value = picked;
  //     });
  //   }
  // }

  void showIOSDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 290,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Flexible(
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: widget.value,
                        onDateTimeChanged: (val) {
                          if (widget.onChanged != null) {
                            widget.onChanged!(val);
                          }
                          widget.controller.text =
                              '${val.year}-${val.month.toString().padLeft(2, '0')}-${val.day.toString().padLeft(2, '0')}';
                        }),
                  ),
                ],
              ),
            ));
  }
}
