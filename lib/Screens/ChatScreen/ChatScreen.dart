import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:get/state_manager.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/ChatScreen/Widget/MessageCard.dart';
import 'package:mommilk_user/Screens/ChatScreen/Widget/MessageTitleCard.dart';
import 'package:mommilk_user/Screens/ChatScreen/Widget/MessageTypeCard.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Chatcontroller ctrl = Get.find();

  @override
  void dispose() {
   
    ctrl.currentUser = -1;
    ctrl.currentUserName = "";
    ctrl.sessionID = -1;
    Get.back();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                              messageTime: data.createdAt.toLocal().toString(),
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
    );
  }
}
