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

  final Homecontroller controller = Get.put(Homecontroller());
  final Chatcontroller ctrl = Get.put(Chatcontroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homecontroller>(
      builder: (controller) {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return SafeArea(child: _buildBody(context, controller));
      },
    );
  }

  Widget _buildBody(BuildContext context, Homecontroller controller) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchBabies(isNew: true);
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HHeaderCard(),

            /// ✅ THIS WILL NOW UPDATE PROPERLY
            if (controller.myBabies.isEmpty && controller.selectedBady == null)
              _buildAddBabyCard(context),

            HQuickActions(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBabyCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryColor.withOpacity(.4)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(Icons.baby_changing_station, color: Colors.pink),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add your baby\'s profile to start tracking'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.roundButtonGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  Get.to(
                    () => CreateBabyScreen(skip: false),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Text(
                  'Add Baby'.tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            HQuickActions(),
            SizedBox(height: 24),

            // _buildTodayStats(context),
            // SizedBox(height: 24),
            // _buildRecentActivity(context),
            SizedBox(height: 10), // Bottom padding for navigation
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
      return 'Just now'.tr;
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago'.tr;
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago'.tr;
    } else {
      return '${difference.inDays}d ago'.tr;
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
    return 'Morning'.tr;
  } else if (hour >= 12 && hour < 17) {
    return 'Afternoon'.tr;
  } else if (hour >= 17 && hour < 21) {
    return 'Evening'.tr;
  } else {
    return 'Night'.tr;
  }
}
