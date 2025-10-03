import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A text field-like widget that opens a date picker on tap.
///
/// This widget manages its own TextEditingController for display purposes
/// and communicates the selected date via the [onDateSelected] callback.
class DatePickerField extends StatefulWidget {
  final String title;
  final String? hintText;
  final IconData? icon; // The icon is optional
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerField({
    super.key,
    required this.title,
    required this.onDateSelected,
    this.initialDate,
    this.hintText,
    this.icon,
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
    // If the parent widget provides a new initialDate, update the display.
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(1900), // Set a reasonable lower bound
      lastDate: DateTime(2101), // Set a reasonable upper bound
    );

    if (picked != null) {
      // If a date is selected, update the display and call the callback.
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
        // AbsorbPointer prevents the keyboard from appearing
        // when the user taps on the text field.
        child: TextFormField(
          controller: _textController, // Use the internal controller
          readOnly: true, // Makes the field not editable by keyboard
          decoration: InputDecoration(
            labelText: widget.title,
            hintText: widget.hintText,
            fillColor: Theme.of(context).primaryColor.withOpacity(.1),
            // Use the provided icon or a default calendar icon.
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
