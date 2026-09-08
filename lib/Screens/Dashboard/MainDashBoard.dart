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
import 'package:mommilk_user/Screens/HomeScreen/Views/HDashboardHome.dart';
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

    // Homecontroller / Chatcontroller used to get registered implicitly as a
    // side effect of Homescreen() being built on tab 0 (its field initializers
    // called Get.put on both). Now that HDashboardHome() renders tab 0 instead,
    // they're registered explicitly here so the bottom nav badges (Connect /
    // Message) and ConnectScreen / ChatListScreen — which read them via
    // GetBuilder without an init — always find them.
    if (!Get.isRegistered<Homecontroller>()) {
      Get.put(Homecontroller());
    }
    if (!Get.isRegistered<Chatcontroller>()) {
      Get.put(Chatcontroller());
    }

    return GetBuilder<DashboardController>(
      builder: (controller) {
        Widget currentScreen;

        switch (controller.selectedMenu) {
          case 0:
            // NOTE: Homescreen() (the original "Log" screen) is intentionally kept
            // in the codebase and untouched — HDashboardHome() now renders in its
            // place as the Buyer/Donor home dashboard.
            currentScreen = HDashboardHome();
            break;
          case 1:
            // Consume (and clear) any filter handed off by another screen
            // (e.g. Home dashboard's marketplace search / category chips)
            // via DashboardController.goToMarket() — so a later, plain
            // switch to this tab starts blank again.
            final pendingSearch = controller.pendingMarketSearch;
            final pendingCategory = controller.pendingMarketCategory;
            final pendingOpenFilter = controller.pendingOpenMarketFilter;
            controller.pendingMarketSearch = null;
            controller.pendingMarketCategory = null;
            controller.pendingOpenMarketFilter = false;
            currentScreen = MarketScreen(
              initialSearch: pendingSearch,
              initialCategory: pendingCategory,
              openFilterOnStart: pendingOpenFilter,
            );
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
          appBar: (controller.selectedMenu == 3)
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
              // HDashboardHome() (tab 0) renders its own "Mom's Milk" header +
              // notification bell, matching the approved design — no AppBar here.
              : null,
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
                    FontAwesomeIcons.house,
                    size: 20,
                    color: Colors.black.withOpacity(.5),
                  ),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.house,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  label: 'Home'.tr,
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

  /// Original logo AppBar previously shown for tab 0 ("Home"), before
  /// HDashboardHome() took over that tab with its own header. Kept, unused,
  /// per request instead of being deleted.
  AppBar _legacyLogoAppBar() {
    return AppBar(
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
    );
  }
}
