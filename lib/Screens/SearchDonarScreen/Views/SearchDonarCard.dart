import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:mommilk_user/Models/SearchDonarModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/RequestScreen/Views/contactBottomSheet.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Controller/SearchDonarController.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Views/SendRequestBottomSheet.dart';
import 'package:mommilk_user/theme/app_theme.dart';

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
            // gradient: AppTheme.CardGradient,
            border: Border.all(color: Color(0xffFB7185).withOpacity(0.5)),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: AppTheme.primaryColor.withOpacity(.4),
                      child: Text(
                        (donar.donor!.name ?? "U".tr)[0],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            donar.donor!.name ?? 'Unknown'.tr,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (donar.location!.placeName != "Unknown")
                            Padding(
                              padding: EdgeInsetsGeometry.only(bottom: 10),
                              child: Text(
                                (donar.location!.placeName!! +
                                        ", ${donar.location!.country}"
                                            .replaceAll(", Unknown", "".tr))
                                    .replaceAll("Unknown", "".tr),
                                maxLines: 1,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),

                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(width: 4),

                              Text(
                                "${donar.distanceText ?? "unknow"}".tr,
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(width: 8),
                              // Icon(Icons.star, color: Colors.amber, size: 16),
                              // SizedBox(width: 4),
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
                      padding: EdgeInsets.symmetric(
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // if (donar.donor!.description! != null)
                //   Text(
                //     donar.donor!.description ?? "",
                //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                //       color: Colors.black.withOpacity(.8),
                //     ),
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // if (donar.donor!.ableToShareMedicalRecord ?? false)
                //   SizedBox(height: 12),
                // if (donar.donor!.ableToShareMedicalRecord ?? false)
                //   Wrap(
                //     spacing: 8,
                //     children: [
                //       if (donar.donor!.ableToShareMedicalRecord == true)
                //         _buildInfoChip(
                //           'Medical Records'.tr,
                //           Icons.medical_services,
                //           Colors.green,
                //         ),
                //       // _buildInfoChip(
                //       //   'Blood: ${donar.donor!.bloodGroup ?? 'N/A'}',
                //       //   Icons.bloodtype,
                //       //   Colors.red,
                //       // ),
                //     ],
                //   ),
                // SizedBox(height: 16),
                Row(
                  children: [
                    // --------------------- VIEW PROFILE BUTTON ---------------------
                    if (donar.hasAcceptedRequest ?? false)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Chatcontroller cctrl = Get.put(Chatcontroller());
                            cctrl.OpenChatUser(
                              userID: donar.donor!.id!,
                              isDonar: true,
                              userName: donar.donor!.name!!,
                            );
                          },
                          icon: Icon(Icons.person, size: 16),
                          label: Text('Send a message'.tr),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                    SizedBox(width: 8),

                    // --------------------- CONNECT BUTTON WITH GRADIENT ---------------------
                    if (!(donar.hasAcceptedRequest ?? false))
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!(donar.hasPendingRequest ?? false)) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder:
                                    (context) =>
                                        SendRequestBottomSheet(donar: donar),
                              );
                            }
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient:
                                  (donar.hasPendingRequest ?? false)
                                      ? LinearGradient(
                                        colors: [Colors.grey, Colors.grey],
                                      ) // disabled grey
                                      : AppTheme.buttonCardGradient,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.send,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                (donar.hasPendingRequest ?? false)
                                 ? 'Requested'.tr
                                 : 'Connect'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        SizedBox(width: 4),
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
