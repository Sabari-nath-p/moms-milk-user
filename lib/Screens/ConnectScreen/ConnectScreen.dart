import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Views/HRequestCard.dart';

// IMPORT the actual screens
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/SearchDonarScreen.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<Homecontroller>(
        builder: (controller) => Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(
            title: const Text(
              "Connections",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
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
    }

    return Column(
      children: [
        const SizedBox(height: 12),

        // TAB SLIDER
        HRequestCard(controller: controller),
        const SizedBox(height: 16),

        // TAB CONTENT
        Expanded(
          child: controller.connectionTabIndex == 0
              ? RequestScreen()          // ← seen INSIDE same page
              : Searchdonarscreen(),     // ← seen INSIDE same page
        ),
      ],
    );
  }
}
