import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';

class DonarDetailsStep extends StatelessWidget {
  const DonarDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Onboardingcontroller>(
      builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Donor Information',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Please provide additional information to help ensure safe milk donation.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),

              const SizedBox(height: 32),

              // Delivery Location
              // TextField(
              //   controller: deliveryLocationController,
              //   style: const TextStyle(fontSize: 16),
              //   decoration: InputDecoration(
              //     labelText: 'Preferred Delivery Location *',
              //     hintText: 'e.g., Home, Hospital, Pickup Point',
              //     prefixIcon: const Icon(Icons.location_on_outlined),
              //     helperText: 'Where would you prefer to deliver or meet?',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide(color: Colors.grey[300]!),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide(
              //         color: Theme.of(context).colorScheme.primary,
              //         width: 2,
              //       ),
              //     ),
              //   ),
              //   onChanged: (value) => controller.deliveryLocation.value = value,
              // ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF212121),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Date *',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller.babyDeliveryDate != null
                                  ? _formatDate(controller.babyDeliveryDate!)
                                  : 'Select delivery date',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color:
                                    controller.babyDeliveryDate != null
                                        ? Colors.white
                                        : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Blood Group
              Text(
                'Your Blood Group *',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    BloodGroup.values.map((bloodGroup) {
                      final isSelected =
                          controller.seletecBloodGroup == bloodGroup;
                      return FilterChip(
                        label: Text(getBloodGroupText(bloodGroup)),
                        selected: isSelected,
                        onSelected: (selected) {
                          controller.seletecBloodGroup =
                              selected ? bloodGroup : null;

                          controller.update();
                        },
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                      );
                    }).toList(),
              ),

              const SizedBox(height: 32),

              // Donor Qualities
              Text(
                'Health & Lifestyle Information',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              Text(
                'Select all that apply to you (optional but recommended):',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),

              const SizedBox(height: 16),

              Column(
                children:
                    DonorQuality.values.map((quality) {
                      final isSelected = controller.selectedQualities.contains(
                        quality,
                      );
                      return CheckboxListTile(
                        title: Text(getDonorQualityText(quality)),
                        subtitle: _getQualityDescription(quality),
                        value: isSelected,
                        onChanged: (selected) {
                          if (selected ?? false)
                            controller.selectedQualities.add(quality);
                          else
                            controller.selectedQualities.remove(quality);

                          controller.update();
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Theme.of(context).colorScheme.primary,
                      );
                    }).toList(),
              ),

              const SizedBox(height: 24),

              // Medical Report Sharing
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medical Report Sharing',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Would you be willing to share your medical reports with potential milk recipients if requested?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Yes'),
                            value: true,
                            groupValue:
                                controller.isWillingToShareMedicalReport,
                            onChanged: (value) {
                              controller.isWillingToShareMedicalReport =
                                  value ?? false;

                              controller.update();
                            },
                            contentPadding: EdgeInsets.zero,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('No'),
                            value: false,
                            groupValue:
                                controller.isWillingToShareMedicalReport,
                            onChanged: (value) {
                              controller.isWillingToShareMedicalReport =
                                  value ?? false;

                              controller.update();
                            },
                            contentPadding: EdgeInsets.zero,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Safety Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'All donors undergo medical screening and verification before being approved to ensure recipient safety.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _getQualityDescription(DonorQuality quality) {
    String description;
    switch (quality) {
      case DonorQuality.organic:
        description = 'Following organic diet practices';
        break;
      case DonorQuality.vegetarian:
        description = 'Following vegetarian diet';
        break;
      case DonorQuality.medicationFree:
        description = 'Not taking medications (except approved ones)';
        break;
      case DonorQuality.smokeFree:
        description = 'Non-smoker environment';
        break;
      case DonorQuality.alcoholFree:
        description = 'No alcohol consumption';
        break;
    }

    return Text(
      description,
      style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    Onboardingcontroller controller = Get.find();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.babyDeliveryDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 365 * 2),
      ), // 2 years ago
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

    if (picked != null) {
      controller.babyDeliveryDate = picked;
      controller.update();
    }
  }
}
