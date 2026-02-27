import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class UserTypeStep extends StatelessWidget {
  UserTypeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Onboardingcontroller>(
      builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'What\'your role?'.tr,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Choose your role to personalize your app experience.'.tr,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black.withOpacity(.7),
                ),
              ),

              SizedBox(height: 40),

              // Donor Option
              _buildUserTypeCard(
                context: context,
                title: 'I have Milk'.tr,
                subtitle: 'I want to donate breast milk'.tr,
                description:
                    'Sharing your excess breast milk safely and track your baby activity'.tr,
                icon: Icons.favorite,
                isSelected: controller.userType == UserType.donor,
                onTap: () {
                  controller.userType = UserType.donor;
                  controller.update();
                },
                benefits: [
                  //   'Help families in need',
                  // 'Safe and verified process',
                  // 'Medical screening support',
                  // 'Flexible donation schedule',
                ],
              ),

              SizedBox(height: 24),

              // Buyer Option
              _buildUserTypeCard(
                context: context,
                title: 'I need Milk'.tr,
                subtitle: 'I need to track my baby and find donors'.tr,
                description:
                    'Access breast milk from verified donors in your area. '.tr,
                icon: Icons.child_care,
                isSelected: controller.userType == UserType.buyer,
                onTap: () {
                  controller.userType = UserType.buyer;
                  controller.update();
                },
                benefits: [
                  // 'Access to screened milk',
                  // 'Verified donor profiles',
                  // 'Safe delivery options',
                  // 'Support and guidance',
                ],
              ),

              //   SizedBox(height: 24),

              // Tracker Option
              SizedBox(height: 32),

              // Info Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.buttonCardGradient,
                   color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Find milk donors near you. Review profiles and connect safely based on your comfort and judgment.'.tr,
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

  Widget _buildUserTypeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required List<String> benefits,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
         // color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          gradient: AppTheme.CardGradient,

          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : Color(0xffF43F5E),
                    size: 24,
                  ),
                ),

                SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black.withOpacity(.8),
                        ),
                      ),
                    ],
                  ),
                ),

                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),

            SizedBox(height: 16),

            Text(description, style: Theme.of(context).textTheme.bodyMedium),

            SizedBox(height: 16),

            ...benefits
                .map(
                  (benefit) => Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          size: 16,
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white.withOpacity(.9),
                        ),
                        SizedBox(width: 8),
                        Text(
                          benefit,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white.withOpacity(.9)),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
