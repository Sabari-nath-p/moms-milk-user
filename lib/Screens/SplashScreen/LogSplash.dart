// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:mommilk_user/Screens/AuthenticationScreen/AuthenticationScreen.dart';
// import 'package:mommilk_user/Screens/SplashScreen/SplashScreen2.dart';

// class SplashScreen extends StatelessWidget {
//   SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFF6F3),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             /// Skip
//             Align(
//               alignment: Alignment.topRight,
//               child: Padding(
//                 padding: EdgeInsets.only(right: 16),
//                 child: TextButton(
//                   onPressed: () {
//                     // Navigate to Authentication Screen using GetX
//                     Get.offAll(() => SplashScreen2());
//                   },
//                   child: Text(
//                     "Skip".tr,
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//             ),

//             /// Phone Mock Image (FIXED)
//             Container(
//               width: 230,
//               height: 435, // 🔽 reduced height
//               child: Image.asset("lib/Assets/logsplash.png", fit: BoxFit.cover),
//             ),

//             SizedBox(height: 30.h), // 🔽 reduced spacing
//             /// Pills
//             Container(
//               width: 220.w,
//               height: 35.h,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 children: [
//                   _Pill(icon: Icons.add, label: "Log", active: true),
//                   SizedBox(width: 12),
//                   _Pill(icon: Icons.receipt_long, label: "Report"),
//                   SizedBox(width: 12),
//                   _Pill(icon: Icons.favorite_border, label: "Connect"),
//                 ],
//               ),
//             ),

//             SizedBox(height: 22),

//             /// Title
//             Text(
//               "Nourishing Every Baby".tr,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
//             ),

//             SizedBox(height: 10),

//             /// Subtitle
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               child: Text(
//                 "A caring platform designed to support babies with safe milk sharing and daily care tracking.".tr,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 15, color: Colors.black54),
//               ),
//             ),

//             SizedBox(height: 10),

//             /// Dots Indicator (STATIC)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [_dot(active: true), _dot(), _dot()],
//             ),

//             SizedBox(height: 15),

//             /// Get Started Button (UI ONLY)
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               child: SizedBox(
//                 height: 56,
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Get.offAll(() => Authenticationscreen());
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     "Get Started".tr,
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Individual Pill Widget
// class _Pill extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool active;

//   _Pill({required this.icon, required this.label, this.active = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 9.h),
//       decoration: BoxDecoration(
//         color:
//             active ? Color(0xFFFF6B6B).withOpacity(0.15) : Colors.white,
//         borderRadius: BorderRadius.circular(26),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 20,
//             color: active ? Color(0xFFFF6B6B) : Colors.grey,
//           ),
//           SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: active ? Color(0xFFFF6B6B) : Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Dot Widget
// Widget _dot({bool active = false}) {
//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 4),
//     width: active ? 22 : 8,
//     height: 8,
//     decoration: BoxDecoration(
//       color: active ? Color(0xFFFF6B6B) : Colors.grey.shade300,
//       borderRadius: BorderRadius.circular(10),
//     ),
//   );
// }
