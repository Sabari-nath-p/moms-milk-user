
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mommilk_user/Screens/MarketScreen/Service/add_marketcontroller.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  static const Color primaryRed = Color(0xFFE8453C);

  final AddMarketplaceController controller =
      Get.put(AddMarketplaceController());

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

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      final file = File(picked.path);

      await controller.uploadImage(file);

if (controller.imageUrl.isNotEmpty) {
  controller.setSelectedImage(file);
}
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddMarketplaceController>(
      builder: (_) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,

            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,

              leading: IconButton(
                onPressed: Get.back,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 18.sp,
                ),
              ),

              title: Text(
                "List an Item",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
            ),

            bottomNavigationBar: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                 onPressed: controller.isLoading
    ? null
    : () {
        if (controller
            .titleController.text
            .trim()
            .isEmpty) {
          Get.snackbar(
            "Error",
            "Enter item name",
          );
          return;
        }

        if (controller
            .descriptionController
            .text
            .trim()
            .isEmpty) {
          Get.snackbar(
            "Error",
            "Enter description",
          );
          return;
        }

        if (controller
            .priceController.text
            .trim()
            .isEmpty) {
          Get.snackbar(
            "Error",
            "Enter price",
          );
          return;
        }

        if (controller
            .zipcodeController
            .text
            .trim()
            .isEmpty) {
          Get.snackbar(
            "Error",
            "Enter zipcode",
          );
          return;
        }

        if (controller
            .placeController.text
            .trim()
            .isEmpty) {
          Get.snackbar(
            "Error",
            "Enter place name",
          );
          return;
        }

        if (controller
            .imageUrl.isEmpty) {
          Get.snackbar(
            "Error",
            "Upload an image",
          );
          return;
        }

        controller.createListing();
      },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14.r),
                    ),
                  ),

                  child: controller.isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Post Item",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                ),
              ),
            ),

            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  /// IMAGE
                  GestureDetector(
                    onTap: pickImage,

                    child: Container(
                      height: 180.h,
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

                      child: controller.selectedImage != null
    ? Stack(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              18.r,
            ),
            child: Image.file(
              controller.selectedImage!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          if (controller.isUploadingImage)
            Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius:
                    BorderRadius.circular(
                  18.r,
                ),
              ),
              child: const Center(
                child:
                    CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      )
                          : Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                Container(
                                  height: 50.h,
                                  width: 50.w,
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
                                  child: controller
                                          .isUploadingImage
                                      ? const Center(
                                          child:
                                              CircularProgressIndicator(
                                            color:
                                                Colors.white,
                                          ),
                                        )
                                      : Icon(
                                          Icons
                                              .add_a_photo_outlined,
                                          color: Colors
                                              .white,
                                          size:
                                              24.sp,
                                        ),
                                ),

                                SizedBox(
                                  height: 10.h,
                                ),

                                Text(
                                  "Add photos",
                                  style:
                                      TextStyle(
                                    color:
                                        primaryRed,
                                    fontSize:
                                        17.sp,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  _label("Item Name"),
                  _textField(
                    controller:
                        controller.titleController,
                    hint:
                        "e.g. Baby crib, walker",
                  ),

                  SizedBox(height: 16.h),

                  _label("Category"),
                  _categoryDropdown(),

                  SizedBox(height: 16.h),

                  _label("Condition"),
                  _conditionDropdown(),

                  SizedBox(height: 16.h),

                  _label("Price"),
                  _textField(
                    controller:
                        controller.priceController,
                    hint: "0",
                    keyboardType:
                        TextInputType.number,
                  ),

                  SizedBox(height: 16.h),

                  _label("Description"),
                  _descriptionField(),

                  SizedBox(height: 16.h),

                  _label("Zipcode"),
                  _textField(
                    controller: controller
                        .zipcodeController,
                    hint: "Enter zipcode",
                  ),

                  SizedBox(height: 16.h),

                  _label("Place Name"),
                  _textField(
                    controller:
                        controller.placeController,
                    hint:
                        "City, State",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _categoryDropdown() {
    return DropdownButtonFormField<String>(
      value: controller.selectedCategory,
      decoration: _inputDecoration(),
      items: categories
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: (value) {
        controller.selectedCategory =
            value!;
        controller.update();
      },
    );
  }

  Widget _conditionDropdown() {
    return DropdownButtonFormField<String>(
      value: controller.selectedCondition,
      decoration: _inputDecoration(),
      items: conditions
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: (value) {
        controller.selectedCondition =
            value!;
        controller.update();
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(
        hintText: hint,
      ),
    );
  }

  Widget _descriptionField() {
    return TextField(
      controller:
          controller.descriptionController,
      maxLines: 5,
      decoration: _inputDecoration(
        hintText:
            "Tell us more about the item",
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(
        0xFFFFF9F9,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14.r),
        borderSide: BorderSide(
          color: const Color(
            0xFFF0D6D6,
          ),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14.r),
        borderSide: BorderSide(
          color: const Color(
            0xFFF0D6D6,
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 8.h,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}