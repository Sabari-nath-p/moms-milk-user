import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Views/BabyDetailsStep.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Views/DonarDetailsStep.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Views/UserDetailsEntryView.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Views/UserTypeView.dart';

class OnboardingScreen extends StatelessWidget {
  String emailID;
  OnboardingScreen({super.key, required this.emailID});
  @override
  Widget build(BuildContext context) {
    Onboardingcontroller controller = Get.put(Onboardingcontroller(emailID));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:
            controller.currentStep > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: controller.previousStep,
                )
                : const SizedBox.shrink(),
      ),
      body: GetBuilder<Onboardingcontroller>(
        builder: (controller) {
          return Column(
            children: [
              // Progress Indicator
              Container(
                padding: const EdgeInsets.all(16),
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
                    const SizedBox(height: 8),
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (controller.currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.previousStep,
                          child: const Text('Previous'),
                        ),
                      ),
                    if (controller.currentStep > 0) const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.nextStep();
                        },
                        child:
                            controller.isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text("Continue"),
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
        return const UserTypeStep();
      case 2:
        return const DonarDetailsStep();
      default:
        return UserDetailsStep();
    }
  }
}
