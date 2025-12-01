import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/SearchDonarScreen.dart';

class HRequestCard extends StatelessWidget {
  const HRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color textColor = const Color(0xFFE11D48);
    final Color backgroundColor = const Color(0xFFFFE4E6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // My Connection Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => RequestScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'My Connection',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Find Donors Button (if not a donor)
              if (user.userType != "DONOR")
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => Searchdonarscreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Find Donors',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
