import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/SearchBuyerModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/SearchBuyerScreen/Controller/SearchBuyerController.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class SearchBuyerCard extends StatelessWidget {
  final SearchBuyerModel buyer;
  const SearchBuyerCard({super.key, required this.buyer});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchBuyerController>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
                        (buyer.buyer!.name ?? "U".tr)[0],
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
                            buyer.buyer!.name ?? 'Unknown'.tr,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (buyer.location!.placeName != "Unknown")
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                (buyer.location!.placeName! +
                                        ", ${buyer.location!.country}"
                                            .replaceAll(", Unknown", "".tr))
                                    .replaceAll("Unknown", "".tr),
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 10,
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
                                "${buyer.distanceText ?? "unknown"}".tr,
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // ✅ Availability badge removed per team lead request
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Chatcontroller cctrl = Get.find<Chatcontroller>();
                      cctrl.OpenChatUser(
                        userID: buyer.buyer!.id!,
                        isDonar: false,
                        userName: buyer.buyer!.name!,
                      );
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: AppTheme.buttonCardGradient,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.message, size: 16, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Send Message'.tr,
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
          ),
        );
      },
    );
  }
}
