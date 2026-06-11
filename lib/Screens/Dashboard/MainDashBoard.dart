import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/ConnectScreen/ConnectScreen.dart';
import 'package:mommilk_user/Screens/ChatListScreen/ChatScreen.dart';
import 'package:mommilk_user/Screens/Dashboard/Controller/DashboardController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/Market_screen.dart';
import 'package:mommilk_user/Screens/ProfileScreen/ProfileScreen.dart';
import 'package:mommilk_user/Screens/RequestScreen/Controller/RequestController.dart';
import 'package:mommilk_user/Screens/TrackerScreen/TrackerScreen.dart';
import 'package:mommilk_user/Utils/Constants.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class MainDashboard extends StatelessWidget {
  MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());

    return GetBuilder<DashboardController>(
      builder: (controller) {
        Widget currentScreen;

        switch (controller.selectedMenu) {
          case 0:
            currentScreen = Homescreen();
            break;
          case 1:
            currentScreen = MarketScreen();
            break;
          case 2:
            var rctrl = Get.put(Requestcontroller());
            // FIX #2528: Only fetch donor-specific requests when user is DONOR
            // Calling fetchIncomingRequests() for a BUYER causes backend to return
            // an error which shows as "Only donors can view incoming requests" snackbar
            if (user.userType == 'DONOR') {
              rctrl.fetchIncomingRequests();
              rctrl.fetchHistoryRequests();
            }
            currentScreen = ConnectScreen();
            break;
          case 3:
            currentScreen = ChatListScreen();
            break;
          case 4:
            currentScreen = ProfileScreen();
            break;
          default:
            currentScreen = Container();
        }

        return Scaffold(
          body: currentScreen,
          backgroundColor: Colors.white,
          appBar: (controller.selectedMenu != 0)
              ? (controller.selectedMenu == 3)
                    ? AppBar(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        centerTitle: true,
                        title: Text(
                          "My Connections".tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: "Inter",
                          ),
                        ),
                      )
                    : null
              : AppBar(
                  elevation: 0,
                  centerTitle: true,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "lib/Assets/fullIcon.png",
                        height: 200,
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  );
                }
                return TextStyle(
                  color: Colors.black.withOpacity(.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: controller.selectedMenu,
              onDestinationSelected: (index) {
                controller.selectedMenu = index;
                controller.update();
              },
              backgroundColor: Color(0xFFFFF0EC).withOpacity(1),
              indicatorColor: Color(0xFFFFE4EA),
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                  icon: FaIcon(
                    FontAwesomeIcons.add,
                    size: 20,
                    color: Colors.black.withOpacity(.5),
                  ),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.add,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  label: 'Log'.tr,
                ),
                NavigationDestination(
                  icon: FaIcon(
                    FontAwesomeIcons.squarePollVertical,
                    size: 20,
                    color: Colors.black.withOpacity(.3),
                  ),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.squarePollVertical,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  label: 'Market'.tr,
                ),
                NavigationDestination(
                  icon: GetBuilder<Homecontroller>(
                    builder: (__) => Badge(
                      label: Text(__.pendingRequest.toString()),
                      textStyle: TextStyle(fontSize: 10),
                      largeSize: 10,
                      smallSize: 10,
                      isLabelVisible: __.pendingRequest != 0,
                      child: Image.asset(
                        "lib/Assets/AppIcon.png",
                        width: 25,
                        color: Colors.black.withOpacity(.3),
                      ),
                    ),
                  ),
                  selectedIcon: Image.asset(
                    "lib/Assets/AppIcon.png",
                    width: 25,
                    color: AppTheme.primaryColor,
                  ),
                  label: 'Connect'.tr,
                ),
                NavigationDestination(
                  icon: GetBuilder<Chatcontroller>(
                    builder: (__) => Badge(
                      label: Text(__.unReadMessage.toString()),
                      textStyle: TextStyle(fontSize: 10),
                      largeSize: 10,
                      smallSize: 6,
                      isLabelVisible: __.unReadMessage != 0,
                      child: FaIcon(
                        FontAwesomeIcons.telegram,
                        size: 25,
                        color: Colors.black.withOpacity(.3),
                      ),
                    ),
                  ),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.telegram,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  label: 'Message'.tr,
                ),
                NavigationDestination(
                  icon: FaIcon(
                    FontAwesomeIcons.baby,
                    size: 20,
                    color: Colors.black.withOpacity(.3),
                  ),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.baby,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  label: 'Profile'.tr,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
