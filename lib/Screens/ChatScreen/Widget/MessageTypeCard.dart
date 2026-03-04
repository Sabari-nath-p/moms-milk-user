import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Models/ChatModel.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class MessageTypeCard extends StatelessWidget {
  MessageTypeCard({super.key});

  Chatcontroller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 20, right: 12),
      child: Row(
        children: [
          //  FaIcon(FontAwesomeIcons.keyboard, color: Colors.black45),
          // SizedBox(width: 20),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(.05),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(.1),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(maxHeight: 50, minHeight: 45),
              child: TextField(
                controller: ctrl.messageText,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  hintStyle: TextStyle(fontSize: 13),
                  hintText: "Enter Message".tr,
                  isDense: true,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),

          InkWell(
            onTap: () {
              if (ctrl.messageText.text.isNotEmpty) {
                ctrl.sentMessage(ctrl.messageText.text);
                ctrl.messageText.text = "";
              }
            },
            child: Icon(Icons.send, color: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }
}
