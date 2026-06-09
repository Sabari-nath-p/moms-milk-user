import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/my_listing_controller.dart';

class EditListingScreen extends StatefulWidget {
  final int listingId;

  const EditListingScreen({super.key, required this.listingId});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  static const Color primaryRed = Color(0xFFE8453C);
  static const Color _redLight = Color(0xFFFFF5F5);
  static const Color _redBorder = Color(0xFFF0D6D6);

  final MyListingsController controller = Get.find<MyListingsController>();
  final PageController pageController = PageController();
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

  final List<String> conditions = ["NEW", "LIKE_NEW", "GOOD", "FAIR", "POOR"];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => controller.getListingById(widget.listingId));
  }

  void _showPhotoSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'Add Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: primaryRed,
                    size: 22,
                  ),
                ),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: const Text(
                  'Open camera and click a photo',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF6B7280),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    await controller.uploadEditImages([File(picked.path)]);
                  }
                },
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: primaryRed,
                    size: 22,
                  ),
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: const Text(
                  'Select one or more photos',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF6B7280),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickMultiImage(
                    imageQuality: 80,
                  );
                  if (picked.isNotEmpty) {
                    await controller.uploadEditImages(
                      picked.map((e) => File(e.path)).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyListingsController>(
      builder: (_) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Edit Listing",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(14.w, 10, 14.w, 20),
          color: Colors.white,
          child: SizedBox(
            height: 52.h,
            child: ElevatedButton(
              onPressed: controller.isUpdating
                  ? null
                  : () => controller.updateListing(widget.listingId),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: controller.isUpdating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Update Listing",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
        body: controller.isLoading
            ? const Center(child: CircularProgressIndicator(color: primaryRed))
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── IMAGE SECTION ──────────────────────────────────────
                    _imageSection(),
                    SizedBox(height: 20.h),

                    _label("Item Name *"),
                    _textField(
                      controller: controller.titleController,
                      hint: "e.g. Wooden Baby Cradle",
                    ),
                    SizedBox(height: 16.h),

                    _label("Category *"),
                    _dropdownField(
                      value: controller.selectedCategory,
                      items: categories,
                      onChanged: (v) {
                        controller.selectedCategory = v!;
                        controller.update();
                      },
                    ),
                    SizedBox(height: 16.h),

                    _label("Condition *"),
                    _dropdownField(
                      value: controller.selectedCondition,
                      items: conditions,
                      onChanged: (v) {
                        controller.selectedCondition = v!;
                        controller.update();
                      },
                    ),
                    SizedBox(height: 16.h),

                    _label("Price *"),
                    _textField(
                      controller: controller.priceController,
                      hint: "e.g. 1500",
                      keyboardType: TextInputType.number,
                      prefix: "₹ ",
                    ),
                    SizedBox(height: 16.h),

                    _label("Description *"),
                    TextField(
                      controller: controller.descriptionController,
                      maxLines: 5,
                      decoration: _inputDecoration(
                        hintText: "Tell us more about the item",
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _label("Zipcode *"),
                    _textField(
                      controller: controller.zipcodeController,
                      hint: "e.g. 600001",
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),

                    _label("Place Name *"),
                    _textField(
                      controller: controller.placeController,
                      hint: "e.g. Chennai, Tamil Nadu",
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
      ),
    );
  }

  // ── IMAGE SECTION ──────────────────────────────────────────────────────────
  Widget _imageSection() {
    final images = controller.editImages;
    final hasImages = images.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main image container
        GestureDetector(
          onTap: _showPhotoSourceSheet,
          child: Container(
            height: 220.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _redLight,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: _redBorder, width: 1.5),
            ),
            child: !hasImages
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 55.h,
                        width: 55.w,
                        decoration: BoxDecoration(
                          color: primaryRed,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.white,
                          size: 26.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Tap to Add Photos",
                        style: TextStyle(
                          color: primaryRed,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "At least 1 photo required",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      // PageView
                      ClipRRect(
                        borderRadius: BorderRadius.circular(17.r),
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: images.length,
                          onPageChanged: (i) =>
                              setState(() => currentImageIndex = i),
                          itemBuilder: (_, i) {
                            final image = images[i];
                            return Image.network(
                              image["url"],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Delete button — top right
                      // FIX #2505: show delete only if more than 1 image;
                      // if only 1 remains, show disabled greyed-out button so user knows
                      Positioned(
                        top: 10,
                        right: 10,
                        child: images.length > 1
                            ? GestureDetector(
                                onTap: () {
                                  images.removeAt(currentImageIndex);
                                  if (currentImageIndex >= images.length &&
                                      images.isNotEmpty) {
                                    setState(
                                      () =>
                                          currentImageIndex = images.length - 1,
                                    );
                                  }
                                  controller.update();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  // Absorb tap so parent GestureDetector (pickImages) is NOT triggered
                                  Get.snackbar(
                                    'Cannot Remove',
                                    'At least 1 photo is required.',
                                    backgroundColor: const Color(0xFFE8453C),
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2),
                                    margin: const EdgeInsets.all(12),
                                    borderRadius: 10,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                      ),

                      // Dot indicators
                      if (images.length > 1)
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(images.length, (i) {
                              final active = currentImageIndex == i;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                height: 8,
                                width: active ? 20 : 8,
                                decoration: BoxDecoration(
                                  color: active ? Colors.white : Colors.white54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            }),
                          ),
                        ),

                      // Image counter
                      if (images.length > 1)
                        Positioned(
                          bottom: 10,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${currentImageIndex + 1}/${images.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),

        // Hint + photo count row
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Row(
            children: [
              Icon(
                hasImages ? Icons.check_circle_outline : Icons.error_outline,
                size: 14,
                color: hasImages ? Colors.green : primaryRed,
              ),
              const SizedBox(width: 5),
              Text(
                hasImages
                    ? '${images.length} photo${images.length == 1 ? '' : 's'} • Swipe to browse • Tap image to add more'
                    : 'At least 1 photo is required',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: hasImages ? Colors.grey.shade600 : primaryRed,
                  fontWeight: hasImages ? FontWeight.w400 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Thumbnail strip
        if (images.length > 1) ...[
          SizedBox(height: 10.h),
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (_, i) {
                final active = i == currentImageIndex;
                return GestureDetector(
                  onTap: () {
                    pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: active ? primaryRed : Colors.grey.shade300,
                        width: active ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        images[i]["url"],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_outlined,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? prefix,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: _inputDecoration(hintText: hint, prefix: prefix),
  );

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) => DropdownButtonFormField<String>(
    value: value,
    decoration: _inputDecoration(),
    items: items
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList(),
    onChanged: onChanged,
  );

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
    ),
  );

  InputDecoration _inputDecoration({String? hintText, String? prefix}) =>
      InputDecoration(
        hintText: hintText,
        prefixText: prefix,
        filled: true,
        fillColor: const Color(0xFFFFF9F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFF0D6D6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFF0D6D6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFE8453C), width: 1.5),
        ),
      );
}
