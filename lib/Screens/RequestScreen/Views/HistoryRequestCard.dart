import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Models/RequestModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class HistoryRequestCard extends StatelessWidget {
  RequestModel request;
  HistoryRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      // color: Theme.of(context).primaryColor.withOpacity(.1),
      elevation: .2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Title and Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.title ?? 'No Title'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        request.description ?? 'No description available'.tr,
                        style: TextStyle(color: Colors.black54, fontSize: 14.sp),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: getStatusColor(request.status ?? 'pending'),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    (request.status ?? 'pending')
                        .toLowerCase()
                        .tr
                        .toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Info Row
            Row(
              children: [
                Icon(Icons.person, size: 16.sp, color: Colors.black54),
                SizedBox(width: 4.w),
                Text(
                  request.requester?.name ?? 'Unknown'.tr,
                  style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                ),
                SizedBox(width: 16.w),
                Icon(Icons.schedule, size: 16.sp, color: Colors.black54),
                SizedBox(width: 4.w),
                Text(
                  formatDate(request.createdAt ?? ''),
                  style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                ),
                Spacer(),
                if (false)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: getUrgencyColor(
                        request.urgency ?? 'low',
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: getUrgencyColor(request.urgency ?? 'low'),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      (request.urgency ?? 'low').toUpperCase(),
                      style: TextStyle(
                        color: getUrgencyColor(request.urgency ?? 'low'),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 8.h),

            // Bottom Row with Quantity
            Row(
              children: [
                Icon(Icons.local_drink, size: 16.sp, color: Colors.black54),
                SizedBox(width: 4.w),
                Text(
                  '${request.quantity ?? 0} ml',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),

                if (request.status != "PENDING")
                  InkWell(
                    onTap: () {
                      Chatcontroller ctrl = Get.find();

                      ctrl.OpenChatUser(
                        userID: request.requester!.id ?? 0,
                        isDonar: true,
                        userName: request.requester!.name ?? "N/A",
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        "Send a message".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
