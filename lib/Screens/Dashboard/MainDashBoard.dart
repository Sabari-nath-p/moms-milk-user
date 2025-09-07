import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AnalyticsScreen/AnalyticsScreen.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/BabyScreen/BabyScreen.dart';
import 'package:mommilk_user/Screens/Dashboard/Controller/DashboardController.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Screens/ProfileScreen/ProfileScreen.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          appBar: AppBar(
            centerTitle: false,
            title: Text('Moms Milks'),
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: [
              user.userType == 'DONAR'
                  ? IconButton(
                    onPressed: () {},
                    icon: Icon(
                      user.isAvailable ?? false
                          ? Icons.toggle_on
                          : Icons.toggle_off,
                      color:
                          user.isAvailable ?? false
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).disabledColor,
                      size: 32,
                    ),
                    tooltip:
                        user.isAvailable ?? false
                            ? 'Available for donations'
                            : 'Not available',
                  )
                  : const SizedBox.shrink(),

              IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
            ],
          ),

          body:
              (controller.selectedMenu == 0)
                  ? Homescreen()
                  : (controller.selectedMenu == 1)
                  ? const AnalyticsScreen()
                  : (controller.selectedMenu == 2)
                  ? BabyScreen()
                  : (controller.selectedMenu == 3)
                  ? ProfileScreen()
                  : Container(),

          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.selectedMenu,
            onDestinationSelected: (index) {
              controller.selectedMenu = index;
              controller.update();
            },
            destinations: _destinations,
            elevation: 8,
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.2),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
        );
      },
    );
  }
}

final List<NavigationDestination> _destinations = [
  const NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: 'Home',
  ),
  const NavigationDestination(
    icon: Icon(Icons.analytics_outlined),
    selectedIcon: Icon(Icons.analytics),
    label: 'Analytics',
  ),
  const NavigationDestination(
    icon: Icon(Icons.child_care_outlined),
    selectedIcon: Icon(Icons.child_care),
    label: 'Babies',
  ),
  const NavigationDestination(
    icon: Icon(Icons.person_outline),
    selectedIcon: Icon(Icons.person),
    label: 'Profile',
  ),
];
