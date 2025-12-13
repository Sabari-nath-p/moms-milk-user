import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Views/ChatListCard.dart';
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
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 21),
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(.05),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(.1),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.search,
                    color: Colors.black54,
                    size: 18,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintStyle: TextStyle(fontSize: 15),
                        hintText: "Search Connected Parent",
                        isDense: true,
                      ),
                    ),
                  ),

                  FaIcon(
                    FontAwesomeIcons.circleArrowRight,
                    color: AppTheme.primaryColor.withOpacity(.4),
                    size: 18,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 25),
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
