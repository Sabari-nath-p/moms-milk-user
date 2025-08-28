import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/Controller/BabyCreateController.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';

class CreateBabyScreen extends StatelessWidget {
  bool skip = true;
  CreateBabyScreen({super.key, this.skip = true});
  final CreateBabyController controller = Get.put(CreateBabyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(),
        actions: [
          if (skip)
            InkWell(
              onTap: () {
                Get.offAll(MainDashboard(), transition: Transition.leftToRight);
              },
              child: Text(
                "Skip",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<CreateBabyController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Baby Information',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Please provide information about your baby to complete your profile.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 32),

                  // Baby Name
                  TextField(
                    controller: controller.babyNameController,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Baby\'s Name *',
                      hintText: 'Enter baby\'s name',
                      prefixIcon: const Icon(Icons.child_care),
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

                  const SizedBox(height: 24),

                  // Baby Gender
                  Text(
                    'Gender *',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children:
                        Gender.values.map((gender) {
                          final isSelected = controller.babyGender == gender;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    gender.name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  controller.babyGender =
                                      selected ? gender : null;

                                  controller.update();
                                },
                                selectedColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.2),
                                checkmarkColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Delivery Date
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
                                      ? _formatDate(
                                        controller.babyDeliveryDate!,
                                      )
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

                  // const SizedBox(height: 24),

                  // Baby Blood Group
                  // Text(
                  //   'Baby\'s Blood Group *',
                  //   style: Theme.of(
                  //     context,
                  //   ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  // ),

                  // const SizedBox(height: 12),

                  // Obx(
                  //   () => Wrap(
                  //     spacing: 8,
                  //     runSpacing: 8,
                  //     children:
                  //         BloodGroup.values.map((bloodGroup) {
                  //           final isSelected =
                  //               controller.babyBloodGroup.value == bloodGroup;
                  //           return FilterChip(
                  //             label: Text(controller.getBloodGroupText(bloodGroup)),
                  //             selected: isSelected,
                  //             onSelected: (selected) {
                  //               controller.babyBloodGroup.value =
                  //                   selected ? bloodGroup : null;
                  //             },
                  //             selectedColor: Theme.of(
                  //               context,
                  //             ).colorScheme.primary.withOpacity(0.2),
                  //             checkmarkColor: Theme.of(context).colorScheme.primary,
                  //           );
                  //         }).toList(),
                  //   ),
                  // ),
                  const SizedBox(height: 24),

                  // Baby Weight
                  TextField(
                    controller: controller.babbyWeightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Birth Weight (kg)',
                      hintText: 'e.g., 3.2 (Optional)',
                      prefixIcon: const Icon(Icons.monitor_weight_outlined),
                      helperText:
                          'Enter baby\'s weight in kilograms (Optional)',
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
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 24),

                  // Baby Height
                  TextField(
                    controller: controller.babyHeightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Birth Height (cm)',
                      hintText: 'e.g., 50.5 (Optional)',
                      prefixIcon: const Icon(Icons.height_outlined),
                      helperText:
                          'Enter baby\'s height in centimeters (Optional)',
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
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 32),

                  // Validate Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.CreateNewBaby(skip: skip);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        //foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Baby Details',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
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
                          Icons.privacy_tip_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Baby information is kept private and secure. It\'s only used for matching and safety purposes.',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
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
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    CreateBabyController controller = Get.find();
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
