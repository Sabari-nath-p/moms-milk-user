import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/DiaperLogModel.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Utils/DateSelectionField.dart';
import 'package:mommilk_user/Utils/TimeSelectionField.dart';

class DiaperChangeBottomSheet extends StatefulWidget {
  DiaperChangeBottomSheet({super.key});

  @override
  State<DiaperChangeBottomSheet> createState() =>
      _DiaperChangeBottomSheetState();
}

class _DiaperChangeBottomSheetState extends State<DiaperChangeBottomSheet> {
  DateTime? selectedDate; //= DateTime.now();
  TimeOfDay? selectedTime; //= TimeOfDay.now();
  DiaperType selectedDiaperType = DiaperType.SOLID;
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.baby_changing_station,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Log Diaper'.tr,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Date Selection
                DatePickerField(
                  title: "Date".tr,
                  onDateSelected: (Value) {
                    selectedDate = Value;
                  },
                ),

                SizedBox(height: 16),

                // Time Selection
                TimePickerField(
                  title: "Time".tr,
                  onTimeSelected: (value) {
                    selectedTime = value;
                  },
                ),

                SizedBox(height: 16),

                // Diaper Type Selection
                Text(
                  'Diaper Type'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 12),

                Row(
                  children:
                      DiaperType.values.map((type) {
                        final isSelected = selectedDiaperType == type;

                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  type.displayName.tr.capitalize.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary // Pink
                                            : Colors.black, // Normal
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),

                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedDiaperType = type;
                                });
                              },

                              selectedColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.15),

                              checkmarkColor:
                                  Theme.of(context).colorScheme.primary,

                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,

                              side: BorderSide(
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey[300]!,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                SizedBox(height: 16),

                // Note Field
                TextField(
                  controller: noteController,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Note'.tr,
                    hintText: 'Add any additional notes...'.tr,
                    prefixIcon: Icon(Icons.note_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
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

                SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GetBuilder<Homecontroller>(
                        builder: (controller) {
                          return ElevatedButton(
                            onPressed: _saveDiaperLog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                (controller.isSubmitLoading)
                                    ? CircularProgressIndicator()
                                    : Text(
                                      'Save Log'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _saveDiaperLog() {
    if (selectedDate == null) {
      Get.snackbar(
        'Log Failed',
        'Please select diaper change date before submission'.tr,
      );
      return;
    }
    if (selectedTime == null) {
      Get.snackbar(
        'Log Failed',
        'Please select diaper change time before submission'.tr,
      );
      return;
    }
    // Create the diaper log
    Homecontroller hctrl = Get.find();
    final diaperLog = DiaperLogModel(
      date: selectedDate!,
      time: DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      ),
      diaperType: selectedDiaperType,
      babyId: hctrl.selectedBady!.id,
      note:
          noteController.text.trim().isEmpty
              ? null
              : noteController.text.trim(),
    );

    // Show success message

    // Close the bottom sheet

    hctrl.LogDiaper(diaperLog);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
