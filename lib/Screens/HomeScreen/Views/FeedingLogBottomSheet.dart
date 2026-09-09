import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/FeedingLogModel.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Utils/DateSelectionField.dart';
import 'package:mommilk_user/Utils/TimeSelectionField.dart';
import 'package:mommilk_user/Utils/UnitInputField.dart';

class FeedingLogBottomSheet extends StatefulWidget {
  FeedingLogBottomSheet({super.key});

  @override
  State<FeedingLogBottomSheet> createState() => _FeedingLogBottomSheetState();
}

class _FeedingLogBottomSheetState extends State<FeedingLogBottomSheet> {
  DateTime? selectedDate; // = DateTime.now();
  TimeOfDay? startTime; // = TimeOfDay.now();
  TimeOfDay? endTime; //= TimeOfDay.now();
  FeedType selectedFeedType = FeedType.BREAST;
  FeedPosition? selectedPosition = FeedPosition.LEFT;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.personBreastfeeding,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Log Feeding'.tr,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  DatePickerField(
                    title: "Select Feeding Date".tr,
                    initialDate: selectedDate,
                    onDateSelected: (value) {
                      selectedDate = value;
                    },
                  ),

                  SizedBox(height: 24),

                  // Time Selection Row
                  Row(
                    children: [
                      // Start Time
                      Expanded(
                        child: TimePickerField(
                          title: "Start Time".tr,
                          onTimeSelected: (value) {
                            setState(() {
                              startTime = value;
                            });
                          },
                        ),
                      ),

                      SizedBox(width: 12),
                      // End Time (Optional)
                      Expanded(
                        child: TimePickerField(
                          title: "End Time".tr,
                          onTimeSelected: (value) {
                            endTime = value;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Feed Type Selection
                  Text(
                    'Feed Type'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 12),
                  Row(
                    children:
                        FeedType.values.map((type) {
                          final isSelected = selectedFeedType == type;

                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '${type.icon} ${type.displayName}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary // Pink text
                                              : Colors.black, // Normal
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
                                    selectedFeedType = type;

                                    if (type != FeedType.BREAST) {
                                      selectedPosition = null;
                                    } else {
                                      selectedPosition = FeedPosition.LEFT;
                                    }
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
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primary
                                          : Theme.of(
                                            context,
                                          ).colorScheme.outline,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  // Position Selection (only for breast feeding)
                  if (selectedFeedType == FeedType.BREAST) ...[
                    SizedBox(height: 16),
                    Text(
                      'Position'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children:
                          FeedPosition.values.map((position) {
                            final isSelected = selectedPosition == position;

                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      position.displayName.capitalize
                                          .toString(),
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
                                      selectedPosition =
                                          selected ? position : null;
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
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],

                  SizedBox(height: 16),

                  // Amount Field (Optional)
                  UnitInputField(
                    controller: amountController,
                    title: "Amount(ml)".tr,
                    icon: Icon(
                      Icons.local_drink_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  // TextField(
                  //   controller: amountController,
                  //   keyboardType: TextInputType.numberWithOptions(
                  //     decimal: true,
                  //   ),
                  //   textInputAction: TextInputAction.done,
                  //   style: TextStyle(fontSize: 16),
                  //   decoration: InputDecoration(
                  //     labelText: 'Amount (ml)',
                  //     hintText: 'e.g., 120',
                  //     prefixIcon: Icon(Icons.local_drink_outlined),
                  //     suffixText: 'ml',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide(
                  //         color: Theme.of(context).colorScheme.outline,
                  //       ),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide(
                  //         color: Theme.of(context).colorScheme.primary,
                  //         width: 2,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  if (false) SizedBox(height: 16),

                  // Note Field (Optional)
                  if (false)
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Note (Optional)',
                        hintText:
                            'Add any additional notes about the feeding...',
                        prefixIcon: Icon(Icons.note_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                          onPressed: _saveFeedingLog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save Log'.tr,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ), // SingleChildScrollView
          ), // ConstrainedBox
        ), // Padding
      ),
    ); // Container
  }

  void _saveFeedingLog() {
    if (selectedDate == null) {
      Fluttertoast.showToast(
        msg: 'Please select feeding date before submission'.tr,
      );
      return;
    }

    if (startTime == null) {
      Fluttertoast.showToast(
        msg: 'Please select feeding start time before submission'.tr,
      );
      return;
    }

    if (endTime == null) {
      Fluttertoast.showToast(
        msg: 'Please select feeding end time before submission'.tr,
      );
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

    DateTime? endDateTime;
    if (endTime != null) {
      endDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        endTime!.hour,
        endTime!.minute,
      );

      // If end time is before start time, assume it's next day
      if (endDateTime.isBefore(startDateTime)) {
        endDateTime = endDateTime.add(Duration(days: 1));
      }

      // Validate duration
      if (endDateTime.difference(startDateTime).inMinutes < 1) {
        Fluttertoast.showToast(msg: 'End time must be after start time'.tr);
        return;
      }
    }

    // Validate amount if provided
    int? parsedAmount;
    if (amountController.text.trim().isNotEmpty) {
      parsedAmount =
          (double.tryParse(amountController.text.trim()) ?? 0).toInt();
      if (parsedAmount == null || parsedAmount <= 0) {
        Fluttertoast.showToast(msg: 'Please enter a valid amount in ml'.tr);
        return;
      }
    }

    // Validate position for breast feeding
    if (selectedFeedType == FeedType.BREAST && selectedPosition == null) {
      Fluttertoast.showToast(
        msg: 'Please select a position for breast feeding'.tr,
      );
      return;
    }

    // Create the feeding log
    final feedingLog = FeedingLogModel(
      feedingDate: selectedDate!,
      startTime: startDateTime,
      endTime: endDateTime,
      feedType: selectedFeedType,
      position: selectedPosition,
      amount: parsedAmount,
      note:
          noteController.text.trim().isEmpty
              ? null
              : noteController.text.trim(),
      babyId: hctrl.selectedBady?.id,
    );

    // Log the feeding
    hctrl.logFeeding(feedingLog);
  }
}
