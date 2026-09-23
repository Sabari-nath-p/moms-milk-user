import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';

class MessageTitleCard extends StatelessWidget {
  MessageTitleCard({super.key});
  Chatcontroller ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w, top: 20.h),

      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          SizedBox(width: 5.w),

          InkWell(
            onTap: () {
              ctrl.currentUser = -1;
              ctrl.currentUserName = "";
              Get.back();
            },
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.grey.withOpacity(0.08),
              child: FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.black,
                size: 18.sp,
              ),
            ),
          ),
          SizedBox(width: 5.w),
          CircleAvatar(
            radius: 30.r,
            child: Text(
              ctrl.currentUserName.substring(0, 2),
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
                  ctrl.currentUserName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
                Text(
                  (ctrl.isDonar) ? "Milk Donar".tr : "Milk Recipient".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
