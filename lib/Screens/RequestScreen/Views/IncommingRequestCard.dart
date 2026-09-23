import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Models/RequestModel.dart';
import 'package:mommilk_user/Screens/RequestScreen/Controller/RequestController.dart';
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class IncommingRequestCard extends StatelessWidget {
  RequestModel request;
  Requestcontroller controller;
  IncommingRequestCard({
    super.key,
    required this.controller,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),

      elevation: .2,
      // color: Color(0xFFFFF0EC).withOpacity(1),
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Title and Urgency
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
                    color: getUrgencyColor(request.urgency ?? 'low'),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    (request.urgency ?? 'low').toUpperCase(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Requester and Time Info
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.blue.shade300, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_drink,
                        size: 14.sp,
                        color: Colors.blue.shade600,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${request.quantity ?? 0} ml',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.declineRequest(request.id ?? 0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Decline".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.acceptRequest(
                      request.id ?? 0,
                      requesterId: request.requester?.id,
                      requesterName: request.requester?.name,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Accept".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
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
