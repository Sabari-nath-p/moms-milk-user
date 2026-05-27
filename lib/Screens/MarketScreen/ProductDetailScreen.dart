import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/market_controller.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int listingId;

  const ProductDetailsScreen({
    super.key,
    required this.listingId,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {
  final MarketController controller =
    Get.find<MarketController>();
  @override
void initState() {
  super.initState();

  WidgetsBinding.instance
      .addPostFrameCallback((_) {

    controller.clearMarketplaceDetails();

    controller.fetchMarketplaceDetails(
      widget.listingId,
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
      builder: (controller) {

        if (controller.isDetailsLoading) {
          return  Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        final product =
            controller.marketplaceDetails;

        if (product == null) {
          return  Scaffold(
            body: Center(
              child:
                  Text("No product found".tr),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,

          bottomNavigationBar: Container(
            padding: EdgeInsets.fromLTRB(
                20.w,
                14.h,
                20.w,
                22.h),

            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(.04),
                  blurRadius: 10,
                  offset:
                      const Offset(0, -2),
                ),
              ],
            ),

            child: Row(
              children: [

              Expanded(
  child: OutlinedButton.icon(
    onPressed: () {

      Chatcontroller cctrl =
          Get.put(Chatcontroller());

      cctrl.OpenChatUser(
        userID: product.user.id,
        isDonar: false,
        userName: product.user.name,
      );
    },

    style: OutlinedButton.styleFrom(
      foregroundColor:
          const Color(0xffF44336),

      side: const BorderSide(
        color: Color(0xffF44336),
      ),

      minimumSize: Size(
        double.infinity,
        45.h,
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.r),
      ),
    ),

    icon: Icon(
      Icons.chat_bubble_outline,
      size: 22.sp,
    ),

    label: Text(
      "Chat With Seller".tr,

      style: TextStyle(
        fontSize: 16.sp,
        fontWeight:
            FontWeight.w600,
      ),
    ),
  ),
),

              
              ],
            ),
          ),

          body: SafeArea(
            child:
                SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 20.w,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  SizedBox(
                      height: 12.h),

                  /// APP BAR

                  Row(
                    children: [

                      InkWell(
                        onTap: () =>
                            Get.back(),

                        child: Icon(
                          Icons
                              .arrow_back_ios,
                          size: 22.sp,
                          color: Colors.black,
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            "Product Details".tr,

                            style:
                                TextStyle(
                              fontSize:
                                  18.sp,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ),
                      ),

                    
                    ],
                  ),

                  SizedBox(
                      height: 24.h),

                  /// IMAGE

                  ClipRRect(
                    borderRadius:
                        BorderRadius
                            .circular(
                                10.r),

                    child:
                        Image.network(
                      product.images
                              .isNotEmpty
                          ? product
                              .images[0]
                              .url
                          : "",

                      height: 200.h,

                      width: double
                          .infinity,

                      fit: BoxFit.cover,

                      errorBuilder:
                          (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          height:
                              340.h,

                          color: Colors
                              .grey
                              .shade200,

                          child:
                              const Icon(
                            Icons.image,
                            size: 60,
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                      height: 20.h),

                  /// TITLE

                  Text(
                    product.title,

                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),
                  SizedBox(
                      height: 2.h),

                  Text(
                    "₹${product.price}",

                    style: TextStyle(
                      color:
                          const Color(
                              0xffF44336),

                      fontSize:
                          20.sp,

                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  SizedBox(
                      height: 10.h),

                  /// SELLER

                  Row(
                    children: [

                      CircleAvatar(
                        radius: 15.r,

                        child: Text(
                          product
                              .user.name[0]
                              .toUpperCase(),
                        ),
                      ),

                      SizedBox(
                          width:
                              12.w),

                      Expanded(
                        child: Text(
                          "Sold by : ${product.user.name}",

                          style:
                              TextStyle(
                            fontSize:
                                16.sp,
                                color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                      height: 10.h),

                  /// LOCATION

                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: [
                    
                        Icon(
                          Icons
                              .location_on_outlined,
                          color:
                              const Color(
                                  0xffF44336),
                        ),
                    
                        SizedBox(
                            width:
                                6.w),
                    
                        Text(
                          product
                              .placeName,
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                      height: 8.h),

                  Divider(),
SizedBox(
                      height: 8.h),
                 

                  Text(
                    "Product Description".tr,

                    style:
                        TextStyle(
                      fontSize:
                          16.sp,

                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),

                  SizedBox(
                      height: 5.h),

                  Text(
                    product
                        .description,
                  ),

                  SizedBox(
                      height: 10.h),

                  Divider(),

                  SizedBox(
                      height: 15.h),

                  /// DETAILS

                  Text(
                    "Product Details".tr,

                    style:
                        TextStyle(
                      fontSize:
                          16.sp,

                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),

                  SizedBox(
                      height: 20.h),

                  _detailRow(
                    Icons
                        .sell_outlined,
                    "Category",
                    product.category,
                  ),

                  _detailRow(
                    Icons
                        .star_border,
                    "Condition",
                    product.condition,
                  ),

                  _detailRow(
                    Icons
                        .location_on_outlined,
                    "Zipcode",
                    product.zipcode,
                  ),

                  _detailRow(
                    Icons.bookmark,
                    "Saved",
                    product
                        .count.savedBy
                        .toString(),
                  ),

                  SizedBox(
                      height: 10.h),

                  Divider(),

                  SizedBox(
                      height: 10.h),
                   Text(
                    "About Seller".tr,

                    style:
                        TextStyle(
                      fontSize:
                          16.sp,

                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18.r,

                        child: Text(
                          product
                              .user.name[0]
                              .toUpperCase(),
                        ),
                      ),
                      SizedBox(
                          width:
                              12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.user.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                          Text(
                            "Member Since : ${DateFormat('MMM yyyy').format(product.createdAt)}",
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                      height: 25.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding:
          EdgeInsets.only(
              bottom: 18.h),

      child: Row(
        children: [

          Icon(
            icon,
            color: const Color(
                0xffF44336),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Text(title),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}