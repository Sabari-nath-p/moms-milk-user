import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// A simple class to hold unit information.
class Unit {
  final String name;
  final double conversionFactorToMl;

  const Unit({required this.name, required this.conversionFactorToMl});
}

class UnitInputField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final Icon icon;
  final List<Unit>? inputUnitList;

  UnitInputField({
    super.key,
    required this.controller,
    required this.title,
    required this.icon,
    this.inputUnitList,
  });

  @override
  State<UnitInputField> createState() => _UnitInputFieldState();
}

class _UnitInputFieldState extends State<UnitInputField> {
  final TextEditingController _displayController = TextEditingController();

  // Default units
  List<Unit> _units = const [
    Unit(name: 'ml', conversionFactorToMl: 1.0),
    Unit(name: 'oz', conversionFactorToMl: 29.5735),
  ];

  late Unit _selectedUnit;

  @override
  void initState() {
    super.initState();

    // 1️⃣ Replace units list FIRST before selecting default
    if (widget.inputUnitList != null && widget.inputUnitList!.isNotEmpty) {
      _units = widget.inputUnitList!;
    }

    // 2️⃣ Now safely pick the first item
    _selectedUnit = _units.first;

    // 3️⃣ Sync initial display from ML controller
    if (widget.controller.text.isNotEmpty) {
      _updateDisplayFromMl();
    }

    // 4️⃣ Listen for external changes
    widget.controller.addListener(_updateDisplayFromMl);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateDisplayFromMl);
    _displayController.dispose();
    super.dispose();
  }

  void _updateMlFromDisplay(String displayText) {
    final displayValue = double.tryParse(displayText) ?? 0.0;
    final mlValue = displayValue * _selectedUnit.conversionFactorToMl;

    widget.controller.removeListener(_updateDisplayFromMl);
    widget.controller.text = mlValue.toStringAsFixed(2);
    widget.controller.addListener(_updateDisplayFromMl);
  }

  void _updateDisplayFromMl() {
    final mlValue = double.tryParse(widget.controller.text) ?? 0.0;
    final displayValue = mlValue / _selectedUnit.conversionFactorToMl;

    final newText =
        displayValue > 0 ? displayValue.toStringAsFixed(2) : '';

    if (_displayController.text != newText) {
      _displayController.text = newText;
    }
  }

  void _onUnitChanged(Unit? newUnit) {
    if (newUnit != null) {
      setState(() => _selectedUnit = newUnit);
      _updateDisplayFromMl();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _displayController,
      onChanged: _updateMlFromDisplay,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      style: const TextStyle(fontSize: 16),

      decoration: InputDecoration(
        labelText: widget.title,
        prefixIcon: widget.icon,

        suffixIcon: DropdownButtonHideUnderline(
          child: DropdownButton<Unit>(
            value: _selectedUnit,
            onChanged: _onUnitChanged,
            icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
            items: _units.map((unit) {
              return DropdownMenuItem<Unit>(
                value: unit,
                child: Text(unit.name, style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
        ),

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
    );
  }
}
