import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/UserModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/HBabyListCard.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:mommilk_user/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<Homecontroller>(
        builder:
            (controller) => Scaffold(
              backgroundColor: Colors.white,

              // -------------------------------
              // ✅ PINK THEME APP BAR ADDED HERE
              // -------------------------------
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  "Profile".tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: "Inter",
                  ),
                ),
                centerTitle: true,

                iconTheme: IconThemeData(color: Color(0xFFFB7185)),
              ),

              body: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(milliseconds: 500));
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildUserCard(context),
                          SizedBox(height: 20),
                          if (user.userType == "DONOR")
                            buildUserTypeSection(context),
                          SizedBox(height: 20),
                          HBabyCard(),

                          SizedBox(height: 20),

                          _buildSettingsSection(context),
                          SizedBox(height: 20),

                          _buildAppInfoSection(context),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  // ------- your existing widgets below (NO CHANGE) ---------

  Widget _buildUserCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppTheme.CardGradient,
        border: Border.all(color: AppTheme.borderColor, width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppTheme.buttonCardGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text('${user.name}', style: Theme.of(context).textTheme.bodyLarge),
            Text(
              '${user.email}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (false) SizedBox(height: 20),
            if (false)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showEditProfileDialog(context),
                  icon: Icon(Icons.edit, size: 18),
                  label: Text('Edit Profile'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    // HomeController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).primaryColor.withOpacity(.05),
        border: Border.all(color: Color(0xFFFFE4E6), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings'.tr,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            _buildSettingItem(
              context,
              'Language'.tr,
              'Choose your preferred language'.tr,
              Icons.language,
              () {
                _showLanguageDialog(context);
              },
            ),
            Divider(height: 24),
            // _buildSettingItem(
            //   context,
            //   'Notifications',
            //   'Manage your notification preferences',
            //   Icons.notifications,
            //   () => _showNotificationSettings(context),
            // ),
            //  Divider(height: 24),
            _buildSettingItem(
              context,
              'Privacy & Security'.tr,
              'Control your privacy settings'.tr,
              Icons.security,
              () {
                launchUrl(Uri.parse("https://momsmilk.app/privacy-policy"));
              },
            ),
            Divider(height: 24),
            _buildSettingItem(
              context,
              'Rate Us'.tr,
              'Help us improve with your feedback'.tr,
              Icons.rate_review,
              () {
                if (Platform.isAndroid) {
                  launchUrl(Uri.parse("https://momsmilk.app/contacts"));
                } else {
                  launchUrl(Uri.parse("https://momsmilk.app"));
                }
              },
            ),
            Divider(height: 24),
            _buildSettingItem(
              context,
              'Help & Support'.tr,
              'Get help and contact support'.tr,
              Icons.help,
              () {
                launchUrl(Uri.parse("https://momsmilk.app/privacy-policy"));
              },
            ),
            Divider(height: 24),
            _buildSettingItem(
              context,
              'Delete Account'.tr,
              'Delete your mom\'s account'.tr,
              Icons.delete,
              () {
                _showDeleteAccount(context);
              },
            ),
            Divider(height: 24),
            _buildSettingItem(
              context,
              'Logout'.tr,
              'Sign out of your account'.tr,
              Icons.logout,
              () => _showLogoutConfirmation(context),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final settingColor = isDestructive ? Color(0xFFFB7185) : Color(0xFFFB7185);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: settingColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: settingColor, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? Colors.red : null,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).primaryColor.withOpacity(.05),
        border: Border.all(color: Color(0xFFFFE4E6), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Information'.tr,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Version'.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '1.0.0',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Build'.tr, style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  '1.0.0+1',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  launchUrl(Uri.parse("https://momsmilk.app"));
                },
                child: Text(
                  "About Mom's Milk".tr,
                  style: TextStyle(
                    color: Colors.white,
                  ), // Text color white on colored background
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Color(
                    0xFFFB7185,
                  ), // Fill color inside button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Edit Profile'.tr,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Name'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Email'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Phone'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Cancel'.tr),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Save'.tr),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Privacy & Security'.tr),
            content: Text(
              'Privacy and security settings will be implemented here.'.tr,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            title: Text('Delete Mom\'s Account'.tr),
            content: Text(
              'Your account is scheduled for deletion in 60 days and will be reactivated automatically if you log in again within this period.'
                  .tr,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr),
              ),
              TextButton(
                onPressed: () {
                  _performDelete(context);
                },
                child: Text('Delete'.tr),
              ),
            ],
          ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Language".tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                title: const Text("English"),
                onTap: () {
                  Get.find<Homecontroller>().changeLanguage("en");
                  Get.back();
                },
              ),

              ListTile(
                title: const Text("Spanish"),
                onTap: () {
                  Get.find<Homecontroller>().changeLanguage("es");
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Help & Support'.tr),
            content: Text(
              'Help and support options will be implemented here.'.tr,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'.tr),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Mom\'s Milk'.tr,
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.child_care, color: Colors.white, size: 32),
      ),
      children: [
        Text(
          'A comprehensive app for mothers to track baby care and connect with milk donors.'
              .tr,
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 24),
              SizedBox(width: 12),
              Text('Logout'.tr),
            ],
          ),
          content: Text(
            'Are you sure you want to logout? You will need to sign in again to access your account.'
                .tr,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Logout'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDelete(BuildContext context) async {
    try {
      // Show loading indicator
      Get.dialog(
        Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Account Delete'.tr),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Clear user data from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('USERKEY');
      await prefs.remove('AUTHKEY');

      // Clear the global user variable (reset to an empty instance)
      user = UserModel();

      // Close loading dialog
      Get.back();
      await Get.deleteAll();
      // Navigate to authentication screen and clear all previous routes
      Get.offAll(
        () => Authenticationscreen(),
        transition: Transition.fadeIn,
        duration: Duration(milliseconds: 300),
      );

      // Show success message
      // Get.snackbar(
      //   'Success',
      //   'You account have been deleted successfully',
      //   backgroundColor: Colors.green,
      //              colorText: Colors.black,

      //   duration: Duration(seconds: 2),
      // );
    } catch (e) {
      // Close loading dialog if it's still showing
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error message
      Get.snackbar(
        'Error'.tr,
        'Failed to delete. Please try again.'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.black,

        duration: Duration(seconds: 3),
      );
    }
  }
}

Future<void> _performLogout(BuildContext context) async {
  try {
    // Show loading indicator
    Get.dialog(
      Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Logging out...'.tr),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Clear user data from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('USERKEY');
    await prefs.remove('AUTHKEY');

    // Clear the global user variable (reset to an empty instance)
    user = UserModel();

    // Close loading dialog
    Get.back();
    await Get.deleteAll();
    // Navigate to authentication screen and clear all previous routes
    Get.offAll(
      () => Authenticationscreen(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );

    // Show success message
    Get.snackbar(
      'Success'.tr,
      'You have been logged out successfully'.tr,
      backgroundColor: Colors.green,
      colorText: Colors.black,

      duration: Duration(seconds: 2),
    );
  } catch (e) {
    // Close loading dialog if it's still showing
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    // Show error message
    Get.snackbar(
      'Error'.tr,
      'Failed to logout. Please try again.'.tr,
      backgroundColor: Colors.red,
      colorText: Colors.black,

      duration: Duration(seconds: 3),
    );
  }
}

Widget buildUserTypeSection(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).primaryColor.withOpacity(.1),
      border: Border.all(color: AppTheme.borderColor, width: 1.5),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),

          // Show switch only for DONOR
          if (user.userType == "DONOR".tr) ...[
            GetBuilder<Homecontroller>(
              builder:
                  (controller) => SwitchListTile(
                    title: Text(
                      'Available for Donations'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Allow others to see your donation availability'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // ----------------------------
                    // 🔥 PINK THEMED SWITCH COLORS
                    // ----------------------------
                    activeColor: Colors.white,
                    activeTrackColor: Colors.pink,
                    inactiveThumbColor: Colors.pink,
                    inactiveTrackColor: Colors.pinkAccent.shade100,

                    value: user.isAvailable ?? false,

                    onChanged: (value) async {
                      user.isAvailable = value;
                      controller.update();

                      ApiService.request(
                        endpoint: "/requests/availability",
                        body: {"isAvailable": value},
                        method: Api.PATCH,
                      );
                    },

                    contentPadding: EdgeInsets.zero,
                  ),
            ),
          ],
        ],
      ),
    ),
  );
}
