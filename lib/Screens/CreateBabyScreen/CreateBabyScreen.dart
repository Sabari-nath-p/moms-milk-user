import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/Controller/BabyCreateController.dart';
import 'package:mommilk_user/Screens/Dashboard/MainDashBoard.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:mommilk_user/Utils/DateSelectionField.dart';
import 'package:mommilk_user/Utils/UnitInputField.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class CreateBabyScreen extends StatelessWidget {
  bool skip = true;
  CreateBabyScreen({super.key, this.skip = true});
  final CreateBabyController controller = Get.put(CreateBabyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Setup Your Profile'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: "Inter",
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 239, 212, 214),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xFFF43F5E),
                size: 20,
              ),
            ),
          ),
        ),

        actions: [
          if (skip)
            InkWell(
              onTap: () {
                Get.offAll(MainDashboard(), transition: Transition.leftToRight);
              },
              child: Text(
                "Skip".tr,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<CreateBabyController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Baby Information'.tr,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Please provide information about your baby to complete your profile.'.tr,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),

                  SizedBox(height: 32),

                  // Baby Name
                  TextField(
                   controller: controller.babyNameController,
  textInputAction: TextInputAction.newline,
  maxLines: 2,
  minLines: 1,
  keyboardType: TextInputType.name,
  style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Baby\'s Name *'.tr,
                      hintText: 'Enter baby\'s name'.tr,
                      prefixIcon: Icon(
                        Icons.child_care,
                        color: Color(0xffFDA4AF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),

                        borderSide: BorderSide(color: Colors.grey[400]!),
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

                  // Baby Gender
                  Text( 
                    'Gender'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 12),

                  Row(
                    children:
                        Gender.values.map((gender) {
                          final isSelected = controller.babyGender == gender;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    gender.name.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors
                                                  .black, // text color change
                                    ),
                                  ),
                                ),
                                selected: isSelected,

                                onSelected: (selected) {
                                  controller.babyGender =
                                      selected ? gender : null;
                                  controller.update();
                                },

                                // 🔥 SELECTED STATE → Dark Pink background
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,

                                // 🔥 UNSELECTED STATE → White background
                                backgroundColor: Colors.white,

                                checkmarkColor:
                                    Colors.white, // checkmark stays white
                                side: BorderSide(
                                  color: Colors.grey,
                                ), // optional border
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  SizedBox(height: 24),

                  // Delivery Date
                  DatePickerField(
                    title: "Delivery Date".tr,
                    onDateSelected: (value) {
                      controller.babyDeliveryDate = value;
                    },
                  ),

                  // SizedBox(height: 24),

                  // Baby Blood Group
                  // Text(
                  //   'Baby\'s Blood Group *',
                  //   style: Theme.of(
                  //     context,
                  //   ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  // ),

                  // SizedBox(height: 12),

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
                  SizedBox(height: 24),

                  // Baby Weight
                  UnitInputField(
                    controller: controller.babbyWeightController,
                    title: "Birth Weight".tr,
                    icon: Icon(
                      Icons.monitor_weight_outlined,
                      color: Color(0xffFDA4AF),
                    ),
                    inputUnitList: [
                      Unit(name: "kg", conversionFactorToMl: 1.0),
                      Unit(
                        name: "lb",
                        conversionFactorToMl: 0.453592,
                      ), // 1 lb = 0.453592 kg
                    ],
                  ),
                  //SizedBox(height: 24),
                  SizedBox(height: 24),
                  // Baby Height
                  UnitInputField(
                    controller: controller.babyHeightController,
                    title: "Birth Height".tr,
                    icon: Icon(
                      Icons.height_outlined,
                      color: Color(0xffFDA4AF),
                    ),
                    inputUnitList: [
                      Unit(name: "cm", conversionFactorToMl: 1.0),
                      Unit(
                        name: "in",
                        conversionFactorToMl: 2.54,
                      ), // 1 inch = 2.54 cm
                    ],
                  ),

                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          controller.isLoading
                              ? null
                              : () {
                                controller.createNewBaby(skip: skip);
                              },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient:
                              controller.isLoading
                                  ? LinearGradient(
                                    colors: [Colors.grey, Colors.grey],
                                  )
                                  : AppTheme.roundButtonGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child:
                              controller.isLoading
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    'Save Baby Details'.tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Info Card
                  Container(
                    padding: EdgeInsets.all(16),
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
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Baby information is kept private and secure. It\'s only used for matching and safety purposes.'.tr,
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
        Duration(days: 365 * 2),
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
