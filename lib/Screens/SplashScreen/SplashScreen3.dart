import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mommilk_user/Screens/SplashScreen/SplashScreen4.dart';

import '../AuthenticationScreen/AuthenticationScreen.dart';

class SplashScreen3 extends StatelessWidget {
  const SplashScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F3),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TextButton(
                  onPressed: () {
                    Get.offAll(() => SplashScreen4());
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),

            /// Phone Mock Image (FIXED)
            SizedBox(
              width: 350.w,
              height: 450.h,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    bottom: 60,
                    left: 0,
                    child: Image.asset(
                      "lib/Assets/splash3.1.png",
                      width: 230.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 80,
                    child: Image.asset(
                      "lib/Assets/splash3.png",
                      width: 230.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 140,
                    right: 10,
                    child: Image.asset(
                      "lib/Assets/splash3.2.png",
                      width: 105.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 350,
                    right: 10,
                    child: Image.asset(
                      "lib/Assets/splash3.3.png",
                      width: 115.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            /// Pills
            Container(
              width: 250.w,
              height: 35.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _Pill(
                    icon: FontAwesomeIcons.plus,
                    label: "Log",
                  ),
                  SizedBox(width: 10),
                  _Pill(
                    icon: FontAwesomeIcons.receipt,
                    label: "Report",
                  
                  ),
                  SizedBox(width: 10),
                  _Pill(
                    label: "Connect",
                    active: true,
                    image: Image.asset(
                      "lib/Assets/AppIcon.png",
                      width: 20,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(width: 10),
                  _Pill(
                    icon: FontAwesomeIcons.telegram,
                    label: "Message",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            /// Title
            const Text(
              "Connect with Milk Donors",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            /// Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Find trusted breast milk donors nearby and build a safe, supportive connection",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Dots Indicator (STATIC)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(active: true),
                _dot(),
                _dot(),
              ],
            ),

            SizedBox(height: 15),

            /// Get Started Button (UI ONLY)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 32.h,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => Authenticationscreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Individual Pill Widget
class _Pill extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool active;
  final Widget? image;

  const _Pill({
    this.icon,
    required this.label,
    this.active = false,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFFF6B6B).withOpacity(0.15)
            : Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 18,
              color: active ? const Color(0xFFFF6B6B) : Colors.grey,
            ),
          if (image != null) image!,
          if (icon != null || image != null) const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: active ? const Color(0xFFFF6B6B) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dot Widget
Widget _dot({bool active = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: active ? 22 : 8,
    height: 8,
    decoration: BoxDecoration(
      color: active ? const Color(0xFFFF6B6B) : Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
