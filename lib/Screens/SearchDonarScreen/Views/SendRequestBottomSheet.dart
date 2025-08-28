import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:mommilk_user/Models/SearchDonarModel.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Controller/SearchDonarController.dart';

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
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
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
                  const SizedBox(height: 20),

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
                      const SizedBox(width: 12),
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
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description field
                  Text(
                    'Request Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Please describe your milk request...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quantity field
                  Text(
                    'Quantity Needed (ml)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: '500',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      suffixText: 'ml',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Urgency selector
                  Text(
                    'Urgency Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildUrgencyChip(
                          'MEDIUM',
                          selectedUrgency == 'MEDIUM',
                          Colors.orange,
                          () => setState(() => selectedUrgency = 'MEDIUM'),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 20),

                  // Needed by date (optional)
                  Text(
                    'Needed By (Optional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          const Duration(days: 1),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
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
                          const Spacer(),
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
                  const SizedBox(height: 30),

                  // Send button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
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
                          quantity: int.tryParse(quantityController.text) ?? 0,
                          urgency: selectedUrgency,
                          neededBy: selectedDate,
                        );

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Send Request',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(vertical: 12),
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
