import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/MarketScreen/SellerProfileScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/market_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int listingId;
  final double? distanceKm;
  ProductDetailsScreen({super.key, required this.listingId, this.distanceKm});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final MarketController _ctrl = Get.find<MarketController>();
  final PageController _pageCtrl = PageController();
  int _imgIndex = 0;

  static const Color _red = Color(0xFFE8453C);
  static const Color _redLight = Color(0xFFFFF0EF);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.clearMarketplaceDetails();
      _ctrl.fetchMarketplaceDetails(widget.listingId);
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Color _conditionColor(String c) {
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

  String _conditionLabel(String c) {
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

  Color _categoryBadgeColor(String cat) {
    switch (cat) {
      case 'TOYS':
        return Color(0xFF7C3AED);
      case 'CRADLES':
        return Color(0xFFEC4899);
      case 'STROLLERS':
        return Color(0xFF2563EB);
      case 'CLOTHING':
        return Color(0xFFF59E0B);
      case 'FEEDING':
        return Color(0xFF10B981);
      default:
        return Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
      builder: (ctrl) {
        if (ctrl.isDetailsLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(color: _red)),
          );
        }
        final p = ctrl.marketplaceDetails;
        if (p == null) {
          return Scaffold(body: Center(child: Text('No product found'.tr)));
        }

        final condColor = _conditionColor(p.condition);
        final condLabel = _conditionLabel(p.condition);
        final images = p.images;

        final catLabel = p.category
            .split('_')
            .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
            .join(' ')
            .tr;

        final int? originPrice = p.originPrice;
        final int? discountPct = p.discountPercent;
        final String? usedDuration = p.usedDuration;
        final int totalListings = p.user.totalListingsCount;
        final String activeAgo = p.user.activeAgo;
        final String joinedLabel = p.user.joinedLabel;

        final String? brand = p.brand;
        final String? material = p.materials.isNotEmpty
            ? p.materials.join(', ')
            : null;
        final String? color = p.colors.isNotEmpty ? p.colors.join(', ') : null;
        final String? dimensions = p.dimensions;

        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: _bottomBar(p),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _heroImageCard(
                    images,
                    condColor,
                    condLabel,
                    catLabel,
                    p.category,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 14.h),

                        // Title
                        Text(
                          p.title,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Price row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${p.currencySymbol}${p.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: _red,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (originPrice != null)
                              Text(
                                '${p.currencySymbol}${originPrice!}',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 15.sp,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey.shade400,
                                ),
                              ),
                            SizedBox(width: 8.w),
                            if (discountPct != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Text(
                                  '$discountPct% OFF',
                                  style: TextStyle(
                                    color: Color(0xFF16A34A),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        // Condition row
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: condColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(7.r),
                              ),
                              child: Text(
                                condLabel,
                                style: TextStyle(
                                  color: condColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (usedDuration != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: Text(
                                  '${'Used'.tr} $usedDuration',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            SizedBox(width: 8.w),
                            if (originPrice != null)
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${'Original Price'.tr}: ${'${p.currencySymbol}${originPrice!}'}',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey.shade500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Icon(
                                      Icons.info_outline,
                                      size: 13.sp,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 14.h),

                        // Seller card
                        Container(
                          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tapping the seller opens their public profile
                              // (name, bio & their other active listings).
                              GestureDetector(
                                onTap: () => Get.to(
                                  () => SellerProfileScreen(userId: p.user.id),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: Color(0xFFFFD7CF),
                                      child: Text(
                                        p.user.name.isNotEmpty
                                            ? p.user.name[0].toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.user.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(height: 3.h),
                                          Text(
                                            '${'Active'.tr} $activeAgo  •  $totalListings ${'Listings'.tr}',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.grey.shade500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey.shade400,
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Divider(height: 1.h, color: Colors.grey.shade200),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: _red,
                                    size: 15.sp,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    p.placeName.isNotEmpty ? p.placeName : '—',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    widget.distanceKm != null
                                        ? (widget.distanceKm! < 10
                                              ? '${widget.distanceKm!.toStringAsFixed(1)} km'
                                              : '${widget.distanceKm!.round()} km')
                                        : '— km',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // Product Details — description always fully shown, NO view more/less
                        Text(
                          'Product Details'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          p.description,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            height: 1.55.h,
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Spec grid — always fully shown, NO view more/less
                        _specGrid([
                          _Spec(
                            Icons.sell_outlined,
                            'Category'.tr,
                            catLabel.isNotEmpty ? catLabel : '—',
                          ),
                          _Spec(Icons.star_border, 'Condition'.tr, condLabel),
                          if (brand != null)
                            _Spec(
                              Icons.branding_watermark_outlined,
                              'Brand'.tr,
                              brand,
                            ),
                          _Spec(
                            Icons.people_outline,
                            'Suitable For'.tr,
                            '0 – 24 Months'.tr,
                          ),
                          if (material != null)
                            _Spec(Icons.texture, 'Material'.tr, material),
                          if (dimensions != null)
                            _Spec(
                              Icons.straighten,
                              'Dimensions'.tr,
                              dimensions,
                            ),
                          if (color != null)
                            _Spec(Icons.color_lens_outlined, 'Color'.tr, color),
                          if (p.boxContains.isNotEmpty)
                            _Spec(
                              Icons.inventory_2_outlined,
                              'Box Contains'.tr,
                              p.boxContains.join(', '),
                            ),
                        ]),

                        SizedBox(height: 18.h),
                        Divider(color: Colors.grey.shade200),
                        SizedBox(height: 14.h),

                        // About the Seller
                        Text(
                          'About the Seller'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _aboutRow(Icons.calendar_today_outlined, joinedLabel),
                        SizedBox(height: 10.h),
                        _aboutRow(
                          Icons.chat_outlined,
                          'Responds within 1 hour'.tr,
                        ),
                        SizedBox(height: 10.h),
                        _aboutRow(
                          Icons.bolt_outlined,
                          'Usually replies quickly'.tr,
                        ),

                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _heroImageCard(
    List images,
    Color condColor,
    String condLabel,
    String catLabel,
    String category,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: _circleBtn(Icons.arrow_back_ios_new, size: 15.sp),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: SizedBox(
              height: 260.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  images.isNotEmpty
                      ? PageView.builder(
                          controller: _pageCtrl,
                          itemCount: images.length,
                          onPageChanged: (i) => setState(() => _imgIndex = i),
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Colors.black87,
                                builder: (_) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: EdgeInsets.zero,
                                  child: Stack(
                                    children: [
                                      InteractiveViewer(
                                        minScale: 0.5,
                                        maxScale: 4.0,
                                        child: Center(
                                          child: Image.network(
                                            images[i].url,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.broken_image,
                                              color: Colors.white,
                                              size: 60.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 40.h,
                                        right: 16.w,
                                        child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            width: 34.w,
                                            height: 34.h,
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              images[i].url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade100,
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 48.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.image_outlined,
                            size: 48.sp,
                            color: Colors.grey,
                          ),
                        ),
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Text(
                        catLabel.toUpperCase(),
                        style: TextStyle(
                          color: _categoryBadgeColor(category),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 14.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: condColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '$condLabel ${'Condition'.tr}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 14.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${_imgIndex + 1} / ${images.length}',
                          style: TextStyle(color: Colors.white, fontSize: 11.sp),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final active = i == _imgIndex;
                return GestureDetector(
                  onTap: () => _pageCtrl.animateToPage(
                    i,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: active ? 20.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: active ? _red : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                );
              }),
            ),
          ),
        if (images.length > 1)
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
            child: SizedBox(
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (_, i) {
                  final active = i == _imgIndex;
                  return GestureDetector(
                    onTap: () => _pageCtrl.animateToPage(
                      i,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    ),
                    child: Container(
                      width: 60.w,
                      height: 60.h,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: active ? _red : Colors.grey.shade300,
                          width: active ? 2.w : 1.w,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.r),
                        child: Image.network(
                          images[i].url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade100,
                            child: Icon(
                              Icons.image_outlined,
                              size: 20.sp,
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
          ),
      ],
    );
  }

  Widget _circleBtn(
    IconData icon, {
    Color iconColor = Colors.black,
    double? size,
  }) => Container(
    width: 36.w,
    height: 36.h,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6),
      ],
    ),
    child: Icon(icon, size: size ?? 17.sp, color: iconColor),
  );

  Widget _bottomBar(dynamic p) => Container(
    padding: EdgeInsets.fromLTRB(
      16.w,
      12.h,
      16.w,
      16.h + MediaQuery.of(context).padding.bottom,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton.icon(
        // No cart/checkout — this starts (or resumes) a chat with the
        // seller, seeded by the backend with a message referencing this
        // listing, then jumps straight into that chat.
        onPressed: _ctrl.isInitiatingChat
            ? null
            : () => _ctrl.initiatePurchaseChat(
                listingId: p.id,
                sellerId: p.user.id,
                sellerName: p.user.name,
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _red,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: _ctrl.isInitiatingChat
            ? SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: Colors.white,
                ),
              )
            : Icon(Icons.chat_bubble_outline, size: 18.sp),
        label: Text(
          'Chat With Seller'.tr,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );

  Widget _specGrid(List<_Spec> items) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _specCell(items[i])),
              SizedBox(width: 16.w),
              Expanded(
                child: i + 1 < items.length
                    ? _specCell(items[i + 1])
                    : SizedBox(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _specCell(_Spec s) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(s.icon, size: 15.sp, color: Colors.grey.shade400),
      SizedBox(width: 6.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.label,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
            ),
            SizedBox(height: 2.h),
            Text(
              s.value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _aboutRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 15.sp, color: Colors.grey.shade400),
      SizedBox(width: 8.w),
      Flexible(
        child: Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
        ),
      ),
    ],
  );
}

class _Spec {
  final IconData icon;
  final String label;
  final String value;
  const _Spec(this.icon, this.label, this.value);
}
