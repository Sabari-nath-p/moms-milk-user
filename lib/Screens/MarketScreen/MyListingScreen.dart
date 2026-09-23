import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/MarketScreen/EditListingScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/my_listing_controller.dart';

String _translateStatus(String status) {
  switch (status) {
    case 'ACTIVE':
      return 'ACTIVE'.tr;
    case 'INACTIVE':
      return 'INACTIVE'.tr;
    default:
      return status;
  }
}

class MyListingsScreen extends StatelessWidget {
  MyListingsScreen({super.key});

  final MyListingsController controller = Get.put(MyListingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Listings".tr,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: GetBuilder<MyListingsController>(
        builder: (_) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.listings.isEmpty) {
            return Center(child: Text("No listings found".tr));
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchMyListings(isRefresh: true),

            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: controller.listings.length,
              itemBuilder: (context, index) {
                final item = controller.listings[index];

                final image =
                    item["images"] != null && item["images"].isNotEmpty
                    ? item["images"][0]["url"]
                    : "";

                return Container(
                  margin: EdgeInsets.only(bottom: 14.h),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: Colors.grey.shade200, width: 1.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14.r),
                          child: Image.network(
                            image,
                            height: 110.h,
                            width: 110.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 110.h,
                                width: 110.w,
                                color: Colors.grey.shade200,
                                child: Icon(Icons.image, size: 35.sp),
                              );
                            },
                          ),
                        ),

                        SizedBox(width: 12.w),

                        /// DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// TITLE + ACTIONS
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item["title"] ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),

                                  /// EDIT
                                  InkWell(
                                    onTap: () async {
                                      await controller.getListingById(
                                        item["id"],
                                      );
                                      Get.to(
                                        () => EditListingScreen(
                                          listingId: item["id"],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(6.w),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: Colors.blue.shade700,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 8.w),

                                  /// DELETE
                                  InkWell(
                                    onTap: () {
                                      Get.dialog(
                                        AlertDialog(
                                          title: Text("Delete Listing".tr),
                                          content: Text(
                                            "Are you sure you want to delete this listing?"
                                                .tr,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: Text("Cancel".tr),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                                controller.deleteListing(
                                                  item["id"],
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              child: Text("Delete".tr),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(6.w),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red.shade700,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /// DESCRIPTION
                              Text(
                                item["description"] ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14.sp,
                                ),
                              ),

                              SizedBox(height: 10.h),

                              /// PRICE + STATUS
                              Row(
                                children: [
                                  Text(
                                    "₹${item["price"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                      color: Color(0xFFE8453C),
                                    ),
                                  ),

                                  const Spacer(),

                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item["status"] == "ACTIVE"
                                          ? Colors.green.shade100
                                          : Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      _translateStatus(item["status"] ?? ""),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: item["status"] == "ACTIVE"
                                            ? Colors.green
                                            : Colors.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 8.h),

                              /// LOCATION
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16.sp,
                                    color: Colors.grey.shade600,
                                  ),

                                  SizedBox(width: 4.w),

                                  Expanded(
                                    child: Text(
                                      "${item["placeName"]} • ${item["zipcode"]}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
