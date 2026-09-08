import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/SellerProfileModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';
import 'package:mommilk_user/Screens/MarketScreen/ProductDetailScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/seller_profile_controller.dart';

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

  Color _catColor(String apiVal) {
    switch (apiVal) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Seller Profile'.tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
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
          if (profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  ctrl.errorMessage ?? 'Profile not found'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: _red,
            onRefresh: () => controller.fetchProfile(widget.userId),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _profileHeader(profile),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                    child: Row(
                      children: [
                        Icon(Icons.storefront_outlined, size: 18, color: _red),
                        SizedBox(width: 6),
                        Text(
                          'Listings'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '(${profile.marketplaceListings.length})',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (profile.marketplaceListings.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No active listings'.tr,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) =>
                            _listingCard(profile.marketplaceListings[i]),
                        childCount: profile.marketplaceListings.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        // Sized to exactly fit the card's content (image +
                        // 2-line title + price row + location row) — no
                        // leftover blank space at the bottom of the card.
                        mainAxisExtent: 214,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------
  // PROFILE HEADER
  // ---------------------------------------------------------------------
  Widget _profileHeader(SellerProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _avatar(profile),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name.isNotEmpty ? profile.name : 'Unknown'.tr,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _redLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            profile.userType.isNotEmpty
                                ? profile.userType.tr
                                : '—',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _red,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        if (profile.isDonor &&
                            profile.availableForDonation) ...[
                          SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 10,
                                  color: Color(0xFF16A34A),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Available'.tr,
                                  style: TextStyle(
                                    fontSize: 10,
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
            SizedBox(height: 14),
            Divider(height: 1, color: Colors.grey.shade200),
            SizedBox(height: 12),
            Text(
              profile.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ],
          SizedBox(height: 14),
          Divider(height: 1, color: Colors.grey.shade200),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
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
              icon: Icon(Icons.chat_bubble_outline, size: 16, color: _red),
              label: Text(
                'Chat'.tr,
                style: TextStyle(color: _red, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: _red.withOpacity(0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
    if (photo != null && photo.isNotEmpty) {
      return CircleAvatar(
        radius: 32,
        backgroundColor: Color(0xFFFFD7CF),
        backgroundImage: NetworkImage(photo),
      );
    }
    return CircleAvatar(
      radius: 32,
      backgroundColor: Color(0xFFFFD7CF),
      child: Text(
        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: Colors.black87,
        ),
      ),
    );
  }

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
          borderRadius: BorderRadius.circular(16),
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
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 110,
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
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      catBadgeLabel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                if (item.condition != null && item.condition!.isNotEmpty)
                  Positioned(
                    bottom: 7,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: condColor.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        condLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (item.isDonation)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'FREE'.tr,
                            style: TextStyle(
                              color: Color(0xFF16A34A),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      else
                        Text(
                          '₹${item.price}',
                          style: TextStyle(
                            color: _red,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      if (!item.isDonation && discPct != null) ...[
                        SizedBox(width: 4),
                        Text(
                          '$discPct% OFF',
                          style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if ((item.placeName ?? '').isNotEmpty) ...[
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 11, color: _red),
                        SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            item.placeName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
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
      child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 30),
    ),
  );
}
