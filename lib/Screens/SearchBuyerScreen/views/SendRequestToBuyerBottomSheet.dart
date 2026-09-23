import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/SearchBuyerModel.dart';
import 'package:mommilk_user/Screens/SearchBuyerScreen/Controller/SearchBuyerController.dart';
import 'package:mommilk_user/Utils/UnitInputField.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class SendRequestToBuyerBottomSheet extends StatefulWidget {
  SearchBuyerModel buyer;
  SendRequestToBuyerBottomSheet({super.key, required this.buyer});

  @override
  State<SendRequestToBuyerBottomSheet> createState() =>
      _SendRequestToBuyerBottomSheetState();
}

class _SendRequestToBuyerBottomSheetState
    extends State<SendRequestToBuyerBottomSheet> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  DateTime? selectedDate;
  String selectedUrgency = 'LOW';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchBuyerController>(
      builder: (controller) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        child: Text(
                          (widget.buyer.buyer!.name ?? 'B')[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Send Request to @name'.trParams({
                                'name': widget.buyer.buyer?.name ?? 'Buyer'.tr,
                              }),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${widget.buyer.distanceText ?? 'Distance unknown'}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      IconButton(
                        icon: Icon(Icons.close),
                        splashRadius: 20.r,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Description field
                  Text(
                    'Request Note'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Send a note...'.tr,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.8,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(16.sp),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Quantity field
                  Text(
                    'Quantity Available (ml)'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  UnitInputField(
                    controller: quantityController,
                    title: "",
                    icon: Icon(Icons.height_outlined, color: Color(0xffFDA4AF)),
                    inputUnitList: [
                      Unit(name: 'oz', conversionFactorToMl: 29.5735),
                      Unit(name: 'ml', conversionFactorToMl: 1.0),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Urgency selector
                  Text(
                    'Urgency Level'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUrgencyChip(
                          'LOW'.tr,
                          selectedUrgency == 'LOW',
                          Colors.green,
                          () => setState(() => selectedUrgency = 'LOW'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildUrgencyChip(
                          'MEDIUM'.tr,
                          selectedUrgency == 'MEDIUM',
                          Colors.orange,
                          () => setState(() => selectedUrgency = 'MEDIUM'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildUrgencyChip(
                          'HIGH'.tr,
                          selectedUrgency == 'HIGH',
                          Colors.red,
                          () => setState(() => selectedUrgency = 'HIGH'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Available by date (optional)
                  Text(
                    'Available By (Optional)'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(Duration(days: 1)),
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
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} ${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}'
                                : 'Select date and time'.tr,
                            style: TextStyle(
                              color: selectedDate != null
                                  ? Theme.of(context).textTheme.bodyLarge?.color
                                  : Theme.of(context).textTheme.bodyLarge?.color
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
                                size: 20.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Send button
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        if (descriptionController.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please enter a description'.tr,
                          );
                          return;
                        }
                        if (quantityController.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please enter quantity available'.tr,
                          );
                          return;
                        }

                        controller.sendRequestToBuyer(
                          buyerId: widget.buyer.buyer!.id!,
                          description: descriptionController.text.trim(),
                          quantity:
                              (double.tryParse(quantityController.text) ?? 0)
                                  .toInt(),
                          urgency: selectedUrgency,
                          neededBy: selectedDate,
                        );

                        widget.buyer.hasPendingRequest = true;
                        controller.update();

                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: AppTheme.roundButtonGradient,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Send Request'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
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
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? color : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color, width: isSelected ? 0 : 1),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    ),
  );
}
