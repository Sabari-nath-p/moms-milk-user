import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Models/RequestModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/RequestScreen/Controller/RequestController.dart';
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class MyRequestCard extends StatelessWidget {
  RequestModel request;
  Requestcontroller controller;
  MyRequestCard({super.key, required this.controller, required this.request});

  static const Color _red = Color(0xFFE8453C);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'completed':
        return Color(0xFF16A34A);
      case 'declined':
      case 'cancelled':
        return Color(0xFFDC2626);
      default:
        return Color(0xFFF97316);
    }
  }

  Color _statusBg(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'completed':
        return Color(0xFFDCF7E3);
      case 'declined':
      case 'cancelled':
        return Color(0xFFFEE2E2);
      default:
        return Color(0xFFFFEEDC);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'completed':
        return Icons.check_circle;
      case 'declined':
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = request.status ?? 'pending';
    final bool canContact =
        status.toLowerCase() == 'accepted' && request.donor != null;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardGradientStart, width: 1),
      ),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      request.description ?? 'No description available'.tr,
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusBg(status),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _statusIcon(status),
                      size: 12,
                      color: _statusColor(status),
                    ),
                    SizedBox(width: 4),
                    Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: _statusColor(status),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Info Row
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: Colors.black54),
              SizedBox(width: 4),
              Text(
                formatDate(request.createdAt ?? ''),
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              SizedBox(width: 14),
              Icon(Icons.local_drink, size: 14, color: Colors.black54),
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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

          // Contact prompt — only until the buyer taps "Message" once.
          if (canContact) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.cardGradientStart),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: _red,
                    child: Text(
                      (request.donor?.name ?? '').isNotEmpty
                          ? request.donor!.name![0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Donor accepted your request'.tr,
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          request.donor?.name ?? 'Unknown Donor'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      final cctrl = Get.isRegistered<Chatcontroller>()
                          ? Get.find<Chatcontroller>()
                          : Get.put(Chatcontroller());
                      cctrl.OpenChatUser(
                        userID: request.donor!.id!,
                        isDonar: true,
                        userName: request.donor?.name ?? 'N/A'.tr,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppTheme.roundButtonGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 13,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Message'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
