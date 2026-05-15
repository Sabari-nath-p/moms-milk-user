
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/MarketListingModel.dart';
import 'package:mommilk_user/Screens/MarketScreen/Additem_screen.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/market_controller.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final MarketController controller =
      Get.put(MarketController());

  int selectedTab = 0;

  String selectedCategory = "All";
  String? selectedCondition;

  final TextEditingController searchController =
      TextEditingController();

  static const Color primaryRed = Color(0xFFE8453C);
  static const Color lightPink = Color(0xFFFFF0EF);
  static const Color tabBg = Color(0xFFFDE8E6);

  final List<String> categories = [
    'All',
    'CRADLES',
    'TOYS',
    'CLOTHING',
    'STROLLERS',
    'CAR_SEATS',
    'FEEDING',
    'BATH',
    'SAFETY',
    'BOOKS',
    'EDUCATIONAL',
    'OTHER',
  ];

  @override
  void initState() {
    super.initState();

    controller.fetchMarketplaceListings();
  }

 

  void applyFilters() {
    controller.fetchMarketplaceListings(
      searchText: searchController.text.trim(),

      category:
          selectedCategory == "All"
              ? ""
              : selectedCategory,

      condition:
          selectedCondition == null ||
                  selectedCondition!.isEmpty
              ? ""
              : selectedCondition!,

      page: 1,
      isRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Marketplace",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
  Padding(
    padding: const EdgeInsets.only(
      right: 12,
    ),

    child: GestureDetector(
      onTap: () {
        Get.to(() => const AddItemScreen());
      },

      child: Container(
        padding: const EdgeInsets.all(8),

        decoration: BoxDecoration(
          color: primaryRed,
          borderRadius:
              BorderRadius.circular(12),
        ),

        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 22,
        ),
      ),
    ),
  ),
],
      ),

      body: GetBuilder<MarketController>(
        builder: (_) {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.refreshMarketplace();
            },

            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const SizedBox(height: 16),

                

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),

                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(
                                    30,
                                  ),

                              border: Border.all(
                                color:
                                    Colors.grey.shade300,
                              ),
                            ),

                            child: TextField(
                              controller:
                                  searchController,

                              onSubmitted: (_) {
                                applyFilters();
                              },

                              decoration:
                                  const InputDecoration(
                                    border:
                                        InputBorder.none,

                                    hintText:
                                        "Search products",

                                    prefixIcon: Icon(
                                      Icons.search,
                                    ),
                                  ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// ================= FILTER =================

                        PopupMenuButton<String>(
                          onSelected: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                selectedCondition =
                                    null;
                              } else {
                                selectedCondition =
                                    value;
                              }
                            });

                            applyFilters();
                          },

                          itemBuilder:
                              (context) => [
                                _popupItem("NEW"),
                                _popupItem(
                                  "LIKE_NEW",
                                ),
                                _popupItem("GOOD"),
                                _popupItem("FAIR"),
                                _popupItem("POOR"),

                                

                                const PopupMenuItem<
                                  String
                                >(
                                  value: "",
                                  child: Text(
                                    "Clear Filter",

                                    style: TextStyle(
                                      color:
                                          Colors.red,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ),
                              ],

                          child: Container(
                            height: 48,
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),

                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                    14,
                                  ),

                              border: Border.all(
                                color:
                                    Colors.grey.shade300,
                              ),
                            ),

                            child: Row(
                              children: [
                                const Icon(
                                  Icons.tune,
                                  color: Colors.pink,
                                ),

                                if (selectedCondition !=
                                    null) ...[
                                  const SizedBox(
                                    width: 6,
                                  ),

                                  Text(
                                    selectedCondition!
                                        .replaceAll(
                                          "_",
                                          " ",
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ================= CATEGORY =================

                  SizedBox(
                    height: 40,

                    child: ListView.separated(
                      scrollDirection:
                          Axis.horizontal,

                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),

                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(
                                width: 8,
                              ),

                      itemCount: categories.length,

                      itemBuilder: (
                        context,
                        index,
                      ) {
                        final cat =
                            categories[index];

                        final isSelected =
                            selectedCategory ==
                            cat;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory =
                                  cat;
                            });

                            applyFilters();
                          },

                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),

                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? primaryRed
                                      : lightPink,

                              borderRadius:
                                  BorderRadius.circular(
                                    20,
                                  ),
                            ),

                            child: Center(
                              child: Text(
                                cat,

                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors
                                              .white
                                          : Colors
                                              .black,

                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= LOADING =================

                  if (controller.isLoading &&
                      controller.listings.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 100,
                      ),

                      child: Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                    ),

                  /// ================= EMPTY =================

                  if (!controller.isLoading &&
                      controller.listings.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 100,
                      ),

                      child: Center(
                        child: Text(
                          "No products found",
                        ),
                      ),
                    ),

                  /// ================= PRODUCTS =================

                  if (controller.listings.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),

                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(
                                height: 12,
                              ),

                      itemCount:
                          controller.listings.length,

                      itemBuilder: (
                        context,
                        index,
                      ) {
                        return _productCard(
                          controller
                              .listings[index],
                        );
                      },
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PopupMenuItem<String> _popupItem(
    String value,
  ) {
    return PopupMenuItem<String>(
      value: value,

      child: Text(
        value.replaceAll("_", " "),
      ),
    );
  }



Widget _productCard(
  MarketplaceListing p,
) {
  final image =
      p.images.isNotEmpty
          ? p.images.first.url
          : "";

  return Container(
    margin: const EdgeInsets.only(bottom: 12),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),

      border: Border.all(
        color: const Color(0xFFF1E6E4),
      ),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.025),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),

    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
   

        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.only(
                    topLeft: Radius.circular(
                      20,
                    ),
                    bottomLeft:
                        Radius.circular(
                          20,
                        ),
                  ),

              child:
                  image.isNotEmpty
                      ? Image.network(
                        image,
                        width: 135,
                        height: 155,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 135,
                        height: 155,
                        color:
                            Colors.grey.shade200,

                        child: const Icon(
                          Icons.image,
                          size: 34,
                        ),
                      ),
            ),

            /// LOCATION

            Positioned(
              bottom: 8,
              left: 8,

              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                        22,
                      ),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: primaryRed,
                    ),

                    const SizedBox(width: 3),

                    Text(
                      p.placeName.isEmpty
                          ? "2 miles away"
                          : p.placeName,

                      style:  TextStyle(
                        fontSize: 9.sp,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        /// ================= DETAILS =================

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(
              12,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                /// TOP

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            p.title,

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                 TextStyle(
                                  fontSize:
                                      14.sp,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                  color:
                                      Colors
                                          .black87,
                                ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            p.description,

                            maxLines: 2,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style: TextStyle(
                              fontSize:
                                  12,
                              color: Colors
                                  .grey
                                  .shade600,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 6),

                    Container(
                      height: 28,
                      width: 28,

                      decoration:
                          BoxDecoration(
                            color:
                                Colors.white,
                            shape:
                                BoxShape.circle,

                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withOpacity(
                                      0.04,
                                    ),
                                blurRadius: 4,
                              ),
                            ],
                          ),

                      child: Icon(
                        Icons.favorite_border,
                        color: primaryRed,
                        size: 17,
                      ),
                    ),
                  ],
                ),

                 SizedBox(height: 8.h),

                /// PRICE

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,

                  children: [
                    Text(
                      "₹${p.price}",

                      style:
                           TextStyle(
                            color:
                                primaryRed,
                            fontSize: 16.sp,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                    ),

                    // const SizedBox(width: 8),

                    // Text(
                    //   "₹2500",

                    //   style: TextStyle(
                    //     color: Colors
                    //         .grey
                    //         .shade500,

                    //     fontSize: 13,

                    //     decoration:
                    //         TextDecoration
                    //             .lineThrough,
                    //   ),
                    // ),
                  ],
                ),

                 SizedBox(height: 8.h),

                

                Row(
                  children: [
                    Container(
                      height: 28.h,
                      width: 28.w,

                      decoration:
                          const BoxDecoration(
                            color:
                                Color(0xFFFFD7CF),
                            shape:
                                BoxShape.circle,
                          ),

                      child: Center(
                        child: Text(
                          p.user.name
                                  .isNotEmpty
                              ? p.user.name
                                  .substring(
                                    0,
                                    1,
                                  )
                                  .toUpperCase()
                              : "U",

                          style:
                               TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w700,
                                fontSize: 10.sp,
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        "Sold by: ${p.user.name}",

                        maxLines: 1,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                             TextStyle(
                              fontSize: 10.sp,
                              fontWeight:
                                  FontWeight
                                      .w500,
                            ),
                      ),
                    ),

                    // const Text(
                    //   "20% off ↓",

                    //   style: TextStyle(
                    //     color:
                    //         Color(0xFF22C55E),
                    //     fontWeight:
                    //         FontWeight.w700,
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                ),

                const SizedBox(height: 14),

                /// BUTTON

                SizedBox(
                  width: 200.w,
                  height: 40,

                  child:
                      ElevatedButton.icon(
                        onPressed: () {},

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              primaryRed,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                          ),
                        ),

                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 16,
                        ),

                        label: const Text(
                          "Chat with seller",

                          style: TextStyle(
                            color:
                                Colors.white,
                            fontSize: 13,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}