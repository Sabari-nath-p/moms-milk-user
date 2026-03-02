import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/SleepLogModel.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Utils/DateSelectionField.dart';
import 'package:mommilk_user/Utils/TimeSelectionField.dart';

class SleepLogBottomSheet extends StatefulWidget {
  SleepLogBottomSheet({super.key});

  @override
  State<SleepLogBottomSheet> createState() => _SleepLogBottomSheetState();
}

class _SleepLogBottomSheetState extends State<SleepLogBottomSheet> {
  DateTime? selectedDate; //= DateTime.now();
  TimeOfDay? startTime; //= TimeOfDay.now();
  TimeOfDay? endTime;
  //=
  //  TimeOfDay.now(); //TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);

  SleepQuality selectedSleepQuality = SleepQuality.good;
  SleepLocation selectedLocation = SleepLocation.CRIB;
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
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.bedtime,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Log Sleep'.tr,
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
                  onDateSelected: (value) {
                    selectedDate = value;
                  },
                ),

                SizedBox(height: 16),

                // Time Selection Row
                Row(
                  children: [
                    // Start Time
                    Expanded(
                      child: TimePickerField(
                        title: "Start Time".tr,
                        onTimeSelected: (value) {
                          startTime = value;
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    // End Time
                    Expanded(
                      child: TimePickerField(
                        title: "End Time".tr,

                        onTimeSelected: (value) {
                          endTime = value;
                        },
                      ),
                    ),
                  ],
                ),

                //  SizedBox(height: 16),

                // Sleep Quality Selection
                // Text(
                //   'Sleep Quality',
                //   style: Theme.of(
                //     context,
                //   ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                // ),

                // SizedBox(height: 12),

                // Row(
                //   children:
                //       SleepQuality.values.map((quality) {
                //         final isSelected = selectedSleepQuality == quality;
                //         return Expanded(
                //           child: Padding(
                //             padding: EdgeInsets.only(right: 8),
                //             child: FilterChip(
                //               label: SizedBox(
                //                 width: double.infinity,
                //                 child: Text(
                //                   quality.displayName,
                //                   textAlign: TextAlign.center,
                //                 ),
                //               ),
                //               selected: isSelected,
                //               onSelected: (selected) {
                //                 setState(() {
                //                   selectedSleepQuality = quality;
                //                 });
                //               },
                //               selectedColor: Theme.of(
                //                 context,
                //               ).colorScheme.primary.withOpacity(0.2),
                //               checkmarkColor:
                //                   Theme.of(context).colorScheme.primary,
                //               backgroundColor:
                //                   Theme.of(context).colorScheme.surface,
                //               side: BorderSide(
                //                 color:
                //                     isSelected
                //                         ? Theme.of(context).colorScheme.primary
                //                         : Colors.grey[300]!,
                //               ),
                //             ),
                //           ),
                //         );
                //       }).toList(),
                // ),
                SizedBox(height: 16),

                // Sleep Location Selection
                Text(
                  'Sleep Location'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 12),

                Row(
                  children:
                      SleepLocation.values.map((location) {
                        final isSelected = selectedLocation == location;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '${location.icon} ${location.displayName.tr.capitalize.toString()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary // Pink text
                                            : Colors.black,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedLocation = location;
                                });
                              },
                              selectedColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.2),
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

                if (false) SizedBox(height: 16),

                // Note Field
                if (false)
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Note (Optional)',
                      hintText: 'Add any additional notes about the sleep...',
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
                      child: ElevatedButton(
                        onPressed: _saveSleepLog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save Log'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
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

    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
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

    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  void _saveSleepLog() {
    // Validate that end time is after start time

    if (selectedDate == null) {
      Get.snackbar(
        'Log Failed',
        'Please select sleep date before submission'.tr,
      );
      return;
    }

    if (startTime == null) {
      Get.snackbar(
        'Log Failed',
        'Please select start time before submission'.tr,
      );
      return;
    }

    if (endTime == null) {
      Get.snackbar('Log Failed', 'Please select end time before submission'.tr);
      return;
    }

    Homecontroller hctrl = Get.put(Homecontroller());
    final startDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      startTime!.hour,
      startTime!.minute,
    );

    final endDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      endTime!.hour,
      endTime!.minute,
    );

    // If end time is before start time, assume it's next day
    final adjustedEndDateTime =
        endDateTime.isBefore(startDateTime)
            ? endDateTime.add(Duration(days: 1))
            : endDateTime;

    if (adjustedEndDateTime.difference(startDateTime).inMinutes < 1) {
      Get.snackbar('Validation Error', 'End time must be after start time'.tr);
      return;
    }

    // Create the sleep log
    final sleepLog = SleepLogModel(
      date: selectedDate!,
      startTime: startDateTime,
      endTime: adjustedEndDateTime,
      sleepQuality: selectedSleepQuality,
      location: selectedLocation,
      babyId: hctrl.selectedBady!.id,
      note:
          noteController.text.trim().isEmpty
              ? null
              : noteController.text.trim(),
    );

    // Show success message

    // Close the bottom sheet

    hctrl.LogSleep(sleepLog);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
