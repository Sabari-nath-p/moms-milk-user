import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/CreateBabyScreen.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/HBabyListCard.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/HHeaderCard.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/HQuickActions.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/HRequestCard.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:mommilk_user/Screens/ProfileScreen/ProfileScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  Homecontroller controller = Get.put(Homecontroller());

  Chatcontroller ctrl = Get.put(Chatcontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh data
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HHeaderCard(),

            // const SizedBox(height: 20),
            //_buildUserTypeSpecificSection(context),
            // SizedBox(height: 20),

            // if (user.userType == "DONOR") const SizedBox(height: 20),
            //if (user.userType == "DONOR")
            // Padding(
            // padding: EdgeInsets.symmetric(horizontal: 10),
            //child: buildUserTypeSection(context),
            //),
            //const SizedBox(height: 20),
            // HBabyCard(),
            // const SizedBox(height: 24),
            if (controller.myBabies.isEmpty && controller.selectedBady == null)
              Container(
                margin: EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(.4),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.baby_changing_station,
                        color: Colors.pink,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Add your baby\'s profile to start tracking',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.roundButtonGradient,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Get.to(
                              () => CreateBabyScreen(skip: false),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: const Text(
                            'Add Baby',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            HQuickActions(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                      'We’re actively welcoming milk donors. If no donors appear in your area yet, don’t worry more will be joining shortly. Thank you for your patience and support',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            // _buildTodayStats(context),
            // const SizedBox(height: 24),
            // _buildRecentActivity(context),
            const SizedBox(height: 10), // Bottom padding for navigation
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeSpecificSection(BuildContext context) {
    if (user.userType == 'donor') {
      return Container(); //_buildDonorSection(context);
    } else {
      return Container(); //_buildBuyerSection(context);
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes';
  }
}

String getTimeOfDay() {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) {
    return 'Morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Afternoon';
  } else if (hour >= 17 && hour < 21) {
    return 'Evening';
  } else {
    return 'Night';
  }
}
