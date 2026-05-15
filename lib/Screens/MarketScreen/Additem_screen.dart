import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() =>
      _AddItemScreenState();
}

class _AddItemScreenState
    extends State<AddItemScreen> {
  static const Color primaryRed =
      Color(0xFFE8453C);

  int selectedCondition = 0;

  final List<String> conditions = [
    "New",
    "Like New",
    "Gently Used",
  ];

  bool pickupAvailable = true;
  bool deliveryAvailable = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },

            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 18.sp,
            ),
          ),

          centerTitle: true,

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
                color:
                    Colors.black.withOpacity(
                      0.04,
                    ),
                blurRadius: 10,
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              SizedBox(
                width: double.infinity,
                height: 48.h,

                child: ElevatedButton(
                  onPressed: () {},

                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryRed,

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                14.r,
                              ),
                        ),
                      ),

                  child: Text(
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

              SizedBox(height: 10.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,

                child: ElevatedButton(
                  onPressed: () {},

                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                              0xFFF7EFEF,
                            ),

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                14.r,
                              ),
                        ),
                      ),

                  child: Text(
                    "Save as draft",

                    style: TextStyle(
                      color: Colors.black,
                      fontWeight:
                          FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              /// PHOTO

              Container(
                height: 150.h,
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

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Container(
                      height: 50.h,
                      width: 50.w,

                      decoration:
                          BoxDecoration(
                            color:
                                primaryRed,

                            borderRadius:
                                BorderRadius.circular(
                                  14.r,
                                ),
                          ),

                      child: Icon(
                        Icons
                            .add_a_photo_outlined,
                        color:
                            Colors.white,
                        size: 24.sp,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "Add photos",

                      style: TextStyle(
                        color: primaryRed,
                        fontSize: 17.sp,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      "Upload up to 5 clear photos",

                      style: TextStyle(
                        color:
                            Colors.grey
                                .shade600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 22.h),

              _label("Item Name"),
              _field("e.g. Baby crib, walker"),

              SizedBox(height: 16.h),

              _label("Category"),
              _dropdown(),

              SizedBox(height: 16.h),

              _label("Condition"),

              SizedBox(height: 8.h),

              Container(
                padding: EdgeInsets.all(4.w),

                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF8ECEC,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                        14.r,
                      ),
                ),

                child: Row(
                  children: List.generate(
                    conditions.length,
                    (index) {
                      final isSelected =
                          selectedCondition ==
                          index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCondition =
                                  index;
                            });
                          },

                          child: Container(
                            padding:
                                EdgeInsets.symmetric(
                                  vertical:
                                      10.h,
                                ),

                            decoration:
                                BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors
                                              .white
                                          : Colors
                                              .transparent,

                                  borderRadius:
                                      BorderRadius.circular(
                                        10.r,
                                      ),
                                ),

                            child: Center(
                              child: Text(
                                conditions[
                                    index],

                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? primaryRed
                                          : Colors
                                              .black87,

                                  fontWeight:
                                      FontWeight
                                          .w600,

                                  fontSize:
                                      12.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              _label("Price"),
              _field("\$ 0.00"),

              SizedBox(height: 16.h),

              _label("Description"),

              Container(
                height: 110.h,

                decoration: BoxDecoration(
                  color: const Color(
                    0xFFFFF9F9,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                        14.r,
                      ),

                  border: Border.all(
                    color: const Color(
                      0xFFF0D6D6,
                    ),
                  ),
                ),

                child: TextField(
                  maxLines: null,

                  style: TextStyle(
                    fontSize: 13.sp,
                  ),

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText:
                        "Tell us more about the item",

                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                    ),

                    contentPadding:
                        EdgeInsets.all(14.w),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              _label("Location"),
              _field(""),

              SizedBox(height: 20.h),

              _switchTile(
                "Pickup available",
                pickupAvailable,
                (v) {
                  setState(() {
                    pickupAvailable = v;
                  });
                },
              ),

              SizedBox(height: 10.h),

              _switchTile(
                "Delivery available",
                deliveryAvailable,
                (v) {
                  setState(() {
                    deliveryAvailable = v;
                  });
                },
              ),
            ],
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

  Widget _field(String hint) {
    return Container(
      height: 50.h,

      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),

        borderRadius:
            BorderRadius.circular(14.r),

        border: Border.all(
          color: const Color(
            0xFFF0D6D6,
          ),
        ),
      ),

      child: TextField(
        style: TextStyle(
          fontSize: 13.sp,
        ),

        decoration: InputDecoration(
          border: InputBorder.none,

          hintText: hint,

          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade500,
          ),

          contentPadding:
              EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 14.h,
              ),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Container(
      height: 50.h,

      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),

        borderRadius:
            BorderRadius.circular(14.r),

        border: Border.all(
          color: const Color(
            0xFFF0D6D6,
          ),
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Text(
            "Select Category",

            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),

          Icon(
            Icons.keyboard_arrow_down,
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _switchTile(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 4.h,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),

        borderRadius:
            BorderRadius.circular(14.r),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,

            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          Transform.scale(
            scale: 0.85,

            child: Switch(
              value: value,
              activeColor: primaryRed,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}