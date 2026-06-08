import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/market_controller.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int listingId;
  const ProductDetailsScreen({super.key, required this.listingId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final MarketController _ctrl = Get.find<MarketController>();
  final PageController _pageCtrl = PageController();
  int _imgIndex = 0;
  bool _descExpanded = false;
  bool _specsExpanded = true;

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
        return const Color(0xFF16A34A);
      case 'GOOD':
        return const Color(0xFFF59E0B);
      case 'FAIR':
        return const Color(0xFFF97316);
      case 'POOR':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _conditionLabel(String c) {
    switch (c) {
      case 'LIKE_NEW':
        return 'Like New';
      case 'NEW':
        return 'New';
      case 'EXCELLENT':
        return 'Excellent';
      case 'GOOD':
        return 'Good';
      case 'FAIR':
        return 'Fair';
      case 'POOR':
        return 'Poor';
      default:
        return c.replaceAll('_', ' ');
    }
  }

  Color _categoryBadgeColor(String cat) {
    switch (cat) {
      case 'TOYS':
        return const Color(0xFF7C3AED);
      case 'CRADLES':
        return const Color(0xFFEC4899);
      case 'STROLLERS':
        return const Color(0xFF2563EB);
      case 'CLOTHING':
        return const Color(0xFFF59E0B);
      case 'FEEDING':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
      builder: (ctrl) {
        if (ctrl.isDetailsLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFE8453C)),
            ),
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
            .join(' ');

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
                  // ── HERO IMAGE CARD (contained, rounded all sides) ──────────
                  _heroImageCard(
                    images,
                    condColor,
                    condLabel,
                    catLabel,
                    p.category,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),

                        // Title
                        Text(
                          p.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ── PRICE ROW ──────────────────────────────────────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '₹${p.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: _red,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (originPrice != null)
                              Text(
                                '₹$originPrice',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 15,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey.shade400,
                                ),
                              ),
                            const SizedBox(width: 8),
                            if (discountPct != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '$discountPct% OFF',
                                  style: const TextStyle(
                                    color: Color(0xFF16A34A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // ── CONDITION ROW ──────────────────────────────────────
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: condColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                condLabel,
                                style: TextStyle(
                                  color: condColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (usedDuration != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  'Used $usedDuration',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            if (originPrice != null)
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Original Price: ₹$originPrice',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Icon(
                                      Icons.info_outline,
                                      size: 13,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // ── SELLER CARD ────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: const Color(0xFFFFD7CF),
                                    child: Text(
                                      p.user.name.isNotEmpty
                                          ? p.user.name[0].toUpperCase()
                                          : 'U',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Name only — no rating, no verified
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                p.user.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        // Active • Listings • Sales
                                        Text(
                                          'Active $activeAgo  •  $totalListings Listings',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      'View Profile',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Divider(height: 1, color: Colors.grey.shade200),
                              const SizedBox(height: 10),
                              // Location row
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: _red,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    p.placeName.isNotEmpty ? p.placeName : '—',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '— km away',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // ── PRODUCT DETAILS ────────────────────────────────────
                        const Text(
                          'Product Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.description,
                          maxLines: _descExpanded ? null : 4,
                          overflow: _descExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.55,
                          ),
                        ),
                        if (p.description.length > 100)
                          GestureDetector(
                            onTap: () =>
                                setState(() => _descExpanded = !_descExpanded),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _descExpanded ? 'View less ∧' : 'View more ∨',
                                style: const TextStyle(
                                  color: _red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // ── SPEC GRID ──────────────────────────────────────────
                        _specGrid([
                          _Spec(
                            Icons.sell_outlined,
                            'Category',
                            catLabel.isNotEmpty ? catLabel : '—',
                          ),
                          _Spec(Icons.star_border, 'Condition', condLabel),
                          _Spec(
                            Icons.branding_watermark_outlined,
                            'Brand',
                            brand ?? '—',
                          ),
                          _Spec(
                            Icons.people_outline,
                            'Suitable For',
                            '0 – 24 Months',
                          ),
                          _Spec(Icons.texture, 'Material', material ?? '—'),
                          _Spec(
                            Icons.straighten,
                            'Dimensions',
                            dimensions ?? '—',
                          ),
                          _Spec(
                            Icons.color_lens_outlined,
                            'Color',
                            color ?? '—',
                          ),
                          _Spec(
                            Icons.category_outlined,
                            'Type',
                            p.boxContains.isNotEmpty
                                ? p.boxContains.join(', ')
                                : '—',
                          ),
                        ]),

                        GestureDetector(
                          onTap: () =>
                              setState(() => _specsExpanded = !_specsExpanded),
                          child: Text(
                            _specsExpanded ? 'View less ∧' : 'View more ∨',
                            style: const TextStyle(
                              color: _red,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 14),

                        // ── ABOUT THE SELLER ───────────────────────────────────
                        const Text(
                          'About the Seller',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _aboutRow(
                                    Icons.calendar_today_outlined,
                                    joinedLabel,
                                  ),
                                  const SizedBox(height: 10),
                                  _aboutRow(
                                    Icons.chat_outlined,
                                    'Responds within 1 hour',
                                  ),
                                  const SizedBox(height: 10),
                                  _aboutRow(
                                    Icons.bolt_outlined,
                                    'Usually replies quickly',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ), // SafeArea
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HERO IMAGE — back/share/heart are in a ROW above the image card
  // Image card has rounded corners on ALL sides, contained with padding
  // Category badge = white pill with colored text (top-left of image)
  // Condition badge = colored solid pill (bottom-left of image)
  // Counter = dark pill (bottom-right of image)
  // ══════════════════════════════════════════════════════════════════════════

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
        // ── TOP NAV ROW — back (left) + share/heart (right) ─────────────────
        // This is ABOVE the image card, in the white page area
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Get.back(),
                child: _circleBtn(Icons.arrow_back_ios_new, size: 15),
              ),
              const Spacer(),
              // Share
              _circleBtn(Icons.ios_share_outlined),
              const SizedBox(width: 8),
              // Heart
              _circleBtn(Icons.favorite_border, iconColor: Colors.red),
            ],
          ),
        ),

        // ── IMAGE CARD — contained, rounded all sides ────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 260,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image pager
                  images.isNotEmpty
                      ? PageView.builder(
                          controller: _pageCtrl,
                          itemCount: images.length,
                          onPageChanged: (i) => setState(() => _imgIndex = i),
                          itemBuilder: (_, i) => Image.network(
                            images[i].url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade100,
                              child: const Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade100,
                          child: const Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),

                  // Category badge — white pill top-left with colored text
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  // Condition badge — solid color bottom-left
                  Positioned(
                    bottom: 14,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: condColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$condLabel Condition',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // Image counter — bottom-right
                  if (images.length > 1)
                    Positioned(
                      bottom: 14,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_imgIndex + 1} / ${images.length}',
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
        ),
      ],
    );
  }

  Widget _circleBtn(
    IconData icon, {
    Color iconColor = Colors.black,
    double size = 17,
  }) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6),
      ],
    ),
    child: Icon(icon, size: size, color: iconColor),
  );

  // ── BOTTOM BAR ────────────────────────────────────────────────────────────

  Widget _bottomBar(dynamic p) => Container(
    padding: EdgeInsets.fromLTRB(
      16,
      12,
      16,
      16 + MediaQuery.of(context).padding.bottom,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              final c = Get.put(Chatcontroller());
              c.OpenChatUser(
                userID: p.user.id,
                isDonar: false,
                userName: p.user.name,
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: _red,
              side: const BorderSide(color: _red),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline, size: 17),
            label: const Text(
              'Chat With Seller',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Purchase feature coming soon!')),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Buy Now',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    ),
  );

  // ── SPEC GRID ─────────────────────────────────────────────────────────────

  Widget _specGrid(List<_Spec> items) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _specCell(items[i])),
              const SizedBox(width: 16),
              Expanded(
                child: i + 1 < items.length
                    ? _specCell(items[i + 1])
                    : const SizedBox(),
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
      Icon(s.icon, size: 15, color: Colors.grey.shade400),
      const SizedBox(width: 6),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 2),
            Text(
              s.value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _aboutRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 15, color: Colors.grey.shade400),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
