import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/MarketScreen/EditListingScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/my_listing_controller.dart';

class MyListingsScreen extends StatelessWidget {
  MyListingsScreen({super.key});

  final MyListingsController controller =
      Get.put(MyListingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Listings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: GetBuilder<MyListingsController>(
        builder: (_) {
          if (controller.isLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (controller.listings.isEmpty) {
            return const Center(
              child: Text(
                "No listings found",
              ),
            );
          }

          return RefreshIndicator(
            onRefresh:
                () => controller
                    .fetchMyListings(
                      isRefresh: true,
                    ),

            child: ListView.builder(
              padding:
                  const EdgeInsets.all(16),
              itemCount:
                  controller.listings.length,
              itemBuilder: (
                context,
                index,
              ) {
                final item =
                    controller
                        .listings[index];

                final image =
                    item["images"] != null &&
                            item["images"]
                                .isNotEmpty
                        ? item["images"][0]["url"]
                        : "";

              return Container(
  margin: const EdgeInsets.only(bottom: 14),

  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  ),

  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// IMAGE
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            image,
            height: 110,
            width: 110,
            fit: BoxFit.cover,

            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return Container(
                height: 110,
                width: 110,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.image,
                  size: 35,
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        /// DETAILS
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              /// TITLE + ACTIONS
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item["title"] ?? "",
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                            fontWeight:
                                FontWeight.w700,
                            fontSize: 16,
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
    listingId:
        item["id"],
  ),
);
  
},
                    child: Container(
                      padding:
                          const EdgeInsets.all(
                            6,
                          ),
                      decoration:
                          BoxDecoration(
                            color:
                                Colors.blue
                                    .shade50,
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                          ),
                      child: Icon(
                        Icons.edit_outlined,
                        color:
                            Colors.blue.shade700,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// DELETE
                  InkWell(
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text(
                            "Delete Listing",
                          ),
                          content:
                              const Text(
                                "Are you sure you want to delete this listing?",
                              ),

                          actions: [
                            TextButton(
                              onPressed:
                                  () => Get.back(),
                              child:
                                  const Text(
                                    "Cancel",
                                  ),
                            ),

                            ElevatedButton(
                              onPressed:
                                  () {
                                    Get.back();

                                    controller
                                        .deleteListing(
                                      item["id"],
                                    );
                                  },
                              style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red,
                                  ),
                              child:
                                  const Text(
                                    "Delete",
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.all(
                            6,
                          ),
                      decoration:
                          BoxDecoration(
                            color:
                                Colors.red
                                    .shade50,
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                          ),
                      child: Icon(
                        Icons.delete_outline,
                        color:
                            Colors.red.shade700,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// DESCRIPTION
              Text(
                item["description"] ?? "",
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 10),

              /// PRICE + STATUS
              Row(
                children: [
                  Text(
                    "₹${item["price"]}",
                    style:
                        const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 18,
                          color:
                              Color(0xFFE8453C),
                        ),
                  ),

                  const Spacer(),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                    decoration:
                        BoxDecoration(
                          color: item["status"] ==
                                  "ACTIVE"
                              ? Colors.green
                                  .shade100
                              : Colors.orange
                                  .shade100,
                          borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                        ),
                    child: Text(
                      item["status"] ?? "",
                      style:
                          TextStyle(
                            fontSize: 12,
                            color:
                                item["status"] ==
                                        "ACTIVE"
                                    ? Colors
                                        .green
                                    : Colors
                                        .orange,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 8),

              /// LOCATION
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color:
                        Colors.grey.shade600,
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    child: Text(
                      "${item["placeName"]} • ${item["zipcode"]}",
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            Colors.grey
                                .shade700,
                        fontSize: 12,
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