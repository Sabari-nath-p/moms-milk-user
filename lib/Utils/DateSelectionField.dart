import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A text-field style date picker field with min/max date support.
class DatePickerField extends StatefulWidget {
  final String title;
  final String? hintText;
  final IconData? icon;
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerField({
    super.key,
    required this.title,
    required this.onDateSelected,
    this.initialDate,
    this.hintText,
    this.icon,
    this.minDate,
    this.maxDate,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  final DateFormat _dateFormat = DateFormat('MMMM d, yyyy');
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _updateText(widget.initialDate);
  }

  @override
  void didUpdateWidget(covariant DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialDate != oldWidget.initialDate) {
      _updateText(widget.initialDate);
    }
  }

  void _updateText(DateTime? date) {
    if (date != null) {
      _textController.text = _dateFormat.format(date);
    } else {
      _textController.clear();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? now,
      firstDate: widget.minDate ?? DateTime(1900),
      lastDate: widget.maxDate ?? now,
    );

    if (picked != null) {
      _updateText(picked);
      widget.onDateSelected(picked);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
    controller: _textController,
    readOnly: true,
    onTap: () => _selectDate(context),

    decoration: InputDecoration(
      labelText: widget.title,
      floatingLabelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(
        widget.icon ?? Icons.calendar_today_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      suffixIcon: const Icon(Icons.arrow_drop_down),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
    ),
  ),


      ),
    );
  }
}
