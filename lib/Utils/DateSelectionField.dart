import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A text field-like widget that opens a date picker on tap,
/// with minDate and maxDate support.
class DatePickerField extends StatefulWidget {
  final String title;
  final String? hintText;
  final IconData? icon;
  final DateTime? initialDate;
  final DateTime? minDate;   // ✅ ADDED
  final DateTime? maxDate;   // ✅ ADDED
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
    _updateTextController(widget.initialDate);
  }

  @override
  void didUpdateWidget(covariant DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialDate != oldWidget.initialDate) {
      _updateTextController(widget.initialDate);
    }
  }

  void _updateTextController(DateTime? date) {
    if (date != null) {
      _textController.text = _dateFormat.format(date);
    } else {
      _textController.clear();
    }
  }

  /// Shows the date picker dialog.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? now,
      firstDate: widget.minDate ?? DateTime(1900),  // ✅ supports minDate
      lastDate: widget.maxDate ?? now,              // ✅ supports maxDate (blocking future dates)
    );

    if (picked != null) {
      _updateTextController(picked);
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
          decoration: InputDecoration(
            labelText: widget.title,
          
            hintText: widget.hintText,hintStyle: TextStyle(color: Colors.grey[400]),
            fillColor: Theme.of(context).primaryColor.withOpacity(.1),
            prefixIcon: Icon(
              widget.icon ?? Icons.calendar_today_outlined,
              color: Theme.of(context).primaryColor,
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
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
