import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/ChatScreen/Widget/MessageCard.dart';
import 'package:mommilk_user/Screens/ChatScreen/Widget/MessageTitleCard.dart';
import 'package:mommilk_user/Screens/ChatScreen/Widget/MessageTypeCard.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  Chatcontroller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        ctrl.currentUser = -1;
        ctrl.currentUserName = "";
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<Chatcontroller>(
            builder: (__) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MessageTitleCard(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        reverse: true,
                        controller: __.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 20,
                          children: [
                            SizedBox(height: 20),

                            for (var data in __.messageList)
                              MessageCard(
                                isRead: data.isRead,
                                isSented: data.senderId == user.id,
                                message: data.content,
                                messageTime:
                                    data.createdAt.toLocal().toString(),
                              ),

                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MessageTypeCard(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
