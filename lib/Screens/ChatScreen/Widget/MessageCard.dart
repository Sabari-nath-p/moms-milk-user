import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class MessageCard extends StatelessWidget {
  bool isSented;
  bool isRead;
  String messageTime;
  String message;
  MessageCard({
    super.key,
    required this.isSented,
    required this.isRead,
    required this.messageTime,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          (isSented) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
          constraints: BoxConstraints(
            maxWidth: 300.w,
            minWidth: 80.w,
            minHeight: 30.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
              bottomLeft: isSented ? Radius.circular(10.r) : Radius.circular(0),
              bottomRight: !isSented ? Radius.circular(10.r) : Radius.circular(0),
            ),
            color:
                (isSented)
                    ? AppTheme.primaryColor.withOpacity(.1)
                    : Colors.black26.withOpacity(.05),
          ),
          child: Text(message, style: TextStyle(fontSize: 14.sp)),
        ),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment:
              (isSented) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              DateFormat(
                "dd-MM-yy | hh:mm a",
              ).format(DateTime.parse(messageTime)),
              style: TextStyle(fontSize: 10.sp),
            ),
            SizedBox(width: 5.w),
            if (isSented)
              FaIcon(
                FontAwesomeIcons.check,
                color: (isRead) ? Colors.blue : Colors.black45,
                size: 10.sp,
              ),

            if (isSented && isRead)
              FaIcon(
                FontAwesomeIcons.check,
                color: (isRead) ? Colors.blue : Colors.black45,
                size: 10.sp,
              ),
          ],
        ),
      ],
    );
  }
}
