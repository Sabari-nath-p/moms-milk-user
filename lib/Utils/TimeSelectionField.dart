import 'package:flutter/material.dart';

class TimePickerField extends StatefulWidget {
  final String title;
  final String? hintText;
  final IconData? icon; // The icon is optional
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const TimePickerField({
    super.key,
    required this.title,
    required this.onTimeSelected,
    this.initialTime,
    this.hintText,
    this.icon,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    print("hit here 1");
    _updateTextController(widget.initialTime);
  }

  @override
  void didUpdateWidget(covariant TimePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent widget provides a new initialTime, update the display.
    if (widget.initialTime != oldWidget.initialTime) {
      _updateTextController(widget.initialTime);
    }
  }

  void _updateTextController(TimeOfDay? time) {
    print("hitig here 02");

    if (time != null) {
      // Use context to format the time in a locale-appropriate way (e.g., 10:30 PM or 22:30)
      _textController.text = time.format(context);
      print("hitig here");
    } else {
      _textController.clear();
    }
  }

  /// Shows the time picker dialog.
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.initialTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      // If a time is selected, update the display and call the callback.
      _updateTextController(picked);
      widget.onTimeSelected(picked);
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
      onTap: () => _selectTime(context),
      child: AbsorbPointer(
        // AbsorbPointer prevents the keyboard from appearing
        // when the user taps on the text field.
        child: TextFormField(
          controller: _textController,
          readOnly: true,
          onTap: () => _selectTime(context),

          decoration: InputDecoration(
            labelText: widget.title,
            floatingLabelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: Icon(
              widget.icon ?? Icons.access_time_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black.withOpacity(.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
