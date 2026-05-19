import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/my_listing_controller.dart';

class EditListingScreen extends StatefulWidget {
  final int listingId;
  

  const EditListingScreen({
    super.key,
    required this.listingId,
  });

  @override
  State<EditListingScreen> createState() =>
      _EditListingScreenState();
}

class _EditListingScreenState
    extends State<EditListingScreen> {
  static const Color primaryRed =
      Color(0xFFE8453C);

  final MyListingsController controller =
      Get.find<MyListingsController>();
  final PageController pageController =
    PageController();

int currentImageIndex = 0;

  final List<String> categories = [
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

  final List<String> conditions = [
    "NEW",
    "LIKE_NEW",
    "GOOD",
    "FAIR",
    "POOR",
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      controller.getListingById(
        widget.listingId,
      );
    });
  }

  Future<void> pickImages() async {
    final picked =
        await ImagePicker().pickMultiImage(
      imageQuality: 80,
    );

    if (picked.isNotEmpty) {
      final files =
          picked
              .map(
                (e) => File(e.path),
              )
              .toList();

      await controller
          .uploadEditImages(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<
      MyListingsController
    >(
      builder: (_) {
        return Scaffold(
          backgroundColor:
              Colors.white,

          appBar: AppBar(
            backgroundColor:
                Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Edit Listing",
              style: TextStyle(
                color:
                    Colors.black,
                fontWeight:
                    FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            iconTheme:
                const IconThemeData(
                  color:
                      Colors.black,
                ),
          ),

          bottomNavigationBar:
              Container(
                padding:
                    EdgeInsets.all(
                      14.w,
                    ),
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed:
                        controller
                                .isUpdating
                            ? null
                            : () {
                                controller
                                    .updateListing(
                                      widget
                                          .listingId,
                                    );
                              },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                              14.r,
                            ),
                      ),
                    ),
                    child:
                        controller
                                .isUpdating
                            ? const CircularProgressIndicator(
                                color:
                                    Colors.white,
                              )
                            : Text(
                                "Update Listing",
                                style: TextStyle(
                                  fontSize:
                                      16.sp,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                  ),
                ),
              ),

          body:
              controller
                      .isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      padding:
                          EdgeInsets.all(
                            16.w,
                          ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                       /// IMAGE SECTION
GestureDetector(
  onTap: pickImages,

  child: Container(
    height: 230.h,
    width: double.infinity,

    decoration: BoxDecoration(
      color: const Color(
        0xFFFFF5F5,
      ),
      borderRadius:
          BorderRadius.circular(
        18.r,
      ),
      border: Border.all(
        color: primaryRed,
      ),
    ),

    child:
        controller
                .editImages
                .isEmpty
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  Container(
                    height: 55.h,
                    width: 55.w,
                    decoration:
                        BoxDecoration(
                      color:
                          primaryRed,
                      borderRadius:
                          BorderRadius
                              .circular(
                        14.r,
                      ),
                    ),

                    child: Icon(
                      Icons
                          .add_a_photo_outlined,
                      color:
                          Colors.white,
                      size: 26.sp,
                    ),
                  ),

                  SizedBox(
                    height: 12.h,
                  ),

                  Text(
                    "Add Photos",
                    style:
                        TextStyle(
                      color:
                          primaryRed,
                      fontWeight:
                          FontWeight
                              .w700,
                      fontSize:
                          16.sp,
                    ),
                  ),
                ],
              )

            : Column(
                children: [
                  Expanded(
                    child:
                        Stack(
                      children: [
                        PageView
                            .builder(
                          controller:
                              pageController,
                          itemCount:
                              controller
                                  .editImages
                                  .length,

                          onPageChanged:
                              (
                                index,
                              ) {
                            setState(
                              () {
                                currentImageIndex =
                                    index;
                              },
                            );
                          },

                          itemBuilder:
                              (
                                context,
                                index,
                              ) {
                            final image =
                                controller.editImages[index];

                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                    18.r,
                                  ),

                                  child:
                                      Image.network(
                                    image["url"],
                                    width:
                                        double.infinity,
                                    height:
                                        double.infinity,
                                    fit:
                                        BoxFit.cover,
                                  ),
                                ),

                                Positioned(
                                  top:
                                      12,
                                  right:
                                      12,

                                  child:
                                      GestureDetector(
                                    onTap:
                                        () {
                                      controller
                                          .editImages
                                          .removeAt(
                                            index,
                                          );

                                      if (currentImageIndex >=
                                              controller
                                                  .editImages
                                                  .length &&
                                          controller
                                              .editImages
                                              .isNotEmpty) {
                                        currentImageIndex =
                                            controller
                                                    .editImages
                                                    .length -
                                                1;
                                      }

                                      controller
                                          .update();
                                    },

                                    child:
                                        Container(
                                      padding:
                                          const EdgeInsets.all(
                                        6,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color:
                                            Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(
                                          50,
                                        ),
                                      ),

                                      child:
                                          const Icon(
                                        Icons
                                            .close,
                                        color:
                                            Colors.white,
                                        size:
                                            18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        Positioned(
                          bottom:
                              12,
                          left:
                              0,
                          right:
                              0,

                          child:
                              Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children:
                                List.generate(
                              controller
                                  .editImages
                                  .length,
                              (
                                index,
                              ) {
                                final isSelected =
                                    currentImageIndex ==
                                        index;

                                return AnimatedContainer(
                                  duration:
                                      const Duration(
                                    milliseconds:
                                        250,
                                  ),

                                  margin:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        4,
                                  ),

                                  height:
                                      8,
                                  width:
                                      isSelected
                                          ? 22
                                          : 8,

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        isSelected
                                            ? Colors
                                                .white
                                            : Colors
                                                .white54,
                                    borderRadius:
                                        BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        EdgeInsets.only(
                      top: 8.h,
                      bottom:
                          10.h,
                    ),
                    child: Text(
                      "Swipe images • Tap to add more",
                      style:
                          TextStyle(
                        color:
                            primaryRed,
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ),
                ],
              ),
  ),
),
                          SizedBox(
                            height:
                                20.h,
                          ),

                          _label(
                            "Item Name",
                          ),
                          _textField(
                            controller:
                                controller
                                    .titleController,
                            hint:
                                "Item Name",
                          ),

                          SizedBox(
                            height:
                                16.h,
                          ),

                          _label(
                            "Category",
                          ),
                          DropdownButtonFormField(
                            value:
                                controller
                                    .selectedCategory,
                            decoration:
                                _inputDecoration(),
                            items:
                                categories
                                    .map(
                                      (
                                        e,
                                      ) => DropdownMenuItem(
                                        value:
                                            e,
                                        child: Text(
                                          e,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (
                              value,
                            ) {
                              controller.selectedCategory =
                                  value!;
                              controller.update();
                            },
                          ),

                          SizedBox(
                            height:
                                16.h,
                          ),

                          _label(
                            "Condition",
                          ),
                          DropdownButtonFormField(
                            value:
                                controller
                                    .selectedCondition,
                            decoration:
                                _inputDecoration(),
                            items:
                                conditions
                                    .map(
                                      (
                                        e,
                                      ) => DropdownMenuItem(
                                        value:
                                            e,
                                        child: Text(
                                          e,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (
                              value,
                            ) {
                              controller.selectedCondition =
                                  value!;
                              controller.update();
                            },
                          ),

                          SizedBox(
                            height:
                                16.h,
                          ),

                          _label(
                            "Price",
                          ),
                          _textField(
                            controller:
                                controller
                                    .priceController,
                            hint:
                                "Price",
                            keyboardType:
                                TextInputType.number,
                          ),

                          SizedBox(
                            height:
                                16.h,
                          ),

                          _label(
                            "Description",
                          ),
                          TextField(
                            controller:
                                controller
                                    .descriptionController,
                            maxLines:
                                5,
                            decoration:
                                _inputDecoration(
                                  hintText:
                                      "Tell us more about item",
                                ),
                          ),

                          SizedBox(
                            height:
                                16.h,
                          ),

                          _label(
                            "Zipcode",
                          ),
                          _textField(
                            controller:
                                controller
                                    .zipcodeController,
                            hint:
                                "Zipcode",
                          ),

                          SizedBox(
                            height:
                                16.h,
                          ),

                          _label(
                            "Place Name",
                          ),
                          _textField(
                            controller:
                                controller
                                    .placeController,
                            hint:
                                "City, State",
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _textField({
    required TextEditingController
    controller,
    required String hint,
    TextInputType?
    keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
          keyboardType,
      decoration:
          _inputDecoration(
            hintText: hint,
          ),
    );
  }

  Widget _label(
    String text,
  ) {
    return Padding(
      padding:
          EdgeInsets.only(
            bottom: 8.h,
          ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight:
              FontWeight.w600,
          fontSize:
              14.sp,
        ),
      ),
    );
  }

  InputDecoration
  _inputDecoration({
    String? hintText,
  }) {
    return InputDecoration(
      hintText:
          hintText,
      filled: true,
      fillColor:
          const Color(
            0xFFFFF9F9,
          ),
      border:
          OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                  14.r,
                ),
            borderSide:
                const BorderSide(
                  color: Color(
                    0xFFF0D6D6,
                  ),
                ),
          ),
      enabledBorder:
          OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                  14.r,
                ),
            borderSide:
                const BorderSide(
                  color: Color(
                    0xFFF0D6D6,
                  ),
                ),
          ),
    );
  }
}