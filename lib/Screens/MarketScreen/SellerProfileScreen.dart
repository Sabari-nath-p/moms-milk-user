import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/SellerProfileModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/MarketScreen/ProductDetailScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/seller_profile_controller.dart';
import 'package:mommilk_user/theme/app_theme.dart';

/// Public seller/donor profile — reached by tapping a seller's name on a
/// marketplace listing card or on a product's detail page. Shows their bio
/// + all of their ACTIVE marketplace listings.
/// UI intentionally matches the rest of the Market feature (Market_screen /
/// ProductDetailScreen) — same red accent, same card/badge language.
class SellerProfileScreen extends StatefulWidget {
  final int userId;
  const SellerProfileScreen({super.key, required this.userId});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  static const Color _red = Color(0xFFE8453C);
  static const Color _redLight = Color(0xFFFFF0EF);

  late final SellerProfileController controller;

  // Which grid is shown when the seller has BOTH milk and other-product
  // listings — toggled via _categoryToggle(). Irrelevant (and hidden) when
  // they only have one kind, in which case that one is shown directly.
  bool _showMilkTab = true;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      SellerProfileController(),
      tag: 'seller_${widget.userId}',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile(widget.userId);
    });
  }

  @override
  void dispose() {
    Get.delete<SellerProfileController>(tag: 'seller_${widget.userId}');
    super.dispose();
  }

  // Actual backend category value for milk listings — matches the value
  // used everywhere else this app creates/filters milk listings (see
  // Additem_screen.dart's setMilkMode, add_marketcontroller.dart,
  // my_listing_controller.dart).
  static const String _milkCategory = 'MILK';
  static const Color _milkColor = Color(0xFFEC4899);
  static const Color _milkLight = Color(0xFFFCE7F3);

  // Cycled per-tag so a multi-tag bio doesn't read as one flat grey block —
  // same soft pastel-bg/solid-fg pairing as the Market category tiles.
  static const List<List<Color>> _tagPalette = [
    [Color(0xFFE2F7E7), Color(0xFF16A34A)],
    [Color(0xFFE2F0FF), Color(0xFF2563EB)],
    [Color(0xFFF0E7FB), Color(0xFF7C3AED)],
    [Color(0xFFFDF3E3), Color(0xFFB45309)],
    [Color(0xFFFCE7F3), Color(0xFFDB2777)],
  ];

  String _tagLabel(String tag) {
    return tag
        .split('_')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  Color _catColor(String apiVal) {
    switch (apiVal) {
      case 'MILK':
        return _milkColor;
      case 'TOYS':
        return Color(0xFF7C3AED);
      case 'CRADLES':
        return Color(0xFF9333EA);
      case 'STROLLERS':
        return Color(0xFF2563EB);
      case 'CLOTHING':
        return Color(0xFFF59E0B);
      case 'FEEDING':
        return Color(0xFF10B981);
      case 'BATH':
        return Color(0xFF06B6D4);
      case 'CAR_SEATS':
        return Color(0xFFEF4444);
      case 'SAFETY':
        return Color(0xFF0EA5E9);
      case 'BOOKS':
        return Color(0xFFF97316);
      case 'EDUCATIONAL':
        return Color(0xFF8B5CF6);
      default:
        return Color(0xFF6B7280);
    }
  }

  Color _condColor(String c) {
    switch (c) {
      case 'NEW':
      case 'LIKE_NEW':
      case 'EXCELLENT':
        return Color(0xFF16A34A);
      case 'GOOD':
        return Color(0xFFF59E0B);
      case 'FAIR':
        return Color(0xFFF97316);
      case 'POOR':
        return Color(0xFFDC2626);
      default:
        return Color(0xFF6B7280);
    }
  }

  String _condLabel(String c) {
    switch (c) {
      case 'LIKE_NEW':
        return 'Like New'.tr;
      case 'NEW':
        return 'New'.tr;
      case 'EXCELLENT':
        return 'Excellent'.tr;
      case 'GOOD':
        return 'Good'.tr;
      case 'FAIR':
        return 'Fair'.tr;
      case 'POOR':
        return 'Poor'.tr;
      default:
        return c.replaceAll('_', ' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Same warm off-white ground as the Market/Home tabs, not plain white.
      backgroundColor: const Color(0xFFF7F1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1F1),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Seller Profile'.tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17.sp,
          ),
        ),
      ),
      body: GetBuilder<SellerProfileController>(
        tag: 'seller_${widget.userId}',
        builder: (ctrl) {
          if (ctrl.isLoading) {
            return Center(child: CircularProgressIndicator(color: _red));
          }

          final profile = ctrl.profile;
          if (profile != null) {
            final milkListings = profile.marketplaceListings
                .where((l) => l.category == _milkCategory)
                .toList();
            final otherListings = profile.marketplaceListings
                .where((l) => l.category != _milkCategory)
                .toList();
            return RefreshIndicator(
              color: _red,
              onRefresh: () => controller.fetchProfile(widget.userId),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                      child: _profileHeader(profile),
                    ),
                  ),
                  if (profile.marketplaceListings.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(
                          child: Text(
                            'No active listings'.tr,
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ),
                      ),
                    )
                  else if (milkListings.isNotEmpty &&
                      otherListings.isNotEmpty) ...[
                    // Seller has both kinds — toggle between the two
                    // instead of stacking both grids.
                    _categoryToggle(
                      milkCount: milkListings.length,
                      otherCount: otherListings.length,
                    ),
                    _listingsGrid(
                      _showMilkTab ? milkListings : otherListings,
                    ),
                  ] else if (milkListings.isNotEmpty) ...[
                    // Only milk listings — show them directly, no toggle.
                    _sectionHeader(
                      icon: Icons.water_drop_outlined,
                      iconBg: _milkLight,
                      iconFg: _milkColor,
                      label: 'Milk'.tr,
                      count: milkListings.length,
                    ),
                    _listingsGrid(milkListings),
                  ] else ...[
                    // Only other products — show them directly, no toggle.
                    _sectionHeader(
                      icon: Icons.storefront_outlined,
                      iconBg: _redLight,
                      iconFg: _red,
                      label: ' Products'.tr,
                      count: otherListings.length,
                    ),
                    _listingsGrid(otherListings),
                  ],
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                ],
              ),
            );
          }
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                ctrl.errorMessage ?? 'Profile not found'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------
  // LISTING SECTION HELPERS
  // ---------------------------------------------------------------------
  Widget _sectionHeader({
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String label,
    required int count,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 10.h),
        child: Row(
          children: [
            Container(
              width: 30.w,
              height: 30.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 16.sp, color: iconFg),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Segmented pill toggle shown only when the seller has BOTH milk and
  // other-product listings, so browsing one doesn't require scrolling past
  // the other.
  Widget _categoryToggle({required int milkCount, required int otherCount}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 4.h),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: _toggleSegment(
                  icon: Icons.water_drop_outlined,
                  label: 'Milk'.tr,
                  count: milkCount,
                  selected: _showMilkTab,
                  onTap: () => setState(() => _showMilkTab = true),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _toggleSegment(
                  icon: Icons.storefront_outlined,
                  label: 'Products'.tr,
                  count: otherCount,
                  selected: !_showMilkTab,
                  onTap: () => setState(() => _showMilkTab = false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleSegment({
    required IconData icon,
    required String label,
    required int count,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15.sp,
              color: selected ? Colors.white : Colors.grey.shade600,
            ),
            SizedBox(width: 6.w),
            Text(
              '$label ($count)',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listingsGrid(List<SellerListingItem> items) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) => _listingCard(items[i]),
          childCount: items.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          // Sized to exactly fit the card's content (image + 2-line title +
          // price row + location row) — no leftover blank space at the
          // bottom of the card.
          mainAxisExtent: 214.h,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // PROFILE HEADER
  // ---------------------------------------------------------------------
  Widget _profileHeader(SellerProfileModel profile) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _avatar(profile),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name.isNotEmpty ? profile.name : 'Unknown'.tr,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: _redLight,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            profile.userType.isNotEmpty
                                ? profile.userType.tr
                                : '—',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: _red,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        if (profile.isDonor &&
                            profile.availableForDonation) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 10.sp,
                                  color: Color(0xFF16A34A),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  'Available'.tr,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (profile.description.trim().isNotEmpty) ...[
            SizedBox(height: 14.h),
            Divider(height: 1.h, color: Colors.grey.shade200),
            SizedBox(height: 12.h),
            Text(
              profile.description,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade700,
                height: 1.4.h,
              ),
            ),
          ],
          if (profile.tags.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: profile.tags.asMap().entries.map((entry) {
                final colors = _tagPalette[entry.key % _tagPalette.length];
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors[0],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _tagLabel(entry.value),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: colors[1],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 14.h),
          Divider(height: 1.h, color: Colors.grey.shade200),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppTheme.roundButtonGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  final c = Get.isRegistered<Chatcontroller>()
                      ? Get.find<Chatcontroller>()
                      : Get.put(Chatcontroller());
                  c.OpenChatUser(
                    userID: profile.id,
                    isDonar: profile.isDonor,
                    userName: profile.name,
                  );
                },
                icon: Icon(
                  Icons.chat_bubble_outline,
                  size: 17.sp,
                  color: Colors.white,
                ),
                label: Text(
                  'Chat'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(SellerProfileModel profile) {
    final photo = profile.profilePhoto;
    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
       color: AppTheme.primaryColor,
      ),
      child: (photo != null && photo.isNotEmpty)
          ? CircleAvatar(
              radius: 30.r,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  photo,
                  width: 68.w,
                  height: 68.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _avatarInitial(profile),
                ),
              ),
            )
          : CircleAvatar(
              radius: 34.r,
              backgroundColor: Colors.white,
              child: _avatarInitial(profile),
            ),
    );
  }

  Widget _avatarInitial(SellerProfileModel profile) => Text(
    profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
    style: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 24.sp,
      color: _red,
    ),
  );

  // ---------------------------------------------------------------------
  // LISTING CARD — same visual language as Market_screen's grid card
  // ---------------------------------------------------------------------
  Widget _listingCard(SellerListingItem item) {
    final img = item.images.isNotEmpty ? item.images.first.url : '';
    final condColor = _condColor(item.condition ?? '');
    final condLabel = _condLabel(item.condition ?? '');
    final catBadgeLabel = item.category.replaceAll('_', ' ');
    final badgeColor = _catColor(item.category);
    final int? discPct = item.discountPercent;

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsScreen(listingId: item.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: SizedBox(
                    height: 110.h,
                    width: double.infinity,
                    child: img.isNotEmpty
                        ? Image.network(
                            img,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      catBadgeLabel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                if (item.condition != null && item.condition!.isNotEmpty)
                  Positioned(
                    bottom: 7.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: condColor.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        condLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.25.h,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (item.isDonation)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Text(
                            'FREE'.tr,
                            style: TextStyle(
                              color: Color(0xFF16A34A),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      else
                        Text(
                          '₹${item.price}',
                          style: TextStyle(
                            color: _red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      if (!item.isDonation && discPct != null) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '$discPct% OFF',
                          style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if ((item.placeName ?? '').isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 11.sp, color: _red),
                        SizedBox(width: 2.w),
                        Flexible(
                          child: Text(
                            item.placeName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: Colors.grey.shade100,
    child: Center(
      child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 30.sp),
    ),
  );
}
