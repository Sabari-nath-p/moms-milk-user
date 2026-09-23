import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Utils/Constants.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class Authenticationscreen extends StatelessWidget {
  Authenticationscreen({super.key});
  AuthenticationController controller = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFFFF0EC).withOpacity(1),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: GetBuilder<AuthenticationController>(
            builder: (controller) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0.w,
                  vertical: 20.0.h,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 60.h),

                    // Enhanced Logo Section
                    _buildLogoSection(context),

                    SizedBox(height: 50.h),

                    // Enhanced Auth Form
                    _buildAuthForm(context, controller),

                    SizedBox(height: 40.h),

                    // Professional Footer
                    _buildFooter(context),
                    SizedBox(height: 30.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return Column(
      children: [
        // Enhanced Logo Container
        Container(
          width: 120.w,
          height: 120.h,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: AppTheme.buttonCardGradient,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 25,
                offset: Offset(0, 10),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(-5, -5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Image.asset(appIcon, color: Colors.white),
        ),

        SizedBox(height: 25.h),

        // Enhanced Title
        Center(
          child: Text(
            'Mom\'s Milk'.tr,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
        ),

        SizedBox(height: 10.h),

        // Enhanced Subtitle
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: AppTheme.CardGradient,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Connect. Share. Care.'.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthForm(
    BuildContext context,
    AuthenticationController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: AppTheme.CardGradient,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            blurRadius: 30,
            offset: Offset(0, 15),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced Header
          if (!controller.isOtpSent)
            Column(
              children: [
                Text(
                  'Join Our Community'.tr,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Color(0xFF1E2939),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sign in to continue your journey'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Color(0xFF6A7282),
                    fontSize: 13.sp,
                  ),

                  textAlign: TextAlign.center,
                ),
              ],
            ),

          SizedBox(height: 20.h),

          // Form Content
          !controller.isOtpSent
              ? _buildEmailForm(context, controller.emailController)
              : _buildOtpForm(context, controller.otpController),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Container(
          //  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          // decoration: BoxDecoration(
          //   color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
          //   borderRadius: BorderRadius.circular(16),
          //   border: Border.all(
          //     color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          //   ),
          // ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.security,
                size: 16.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onBackground.withOpacity(0.8),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailForm(
    BuildContext context,
    TextEditingController emailController,
  ) {
    return GetBuilder<AuthenticationController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Enhanced Email Input
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  //  labelText: 'Email Address',
                  hintText: 'Enter your email address'.tr,
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12.w),
                    child: Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22.sp,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ),

            SizedBox(height: 15.h),

            // Enhanced Send OTP Button
            Container(
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: AppTheme.roundButtonGradient,
                boxShadow:
                    controller.isLoading
                        ? []
                        : [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
              ),
              child: ElevatedButton(
                onPressed:
                    controller.isLoading
                        ? null
                        : () {
                          if (emailController.text.isNotEmpty) {
                            controller.sendOtp();
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Email id is required to send otp'.tr,
                            );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child:
                    controller.isLoading
                        ? SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            // valueColor: AlwaysStoppedAnimation<Color>(
                            //   Theme.of(context).colorScheme.onPrimary,
                            // ),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_rounded,
                              size: 20.sp,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Send OTP'.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOtpForm(
    BuildContext context,
    TextEditingController otpController,
  ) {
    return GetBuilder<AuthenticationController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Enhanced OTP Instructions
            Text(
              'Enter the 6-digit code sent to'.tr,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Color(0xFF1E2939)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              controller.emailController.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF43F5E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),

            // Enhanced OTP Input
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: otpController,

                // ✅ numeric keyboard
                keyboardType: TextInputType.phone,

                // ✅ show DONE button
                textInputAction: TextInputAction.done,

                // ✅ handle DONE press
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus(); // close keyboard

                  if (value.length == 6) {
                    controller.verifyOtp();
                  }
                },

                textAlign: TextAlign.center,
                maxLength: 6,

                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  hintText: '000000',
                  counterText: '',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                    letterSpacing: 8,
                  ),
                ),
              ),
            ),

            // Enhanced Resend Section
            SizedBox(height: 20.h),

            // Enhanced Verify Button
            Container(
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: AppTheme.roundButtonGradient,
                boxShadow:
                    controller.isLoading
                        ? []
                        : [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
              ),
              child: ElevatedButton(
                onPressed:
                    controller.isLoading
                        ? null
                        : () {
                          if (otpController.text.length == 6) {
                            controller.verifyOtp();
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child:
                    controller.isLoading
                        ? SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            // valueColor: AlwaysStoppedAnimation<Color>(
                            //   Theme.of(context).colorScheme.onPrimary,
                            // ),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_rounded,
                              size: 20.sp,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Verify & Continue'.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
              ),
            ),

            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                controller.isOtpSent = false;
                controller.update();
              },
              child: Center(
                child: Text(
                  "Change Email".tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
