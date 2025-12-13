import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/HRequestCard.dart';
import 'package:mommilk_user/Screens/RequestScreen/Controller/RequestController.dart';

// IMPORT the actual screens
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/SearchDonarScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<Homecontroller>(
        builder:
            (controller) => Scaffold(
              backgroundColor: Colors.white,

              appBar: AppBar(
                title: const Text(
                  "Connections",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  if (user.userType == "BUYER")
                    InkWell(
                      onTap: () {
                        Requestcontroller ctrl = Get.put(Requestcontroller());
                        ctrl.fetchMyRequests();
                        Get.to(
                          RequestScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Icon(
                        Icons.person_search,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  SizedBox(width: 20),
                ],
              ),

              body: _buildBody(context, controller),
            ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Homecontroller controller) {
    // If DONOR → only show My Connections
    if (user.userType == "DONOR") {
      controller.connectionTabIndex = 0;
    } else {
      controller.connectionTabIndex = 1;
    }

    return Column(
      children: [
        //   const SizedBox(height: 12),

        // TAB SLIDER
        //HRequestCard(controller: controller),
        // const SizedBox(height: 16),a

        // TAB CONTENT
        Expanded(
          child:
              controller.connectionTabIndex == 0
                  ? RequestScreen() // ← seen INSIDE same page
                  : Searchdonarscreen(), // ← seen INSIDE same page
        ),
      ],
    );
  }
}
