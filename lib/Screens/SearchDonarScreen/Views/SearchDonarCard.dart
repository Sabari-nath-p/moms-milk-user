import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:mommilk_user/Models/SearchDonarModel.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Controller/SearchDonarController.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Views/SendRequestBottomSheet.dart';

class SearchDonarCard extends StatelessWidget {
  SearchDonarModel donar;
  SearchDonarCard({super.key, required this.donar});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchDonarController>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        (donar.donor!.name ?? "U")[0],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            donar.donor!.name ?? 'Unknown',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${donar.distance ?? "unknow"} km",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 8),
                              // Icon(Icons.star, color: Colors.amber, size: 16),
                              // const SizedBox(width: 4),
                              // Text(
                              //   controller.getDonorRating(donor),
                              //   style: Theme.of(context).textTheme.bodySmall,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: controller.getAvailabilityColor(
                          donar.donor!.isAvailable ?? false,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        controller.getAvailabilityText(
                          donar.donor!.isAvailable ?? false,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (donar.donor!.description! != null)
                  Text(
                    donar.donor!.description ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    if (donar.donor!.ableToShareMedicalRecord == true)
                      _buildInfoChip(
                        'Medical Records',
                        Icons.medical_services,
                        Colors.green,
                      ),
                    _buildInfoChip(
                      'Blood: ${donar.donor!.bloodGroup ?? 'N/A'}',
                      Icons.bloodtype,
                      Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (donar.hasAcceptedRequest ?? false)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            //controller.viewDonorProfile(donor);
                          },
                          icon: const Icon(Icons.person, size: 16),
                          label: const Text('View Profile'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (!(donar.hasAcceptedRequest ?? false))
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder:
                                  (context) =>
                                      SendRequestBottomSheet(donar: donar),
                            );
                          },

                          icon: const Icon(Icons.send, size: 16),
                          label: const Text('Connect'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
      },
    );
  }
}

Widget _buildInfoChip(String label, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
