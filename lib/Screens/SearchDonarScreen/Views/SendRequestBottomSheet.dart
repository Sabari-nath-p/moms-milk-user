import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:mommilk_user/Models/SearchDonarModel.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Controller/SearchDonarController.dart';
import 'package:mommilk_user/Utils/UnitInputField.dart';
import 'package:mommilk_user/theme/app_theme.dart' show AppTheme;

class SendRequestBottomSheet extends StatefulWidget {
  SearchDonarModel donar;
  SendRequestBottomSheet({super.key, required this.donar});

  @override
  State<SendRequestBottomSheet> createState() => _SendRequestBottomSheetState();
}

class _SendRequestBottomSheetState extends State<SendRequestBottomSheet> {
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController quantityController = TextEditingController();

  DateTime? selectedDate;

  String selectedUrgency = 'LOW';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchDonarController>(
      builder: (controller) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,

          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        child: Text(
                          (widget.donar.donor!.name ?? 'D')[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Send Request to ${widget.donar.donor!.name ?? 'Donor'}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${widget.donar.distanceText ?? 'Distance unknown'}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      IconButton(
                        icon: Icon(Icons.close),
                        splashRadius: 20,
                        onPressed: () {
                          Navigator.pop(context); // closes bottom sheet
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Description field
                  Text(
                    'Request Note',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Sent a note...',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.8,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Quantity field
                  Text(
                    'Quantity Needed (ml)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),

                  UnitInputField(
                    controller: quantityController,
                    title: "",
                    icon: Icon(
                      Icons.height_outlined,
                      color: Color(0xffFDA4AF),
                    ),
                    inputUnitList: [
                      Unit(name: 'oz', conversionFactorToMl: 29.5735),
                      Unit(name: 'ml', conversionFactorToMl: 1.0),
                    ],
                    // icon: FaIcon(FontAwesomeIcons.bottleDroplet, size: 12),
                  ),
                  if (false)
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: '500',
                        suffixText: 'ml',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.8,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),

                  SizedBox(height: 20),

                  // Urgency selector
                  Text(
                    'Urgency Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUrgencyChip(
                          'LOW',
                          selectedUrgency == 'LOW',
                          Colors.green,
                          () => setState(() => selectedUrgency = 'LOW'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildUrgencyChip(
                          'MEDIUM',
                          selectedUrgency == 'MEDIUM',
                          Colors.orange,
                          () => setState(() => selectedUrgency = 'MEDIUM'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildUrgencyChip(
                          'HIGH',
                          selectedUrgency == 'HIGH',
                          Colors.red,
                          () => setState(() => selectedUrgency = 'HIGH'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Needed by date (optional)
                  Text(
                    'Needed By (Optional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          Duration(days: 1),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );
                      if (picked != null) {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            selectedDate = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 12),
                          Text(
                            selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} ${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}'
                                : 'Select date and time',
                            style: TextStyle(
                              color:
                                  selectedDate != null
                                      ? Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color
                                          ?.withOpacity(0.6),
                            ),
                          ),
                          Spacer(),
                          if (selectedDate != null)
                            GestureDetector(
                              onTap: () => setState(() => selectedDate = null),
                              child: Icon(
                                Icons.clear,
                                color: Theme.of(context).colorScheme.error,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Send button
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        print(quantityController.text.trim());
                        if (descriptionController.text.trim().isEmpty) {
                          Get.snackbar('Error', 'Please enter a description');
                          return;
                        }
                        if (quantityController.text.trim().isEmpty) {
                          Get.snackbar('Error', 'Please enter quantity needed');
                          return;
                        }

                        // Send request
                        controller.sendRequestToDonor(
                          donorId: widget.donar.donor!.id!,
                          description: descriptionController.text.trim(),
                          quantity:
                              (double.tryParse(quantityController.text) ?? 0)
                                  .toInt(),
                          urgency: selectedUrgency,
                          neededBy: selectedDate,
                        );

                        widget.donar.hasPendingRequest = true;
                        controller.update();

                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: AppTheme.roundButtonGradient,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Send Request',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildUrgencyChip(
  String label,
  bool isSelected,
  Color color,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? color : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: isSelected ? 0 : 1),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}
