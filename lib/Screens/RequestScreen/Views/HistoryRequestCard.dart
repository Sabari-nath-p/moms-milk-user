import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
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
                        request.title ?? 'No Title',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        request.description ?? 'No description available',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(request.status ?? 'pending'),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (request.status ?? 'pending').toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Info Row
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.black54),
                SizedBox(width: 4),
                Text(
                  request.requester?.name ?? 'Unknown',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: Colors.black54),
                SizedBox(width: 4),
                Text(
                  formatDate(request.createdAt ?? ''),
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                Spacer(),
                if (false)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getUrgencyColor(
                        request.urgency ?? 'low',
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: getUrgencyColor(request.urgency ?? 'low'),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      (request.urgency ?? 'low').toUpperCase(),
                      style: TextStyle(
                        color: getUrgencyColor(request.urgency ?? 'low'),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 8),

            // Bottom Row with Quantity
            Row(
              children: [
                Icon(Icons.local_drink, size: 16, color: Colors.black54),
                SizedBox(width: 4),
                Text(
                  '${request.quantity ?? 0} ml',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
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
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Sent a message",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
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
