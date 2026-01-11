import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Views/ChatListCard.dart';
import 'package:mommilk_user/Screens/Dashboard/Controller/DashboardController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Chatcontroller>(
      builder: (__) {
        return Column(
          children: [
            // Container(
            //   width: double.infinity,
            //   height: 50,
            //   margin: EdgeInsets.symmetric(horizontal: 21),
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     color: AppTheme.primaryColor.withOpacity(.05),
            //     border: Border.all(
            //       color: AppTheme.primaryColor.withOpacity(.1),
            //     ),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Row(
            //     children: [
            //       FaIcon(
            //         FontAwesomeIcons.search,
            //         color: Colors.black54,
            //         size: 18,
            //       ),
            //       SizedBox(width: 20),
            //       Expanded(
            //         child: TextField(
            //           textAlign: TextAlign.start,
            //           textAlignVertical: TextAlignVertical.center,
            //           decoration: InputDecoration(
            //             border: InputBorder.none,
            //             isCollapsed: true,
            //             hintStyle: TextStyle(fontSize: 15),
            //             hintText: "Search Connected Parent",
            //             isDense: true,
            //           ),
            //         ),
            //       ),

            //       FaIcon(
            //         FontAwesomeIcons.circleArrowRight,
            //         color: AppTheme.primaryColor.withOpacity(.4),
            //         size: 18,
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 25),

                    if (__.chatSessionList.isEmpty)
                      Container(
                        height: MediaQuery.of(context).size.height - 200,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("lib/Assets/AppIcon.png", width: 80),
                            SizedBox(height: 20),
                            (user.userType == "DONOR")
                                ? Text(
                                  "No buyer connected yet",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                                : Text(
                                  "Not connected with\nany donor",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                            if (user.userType != "DONOR")
                              Container(
                                width: 200,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.roundButtonGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    DashboardController controller = Get.put(
                                      DashboardController(),
                                    );
                                    controller.selectedMenu = 2;
                                    controller.update();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors
                                            .transparent, // remove default background
                                    shadowColor:
                                        Colors.transparent, // remove shadow
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.search,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Find Donors",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    for (var data in __.chatSessionList)
                      ChatListCard(session: data),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
