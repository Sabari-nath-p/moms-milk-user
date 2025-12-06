import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/ConnectScreen/ConnectScreen.dart';
import 'package:mommilk_user/Screens/ChatScreen/ChatScreen.dart';
import 'package:mommilk_user/Screens/Dashboard/Controller/DashboardController.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Screens/ProfileScreen/ProfileScreen.dart';
import 'package:mommilk_user/Screens/TrackerScreen/TrackerScreen.dart';
import 'package:mommilk_user/Utils/Constants.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());

    return GetBuilder<DashboardController>(
      builder: (controller) {
        Widget currentScreen;

        // Each screen has its own Scaffold with AppBar
        switch (controller.selectedMenu) {
          case 0:
            currentScreen = Homescreen(); // Homescreen should have its own AppBar
            break;
          case 1:
            currentScreen = Trackerscreen(); // TrackerScreen should have its own AppBar
            break;
          case 2:
            currentScreen = ConnectScreen(); // BabyScreen should have its own AppBar
            break;
          case 3:
            currentScreen = ProfileScreen(); // ProfileScreen should have its own AppBar
            break;
            case 4:
            currentScreen = ChatScreen(); // ProfileScreen should have its own AppBar
            break;
          default:
            currentScreen = Container();
        }

        return Scaffold(
          body: currentScreen,
       bottomNavigationBar: NavigationBarTheme(
  data: NavigationBarThemeData(
    // Selected label color
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: Color(0xffFB7185),
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        );
      },
    ),
  ),
  child: NavigationBar(
    selectedIndex: controller.selectedMenu,
    onDestinationSelected: (index) {
      controller.selectedMenu = index;
      controller.update();
    },

    backgroundColor: const Color(0xFFFDF2F6),
    indicatorColor: const Color(0xFFFFE4EA),
    elevation: 0,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined, color: Colors.grey),
        selectedIcon: Icon(Icons.home, color: Color(0xffFB7185)),
        label: 'Log',
      ),

      NavigationDestination(
        icon: Icon(Icons.analytics_outlined, color: Colors.grey),
        selectedIcon: Icon(Icons.analytics, color: Color(0xffFB7185)),
        label: 'Report',
      ),

      NavigationDestination(
        icon: Icon(Icons.child_care_outlined, color: Colors.grey),
        selectedIcon: Icon(Icons.child_care, color: Color(0xffFB7185)),
        label: 'Connect',
      ),

      NavigationDestination(
        icon: Icon(Icons.child_care_outlined, color: Colors.grey),
        selectedIcon: Icon(Icons.child_care_outlined, color: Color(0xffFB7185)),
        label: 'Babies',
      ),
      NavigationDestination(
        icon: Icon(Icons.notes, color: Colors.grey),
        selectedIcon: Icon(Icons.notes, color: Color(0xffFB7185)),
        label: 'Chat',
      ),
    ],
  ),
),
        );
      },
    );
  }
}   