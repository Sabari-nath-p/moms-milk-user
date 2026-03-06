import 'package:flutter/material.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 60),

                    // Enhanced Logo Section
                    _buildLogoSection(context),

                    SizedBox(height: 50),

                    // Enhanced Auth Form
                    _buildAuthForm(context, controller),

                    SizedBox(height: 40),

                    // Professional Footer
                    _buildFooter(context),
                    SizedBox(height: 30),
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
          width: 120,
          height: 120,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppTheme.buttonCardGradient,
            borderRadius: BorderRadius.circular(30),
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

        SizedBox(height: 25),

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

        SizedBox(height: 10),

        // Enhanced Subtitle
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: AppTheme.CardGradient,
            borderRadius: BorderRadius.circular(20),
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
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.CardGradient,
        borderRadius: BorderRadius.circular(24),
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
                SizedBox(height: 8),
                Text(
                  'Sign in to continue your journey'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Color(0xFF6A7282),
                    fontSize: 13,
                  ),

                  textAlign: TextAlign.center,
                ),
              ],
            ),

          SizedBox(height: 20),

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
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onBackground.withOpacity(0.8),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                    fontSize: 12,
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
                borderRadius: BorderRadius.circular(16),
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
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  //  labelText: 'Email Address',
                  hintText: 'Enter your email address'.tr,
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
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

            SizedBox(height: 15),

            // Enhanced Send OTP Button
            Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:
                    controller.isLoading
                        ? SizedBox(
                          height: 24,
                          width: 24,
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
                              size: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Send OTP'.tr,
                              style: TextStyle(
                                fontSize: 16,
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
            SizedBox(height: 4),
            Text(
              controller.emailController.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF43F5E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Enhanced OTP Input
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                  fontSize: 20,
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
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
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
            SizedBox(height: 20),

            // Enhanced Verify Button
            Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:
                    controller.isLoading
                        ? SizedBox(
                          height: 24,
                          width: 24,
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
                              size: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Verify & Continue'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
              ),
            ),

            SizedBox(height: 10),
            InkWell(
              onTap: () {
                controller.isOtpSent = false;
                controller.update();
              },
              child: Center(
                child: Text(
                  "Change Email".tr,
                  style: TextStyle(
                    fontSize: 13,
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
