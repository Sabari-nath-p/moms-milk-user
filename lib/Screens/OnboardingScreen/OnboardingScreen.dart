import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Views/BabyDetailsStep.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Views/DonarDetailsStep.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Views/UserDetailsEntryView.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Views/UserTypeView.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  String emailID;
  OnboardingScreen({super.key, required this.emailID});
  @override
  Widget build(BuildContext context) {
    Onboardingcontroller controller = Get.put(Onboardingcontroller(emailID));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Setup Your Profile'.tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: "Inter",
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: controller.currentStep == 0 ? null : SizedBox.shrink(),
      ),
      body: GetBuilder<Onboardingcontroller>(
        builder: (controller) {
          return Column(
            children: [
              // Progress Indicator
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value:
                                (controller.currentStep + 1) /
                                controller.totalStep,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step ${controller.currentStep + 1} of ${controller.totalStep}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${((controller.currentStep + 1) / controller.totalStep * 100).round()}%',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Step Content
              Expanded(child: _buildCurrentStep()),

              // Navigation Buttons
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
                child: Row(
                  children: [
                    if (controller.currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.previousStep,
                          child: Text('Previous'.tr),
                        ),
                      ),
                    if (controller.currentStep > 0) SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.roundButtonGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                         onPressed: controller.isLoading ? null : () {
  controller.nextStep();
},

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              controller.isLoading
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    "Continue".tr,
                                    style: TextStyle(color: Colors.white),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentStep() {
    Onboardingcontroller controller = Get.find();
    ;
    switch (controller.currentStep) {
      case 0:
        return UserDetailsStep();
      case 1:
        return UserTypeStep();
      case 2:
        return DonarDetailsStep();
      default:
        return UserDetailsStep();
    }
  }
}
