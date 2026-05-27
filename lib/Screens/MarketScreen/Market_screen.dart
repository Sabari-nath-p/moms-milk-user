
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/MarketListingModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/MarketScreen/Additem_screen.dart';
//import 'package:mommilk_user/Screens/MarketScreen/Additem_screen.dart';
import 'package:mommilk_user/Screens/MarketScreen/ProductDetailScreen.dart';
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
    'All'.tr,
    'CRADLES'.tr,
    'TOYS'.tr,
    'CLOTHING'.tr,
    'STROLLERS'.tr,
    'CAR_SEATS'.tr,
    'FEEDING'.tr,
    'BATH'.tr,
    'SAFETY'.tr,
    'BOOKS'.tr,
    'EDUCATIONAL'.tr,
    'OTHER'.tr,
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

        title: Text(
          "Marketplace".tr,
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: "Inter",
          ),
        ),
        actions: [
  Padding(
    padding: const EdgeInsets.only(
      right: 12,
    ),

    child: GestureDetector(
      onTap: () {
        Get.to(() =>  AddItemScreen());
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
                                   InputDecoration(
                                    border:
                                        InputBorder.none,

                                    hintText:
                                        "Search products".tr,

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

Widget _productCard(MarketplaceListing p) {
  final image =
      p.images.isNotEmpty
          ? p.images.first.url
          : "";

  return InkWell(
    borderRadius: BorderRadius.circular(10.r),

   onTap: () {
   Get.to(
      () => ProductDetailsScreen(
         listingId: p.id,
      ),
   );
},

    child: Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(10.r),

        border: Border.all(
          color: const Color(0xFFF1E6E4),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.025,
            ),

            blurRadius: 8,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: SizedBox(
        height: 110.h,

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [
            /// ================= IMAGE =================

            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.only(
                        topLeft:
                            Radius.circular(
                              10.r,
                            ),

                        bottomLeft:
                            Radius.circular(
                              10.r,
                            ),
                      ),

                  child: SizedBox(
                    width: 135.w,
                    height: 150.h,

                    child:
                        image.isNotEmpty
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,

                                loadingBuilder: (
                                  context,
                                  child,
                                  progress,
                                ) {
                                  if (progress ==
                                      null) {
                                    return child;
                                  }

                                  return Container(
                                    color: Colors
                                        .grey
                                        .shade100,

                                    child:
                                        const Center(
                                          child:
                                              SizedBox(
                                                height:
                                                    22,
                                                width:
                                                    22,

                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth:
                                                          2,
                                                      color:
                                                          primaryRed,
                                                    ),
                                              ),
                                        ),
                                  );
                                },

                                errorBuilder:
                                    (
                                      _,
                                      __,
                                      ___,
                                    ) => _imagePlaceholder(),
                              )
                            : _imagePlaceholder(),
                  ),
                ),

                /// ================= LOCATION =================

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
                          Icons
                              .location_on_outlined,

                          size: 13,
                          color: primaryRed,
                        ),

                        const SizedBox(
                          width: 3,
                        ),

                        Text(
                          p.placeName.isEmpty
                              ? "Unknown"
                              : p.placeName,

                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight:
                                FontWeight.w700,
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
                padding: EdgeInsets.all(
                  12.w,
                ),

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    /// ================= TOP =================

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        /// TITLE

                        Text(
                          p.title,

                          maxLines: 1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                                FontWeight.w700,

                            color:
                                Colors.black87,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        /// PRICE

                        Text(
                          "₹${p.price}",

                          style: TextStyle(
                            color: primaryRed,

                            fontSize: 16.sp,

                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        /// SELLER

                        Row(
                          children: [
                            Container(
                              height: 24.h,
                              width: 24.w,

                              decoration:
                                  const BoxDecoration(
                                    color: Color(
                                      0xFFFFD7CF,
                                    ),

                                    shape:
                                        BoxShape
                                            .circle,
                                  ),

                              child: Center(
                                child: Text(
                                  p.user.name
                                          .isNotEmpty
                                      ? p
                                          .user
                                          .name[0]
                                          .toUpperCase()
                                      : "U",

                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w700,

                                    fontSize:
                                        10.sp,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 8.w),

                            Expanded(
                              child: Text(
                                "Sold by: ${p.user.name}",

                                maxLines: 1,

                                overflow:
                                    TextOverflow
                                        .ellipsis,

                                style: TextStyle(
                                  fontSize:
                                      10.sp,

                                  fontWeight:
                                      FontWeight
                                          .w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                   
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
Widget _imagePlaceholder() {
  return Container(
    width: 135,
    height: 155,
    color: const Color(0xFFF8F8F8),

    child: Column(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [
        Icon(
          Icons.image_outlined,
          size: 34,
          color: Colors.grey.shade400,
        ),

        SizedBox(height: 6.h),

        Text(
          "No Image",
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}