import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mommilk_user/Screens/MarketScreen/Additem_screen.dart';

const Color _kRed = Color(0xFFE8453C);
const Color _kRedLight = Color(0xFFFFE5E3);

/// Shared "What would you like to list?" chooser — Baby Item vs Breast Milk.
/// Used by the Marketplace FAB and the Home dashboard "Add Now" banner so
/// both entry points open the exact same [AddItemScreen] flow.
///
/// [onListed] is called after the listing flow closes (whether or not a
/// listing was actually created) so callers can refresh their own data.
void showListingTypeSheet(BuildContext context, {VoidCallback? onListed}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            Text(
              'What would you like to list?'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              leading: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: _kRedLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: _kRed,
                  size: 22.sp,
                ),
              ),
              title: Text(
                'Baby Item'.tr,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
              subtitle: Text(
                'List a pre-loved baby product'.tr,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: Colors.grey.shade400,
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                Get.to(() => AddItemScreen(isMilk: false))?.then(
                  (_) => onListed?.call(),
                );
              },
            ),
            Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              leading: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: _kRedLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.water_drop_outlined, color: _kRed, size: 22.sp),
              ),
              title: Text(
                'Breast Milk'.tr,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
              subtitle: Text(
                'List milk to sell or donate for free'.tr,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: Colors.grey.shade400,
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                Get.to(() => AddItemScreen(isMilk: true))?.then(
                  (_) => onListed?.call(),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
