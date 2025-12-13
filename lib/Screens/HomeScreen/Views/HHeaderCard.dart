import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class HHeaderCard extends StatelessWidget {
  const HHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homecontroller>(
      builder:
          (controller) => Container(
            padding: const EdgeInsets.all(24),
           // margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
            gradient:AppTheme.CardGradient,
 borderRadius: BorderRadius.circular(24),
               // Blended Deep Charcoal
             
              border: Border.all(
                 color: AppTheme.borderColor,
          width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      gradient: AppTheme.buttonCardGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.child_care,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
               Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Good ${getTimeOfDay()}, ${user.name}!',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      const SizedBox(height: 4),
      Text(
        user.userType == 'donor'
            ? 'Help families in need today'
            : controller.selectedBady != null
                ? 'Tracking ${controller.selectedBady!.name}\'s journey'
                : 'Add your baby to start tracking',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.7),
            ),
      ),
    ],
  ),
),

              ],
            ),
          ),
    );
  }
}
