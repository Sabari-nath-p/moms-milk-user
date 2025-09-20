import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mommilk_user/Models/RequestModel.dart';
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';

class HistoryRequestCard extends StatelessWidget {
  RequestModel request;
  HistoryRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      color: Theme.of(context).primaryColor.withOpacity(.1),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.description ?? 'No description available',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(request.status ?? 'pending'),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (request.status ?? 'pending').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Info Row
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  request.requester?.name ?? 'Unknown',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  formatDate(request.createdAt ?? ''),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
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

            const SizedBox(height: 8),

            // Bottom Row with Quantity
            Row(
              children: [
                Icon(Icons.local_drink, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  '${request.quantity ?? 0} ml',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
