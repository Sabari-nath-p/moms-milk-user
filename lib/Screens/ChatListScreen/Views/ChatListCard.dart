import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Models/SessionModel.dart';
import 'package:mommilk_user/Screens/ChatScreen/ChatScreen.dart';

class ChatListCard extends StatelessWidget {
  ChatSession session;
  ChatListCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 26),
      padding: EdgeInsets.symmetric(horizontal: 21),
      child: InkWell(
        onTap: () {
          Chatcontroller ctrl = Get.find();
          ctrl.OpenChatUser(
            userID: session.otherUser!.id!,
            isDonar: session.otherUser!.userType != "BUYER",
            session: session.id,
            userName: session.otherUser!.name ?? "N/A",
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              child: Text(
                session.otherUser!.name.substring(0, 2).toUpperCase(),
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    session.otherUser!.name,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color:
                          session.unreadCount != 0
                              ? Colors.black
                              : Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            (session.lastMessage == null)
                                ? ""
                                : session.lastMessage!.content!,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color:
                                  session.unreadCount != 0
                                      ? Colors.black
                                      : Colors.black45,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        CircleAvatar(
                          radius: 2,
                          backgroundColor: Colors.black26,
                        ),
                        SizedBox(width: 5),
                        Text(
                          (session.lastMessageAt == null)
                              ? ""
                              : DateFormat(
                                "hh:mm a",
                              ).format(session.lastMessageAt!.toLocal()),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color:
                                session.unreadCount != 0
                                    ? Colors.black
                                    : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              alignment: Alignment.center,
              child: Visibility(
                visible: session.unreadCount != 0,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 12,
                  child: Text(
                    session.unreadCount.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
