import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Models/RequestModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/RequestScreen/Controller/RequestController.dart';
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/Screens/RequestScreen/Views/contactBottomSheet.dart';

class MyRequestCard extends StatelessWidget {
  RequestModel request;
  Requestcontroller controller;
  MyRequestCard({super.key, required this.controller, required this.request});

  @override
  Widget build(BuildContext context) {
    final bool canContact =
        (request.status?.toLowerCase() ?? 'pending') == 'accepted' &&
        request.donor != null;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      color: Theme.of(context).primaryColor,

      elevation: .23,
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
                        request.title ?? 'No Title'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        request.description ?? 'No description available'.tr,
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
                      color: Colors.black87,
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
                Icon(Icons.schedule, size: 16, color: Colors.black54),
                SizedBox(width: 4),
                Text(
                  formatDate(request.createdAt ?? ''),
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                SizedBox(width: 16),
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

            // Contact Section for accepted requests
            if (canContact) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18, color: Colors.blue.shade600),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Donor Available',
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            request.donor?.name ?? 'Unknown Donor'.tr,
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Chatcontroller cctrl = Get.put(Chatcontroller());
                        cctrl.OpenChatUser(
                          userID: request.donor!.id!,
                          isDonar: true,
                          userName: request.donor!.name!!,
                        );
                        // ContactBottomSheet.show(
                        //   context,
                        //   name: request.donor!.name ?? "",
                        //   email: request.donor!.email ?? "",
                        //   phoneNumber: request.donor!.phone.toString(),
                        // );
                        //controller.contactUser(request);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Send a message'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
