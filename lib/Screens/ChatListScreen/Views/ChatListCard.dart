import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      margin: EdgeInsets.only(bottom: 26.h),
      padding: EdgeInsets.symmetric(horizontal: 21.w),
      child: InkWell(
        onTap: () {
          Chatcontroller ctrl = Get.find();
          ctrl.OpenChatUser(
            userID: session.otherUser!.id!,
            isDonar: session.otherUser!.userType != "BUYER",
            session: session.id,
            userName: session.otherUser!.name ?? "N/A".tr,
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              child: Text(
                session.otherUser!.name.substring(0, 2).toUpperCase(),
                style: TextStyle(fontSize: 18.sp, color: Colors.white),
              ),
            ),
            SizedBox(width: 10.w),
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
                      fontSize: 16.sp,
                      color:
                          session.unreadCount != 0
                              ? Colors.black
                              : Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            (session.lastMessage == null)
                                ? ""
                                : session.lastMessage!.content!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color:
                                  session.unreadCount != 0
                                      ? Colors.black
                                      : Colors.black45,
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        CircleAvatar(
                          radius: 2.r,
                          backgroundColor: Colors.black26,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          (session.lastMessageAt == null)
                              ? ""
                              : DateFormat(
                                "hh:mm a",
                              ).format(session.lastMessageAt!.toLocal()),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
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
              width: 50.w,
              alignment: Alignment.center,
              child: Visibility(
                visible: session.unreadCount != 0,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 12.r,
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
