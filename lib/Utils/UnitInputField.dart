import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// A simple class to hold unit information.
class Unit {
  final String name;
  final double conversionFactorToMl; // How many ml are in one of this unit.

  const Unit({required this.name, required this.conversionFactorToMl});
}

class UnitInputField extends StatefulWidget {
  final TextEditingController
  controller; // Controller for the final value in ML
  final String title;
  final Icon icon;
  final List<Unit>? inputUnitList;

  UnitInputField({
    super.key,
    required this.controller, // This controller will store the value in ML
    required this.title,
    required this.icon,
    this.inputUnitList,
  });

  @override
  State<UnitInputField> createState() => _UnitInputFieldState();
}

class _UnitInputFieldState extends State<UnitInputField> {
  // A separate controller for what the user sees in the text field.
  final TextEditingController _displayController = TextEditingController();

  // Define the available units and their conversion factors to ML.
  List<Unit> _units = [
    Unit(name: 'ml', conversionFactorToMl: 1.0),
    Unit(name: 'oz', conversionFactorToMl: 29.5735), // US fluid ounce
  ];

  late Unit _selectedUnit;

  @override
  void initState() {
    super.initState();
    // Set the default unit to 'ml'.
    _selectedUnit = _units.first;

    // If the main controller has an initial value, update the display.
    if (widget.controller.text.isNotEmpty) {
      _updateDisplayFromMl();
    }

    if (widget.inputUnitList != null && widget.inputUnitList!.isNotEmpty) {
      _units = widget.inputUnitList ?? [];
    }

    // Listen for external changes to the main controller.
    widget.controller.addListener(_updateDisplayFromMl);
  }

  @override
  void dispose() {
    // Clean up controllers and listeners to prevent memory leaks.
    widget.controller.removeListener(_updateDisplayFromMl);
    _displayController.dispose();
    super.dispose();
  }

  /// Updates the main controller (in ml) when the user types in the text field.
  void _updateMlFromDisplay(String displayText) {
    final displayValue = double.tryParse(displayText) ?? 0.0;
    final mlValue = displayValue * _selectedUnit.conversionFactorToMl;

    // Update the main controller without notifying its own listener to avoid a loop.
    widget.controller.removeListener(_updateDisplayFromMl);
    widget.controller.text = mlValue.toStringAsFixed(2);
    widget.controller.addListener(_updateDisplayFromMl);
  }

  /// Updates the visible text field when the main controller's value changes.
  void _updateDisplayFromMl() {
    final mlValue = double.tryParse(widget.controller.text) ?? 0.0;
    final displayValue = mlValue / _selectedUnit.conversionFactorToMl;

    // Update the display controller only if the text is different to avoid cursor jumps.
    final newDisplayText =
        displayValue > 0 ? displayValue.toStringAsFixed(2) : '';
    if (_displayController.text != newDisplayText) {
      _displayController.text = newDisplayText;
    }
  }

  /// Handles changing the selected unit from the dropdown.
  void _onUnitChanged(Unit? newUnit) {
    if (newUnit != null) {
      setState(() {
        _selectedUnit = newUnit;
      });
      // After the unit changes, recalculate the displayed value.
      _updateDisplayFromMl();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _displayController, // Use the internal display controller
      onChanged: _updateMlFromDisplay, // Update the ML value when user types
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        // Allow numbers and a single decimal point
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 16),

      decoration: InputDecoration(
        labelText: widget.title,
        prefixIcon: widget.icon,

        // The suffix is now a dropdown button for unit selection
        suffixIcon: DropdownButton<Unit>(
          value: _selectedUnit,
          // Remove the default underline of the dropdown
          underline: const SizedBox.shrink(),
          onChanged: _onUnitChanged,
          items:
              _units.map<DropdownMenuItem<Unit>>((Unit unit) {
                return DropdownMenuItem<Unit>(
                  value: unit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      unit.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
        ),
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
    );
  }
}
