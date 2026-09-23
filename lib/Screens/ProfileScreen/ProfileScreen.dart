import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mommilk_user/Models/UserModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/HBabyListCard.dart';
import 'package:mommilk_user/Screens/MarketScreen/MyListingScreen.dart';
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
        builder: (controller) => Scaffold(
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
                fontSize: 20.sp,
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
                  padding: EdgeInsets.all(16.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildUserCard(context),
                      SizedBox(height: 20.h),
                      if (user.userType == "DONOR")
                        buildUserTypeSection(context),
                      SizedBox(height: 20.h),
                      HBabyCard(),

                      SizedBox(height: 20.h),

                      _buildSettingsSection(context),
                      SizedBox(height: 20.h),

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
      borderRadius: BorderRadius.circular(16.r),
      gradient: AppTheme.CardGradient,
      border: Border.all(
        color: AppTheme.borderColor,
        width: 1.5.w,
      ),
    ),
    child: Stack(
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 28.h,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    gradient: AppTheme.buttonCardGradient,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: (user.profilePhoto != null &&
                            user.profilePhoto!.isNotEmpty)
                        ? Image.network(
                            user.profilePhoto!,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person,
                              size: 40.sp,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 40.sp,
                            color: Colors.white,
                          ),
                  ),
                ),

             SizedBox(height: 16.h),

                // User Name
                Text(
                  user.name ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

             SizedBox(height: 4.h),

                // User Email
                Text(
                  user.email ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),

        // Edit Button
        Positioned(
          top: 10.h,
          right: 10.w,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppTheme.buttonCardGradient,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: IconButton(
              onPressed: () =>
                  _showEditProfileDialog(context),
              icon:  Icon(
                Icons.edit,
                size: 16.sp,
                color: Colors.white,
              ),
              constraints:  BoxConstraints(
                minWidth: 24.sp,
                minHeight: 24.sp,
              ),
              padding: EdgeInsets.zero,
              tooltip: 'Edit Profile'.tr,
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _buildSettingsSection(
    BuildContext context,
    // HomeController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Theme.of(context).primaryColor.withOpacity(.05),
        border: Border.all(color: Color(0xFFFFE4E6), width: 1.5.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings'.tr,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.h),

            _buildSettingItem(
              context,
              'My Listings'.tr,
              'Manage your marketplace items'.tr,
              Icons.inventory_2_outlined,
              () {
                Get.to(() => MyListingsScreen());
              },
            ),

            Divider(height: 24.h),
            _buildSettingItem(
              context,
              'Language'.tr,
              'Choose your preferred language'.tr,
              Icons.language,
              () {
                _showLanguageDialog(context);
              },
            ),
            Divider(height: 24.h),
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
            Divider(height: 24.h),
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
            Divider(height: 24.h),
            _buildSettingItem(
              context,
              'Help & Support'.tr,
              'Get help and contact support'.tr,
              Icons.help,
              () {
                launchUrl(Uri.parse("https://momsmilk.app/privacy-policy"));
              },
            ),
            Divider(height: 24.h),
            _buildSettingItem(
              context,
              'Delete Account'.tr,
              'Delete your mom\'s account'.tr,
              Icons.delete,
              () {
                _showDeleteAccount(context);
              },
            ),
            Divider(height: 24.h),
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
        borderRadius: BorderRadius.circular(8.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: settingColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: settingColor, size: 20.sp),
              ),
              SizedBox(width: 12.w),
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
        borderRadius: BorderRadius.circular(16.r),
        color: Theme.of(context).primaryColor.withOpacity(.05),
        border: Border.all(color: Color(0xFFFFE4E6), width: 1.5.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Information'.tr,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.h),
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
            SizedBox(height: 12.h),
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
            SizedBox(height: 20.h),
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
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
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

  Future<void> _pickProfilePhoto(
    BuildContext context,
    Homecontroller controller,
  ) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera_outlined),
                title: Text('Take a photo'.tr),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library_outlined),
                title: Text('Choose from gallery'.tr),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 60,
    );
    if (picked == null) return;

    await controller.updateProfilePhoto(File(picked.path));
  }

  static const Color _pink = Color(0xFFFB7185);

  InputDecoration _editFieldDecoration(String label) => InputDecoration(
    labelText: label,
    isDense: true,
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: _pink, width: 1.5.w),
    ),
  );

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: user.name ?? '');
    final emailController = TextEditingController(text: user.email ?? '');
    final phoneController = TextEditingController(text: user.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20.w,
            0,
            20.w,
            MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Edit Profile'.tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: 22.sp),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              GetBuilder<Homecontroller>(
                builder: (controller) => Center(
                  child: GestureDetector(
                    onTap: controller.isUploadingProfilePhoto
                        ? null
                        : () => _pickProfilePhoto(context, controller),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40.r,
                          backgroundColor: Colors.grey[200],
                          child: ClipOval(
                            child: controller.isUploadingProfilePhoto
                                ? SizedBox(
                                    width: 40.w,
                                    height: 40.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.w,
                                      color: _pink,
                                    ),
                                  )
                                : (user.profilePhoto != null &&
                                          user.profilePhoto!.isNotEmpty)
                                ? Image.network(
                                    user.profilePhoto!,
                                    width: 80.w,
                                    height: 80.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.person_outline,
                                      size: 40.sp,
                                      color: Colors.grey[500],
                                    ),
                                  )
                                : Icon(
                                    Icons.person_outline,
                                    size: 40.sp,
                                    color: Colors.grey[500],
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(5.sp),
                            decoration: BoxDecoration(
                              color: AppTheme.buttonCardGradient.colors.first,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.w),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: _editFieldDecoration('Name'.tr),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: _editFieldDecoration('Email'.tr),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: phoneController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
                decoration: _editFieldDecoration('Phone'.tr),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: GetBuilder<Homecontroller>(
                        builder: (controller) => ElevatedButton(
                          onPressed: controller.isSavingProfile
                              ? null
                              : () async {
                                  final name = nameController.text.trim();
                                  final email = emailController.text.trim();
                                  final phone = phoneController.text.trim();
                                  if (name.isEmpty || email.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: 'Name and email are required'.tr,
                                    );
                                    return;
                                  }
                                  await controller.updateProfile(
                                    name: name,
                                    email: email,
                                    phone: phone,
                                  );
                                  Navigator.pop(context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pink,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: controller.isSavingProfile
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.w,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Save'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      builder: (context) => AlertDialog(
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
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Language".tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20.h),

              ListTile(
                title: Text("English".tr),
                onTap: () {
                  Get.find<Homecontroller>().changeLanguage("English");
                  Get.back();
                },
              ),

              ListTile(
                title: Text("Spanish".tr),
                onTap: () {
                  Get.find<Homecontroller>().changeLanguage("Spanish");
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
      builder: (context) => AlertDialog(
        title: Text('Help & Support'.tr),
        content: Text('Help and support options will be implemented here.'.tr),
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
      applicationVersion: '1.0.7',
      applicationIcon: Container(
        width: 64.w,
        height: 64.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.child_care, color: Colors.white, size: 32.sp),
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
              Icon(Icons.logout, color: Colors.red, size: 24.sp),
              SizedBox(width: 12.w),
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
              padding: EdgeInsets.all(20.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.h),
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
      Fluttertoast.showToast(msg: 'Failed to delete. Please try again.'.tr);
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
            padding: EdgeInsets.all(20.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.h),
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
    Fluttertoast.showToast(msg: 'You have been logged out successfully'.tr);
  } catch (e) {
    // Close loading dialog if it's still showing
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    // Show error message
    Fluttertoast.showToast(msg: 'Failed to logout. Please try again.'.tr);
  }
}

Widget buildUserTypeSection(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      color: Theme.of(context).primaryColor.withOpacity(.1),
      border: Border.all(color: AppTheme.borderColor, width: 1.5.w),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // Show switch only for DONOR
          if (user.userType == "DONOR") ...[
            GetBuilder<Homecontroller>(
              builder: (controller) => SwitchListTile(
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
                    fontSize: 12.sp,
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
