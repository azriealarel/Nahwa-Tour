import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTextFieldDatePicker extends StatefulWidget {
  final String labelText;
  final Icon prefixIcon;
  final Icon suffixIcon;
  final FocusNode? focusNode;
  final DateFormat? dateFormat;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final DateTime? initialDate;
  final Function(DateTime) onDateChanged;

  MyTextFieldDatePicker({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.suffixIcon,
    this.focusNode,
    this.dateFormat,
    this.lastDate,
    this.firstDate,
    this.initialDate,
    required this.onDateChanged,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(!initialDate!.isBefore(firstDate!),
            'initialDate must be on or after firstDate'),
        assert(!initialDate!.isAfter(lastDate!),
            'initialDate must be on or before lastDate'),
        assert(!firstDate!.isAfter(lastDate!),
            'lastDate must be on or after firstDate'),
        super(key: key);

  @override
  _MyTextFieldDatePicker createState() => _MyTextFieldDatePicker();
}


class _MyTextFieldDatePicker extends State<MyTextFieldDatePicker> {
  late TextEditingController _controllerDate;
  late DateFormat _dateFormat;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.dateFormat != null) {
      _dateFormat = widget.dateFormat!;
    } else {
      _dateFormat = DateFormat.MMMEd();
    }

    _selectedDate = widget.initialDate!;

    _controllerDate = TextEditingController();
    _controllerDate.text = _dateFormat.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: _controllerDate,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
      ),
      onTap: () => _selectDate(context),
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate!,
      lastDate: widget.lastDate!,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate.text = _dateFormat.format(_selectedDate);
      widget.onDateChanged(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode?.nextFocus();
    }
  }
}
