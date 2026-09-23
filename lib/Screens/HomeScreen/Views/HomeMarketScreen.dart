import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/MarketListingModel.dart';
import 'package:mommilk_user/Screens/Dashboard/Controller/DashboardController.dart';
import 'package:mommilk_user/Screens/MarketScreen/ListingTypeSheet.dart';
import 'package:mommilk_user/Screens/MarketScreen/MyListingScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/ProductDetailScreen.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart' show getTimeOfDay;
import 'package:mommilk_user/Screens/MarketScreen/Service/market_controller.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/SearchDonarScreen.dart';

/// Home tab (tab 0) screen — a pixel-matched rebuild of the "Market" mock:
/// hero offer banner, category icon tiles, "Add Your Product" prompt, and a
/// "Featured Products" grid, all backed by the real MarketController /
/// marketplace listing API (the same data source Market_screen.dart uses).
class HomeMarketScreen extends StatefulWidget {
  const HomeMarketScreen({super.key});

  @override
  State<HomeMarketScreen> createState() => _HomeMarketScreenState();
}

class _HomeMarketScreenState extends State<HomeMarketScreen> {
  late MarketController controller;
  final TextEditingController searchController = TextEditingController();
  final PageController _bannerController = PageController();
  int _bannerIndex = 0;
  String selectedCategory = 'All';
  // Client-side sort applied via MarketController.applySort — shared with
  // the Market tab's own controller instance.
  String _sortBy = '';
  // Filters — same set/semantics as Market_screen.dart's Filters sheet.
  String? selectedCondition;
  RangeValues _priceRange = const RangeValues(0, 50000);
  double _maxDistance = 50;
  bool _distanceFilterActive = false;
  // Purely cosmetic — no backend "favorite/wishlist" field exists, so this
  // only toggles the heart icon locally for this session.
  final Set<int> _favorited = {};

  static const Color _red = Color(0xFFE8453C);
  static const Color _redLight = Color(0xFFFFF0EF);

  final List<_CatTile> _categories = const [
    _CatTile('All', Icons.grid_view_rounded, Color.fromARGB(255, 184, 211, 237), Colors.white),
    _CatTile(
      'Milk',
      Icons.water_drop_outlined,
      Color(0xFFFCE7F3),
      Color(0xFFEC4899),
    ),
    _CatTile(
      'Cradles',
      Icons.crib_outlined,
      Color(0xFFFFE8EF),
      Color(0xFFDB2777),
    ),
    _CatTile('Toys', Icons.toys_outlined, Color(0xFFE2F0FF), Color(0xFF2563EB)),
    _CatTile(
      'Clothing',
      Icons.checkroom_outlined,
      Color(0xFFE2F7E7),
      Color(0xFF16A34A),
    ),
    _CatTile(
      'Strollers',
      Icons.stroller_outlined,
      Color(0xFFF0E7FB),
      Color(0xFF7C3AED),
    ),
    _CatTile(
      'Others',
      Icons.more_horiz_rounded,
      Color(0xFFFDF3E3),
      Color(0xFFB45309),
    ),
  ];

  // Full category list — same set as Market_screen.dart's "All Categories"
  // sheet — shown when the "Others" tile is tapped.
  static const List<String> _allCats = [
    'All',
    'Milk',
    'Cradles',
    'Toys',
    'Clothing',
    'Strollers',
    'Car Seats',
    'Feeding',
    'Bath',
    'Safety',
    'Books',
    'Educational',
    'Other',
  ];

  String _catApiValue(String label) {
    if (label == 'All') return '';
    return label.toUpperCase().replaceAll(' ', '_');
  }

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<MarketController>()
        ? Get.find<MarketController>()
        : Get.put(MarketController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMarketplaceListings(
        category: _catApiValue(selectedCategory),
      );
      controller.fetchFeaturedListings();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  void _selectCategory(String cat) {
    setState(() => selectedCategory = cat);
    _filter();
  }

  // "Others" tile opens the full category list — same "All Categories"
  // bottom sheet Market_screen.dart shows — instead of filtering to a
  // literal "OTHERS" category.
  void _showAllCategories() => showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Categories'.tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allCats.map((cat) {
              final sel = selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _selectCategory(cat);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? _red : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    cat.tr,
                    style: TextStyle(
                      color: sel ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );

  // Re-fetches with every active filter/search/sort applied — same
  // minPrice=0/maxPrice=0 "no bound" convention as Market_screen.dart.
  void _filter() {
    final int minP = _priceRange.start.toInt();
    final int maxP = _priceRange.end.toInt() >= 50000
        ? 0
        : _priceRange.end.toInt();

    controller.fetchMarketplaceListings(
      searchText: searchController.text.trim(),
      category: _catApiValue(selectedCategory),
      condition: selectedCondition ?? '',
      minPriceVal: minP,
      maxPriceVal: maxP,
      maxDistanceVal: _distanceFilterActive ? _maxDistance : 0,
      sortByVal: _sortBy,
      page: 1,
      isRefresh: true,
    );
  }

  int get _activeFilterCount {
    int count = 0;
    if (selectedCondition != null) count++;
    if (_priceRange.start > 0 || _priceRange.end < 50000) count++;
    if (_distanceFilterActive) count++;
    return count;
  }

  void _goToMarketTab({
    String? search,
    String? category,
    bool openFilter = false,
  }) {
    Get.find<DashboardController>().goToMarket(
      search: search,
      category: category,
      openFilter: openFilter,
    );
  }

  // Filter bottom sheet — same fields/behavior as Market_screen.dart's
  // Filters sheet (Condition / Price Range / Distance), opened right here
  // on the Home tab instead of navigating to the Market tab.
  void _showFilter() {
    String? tempCondition = selectedCondition;
    RangeValues tempPrice = _priceRange;
    double tempDist = _maxDistance;
    bool tempDistActive = _distanceFilterActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            0,
            20.w,
            20.h + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Filters'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setSheet(() {
                          tempCondition = null;
                          tempPrice = const RangeValues(0, 50000);
                          tempDist = 50;
                          tempDistActive = false;
                        });
                      },
                      child: Text(
                        'Clear All'.tr,
                        style: TextStyle(
                          color: _red,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Divider(color: Colors.grey.shade200),
                SizedBox(height: 16.h),
                Text(
                  'Condition'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    for (final c in ['NEW', 'LIKE_NEW', 'GOOD', 'FAIR', 'POOR'])
                      GestureDetector(
                        onTap: () => setSheet(
                          () => tempCondition = tempCondition == c ? null : c,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: tempCondition == c ? _red : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: tempCondition == c
                                  ? _red
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            _condLabel(c),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: tempCondition == c
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 24.h),
                Divider(color: Colors.grey.shade200),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Text(
                      'Price Range'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _redLight,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '\$${tempPrice.start.toInt()}  –  ${tempPrice.end.toInt() >= 50000 ? 'Any'.tr : '\$${tempPrice.end.toInt()}'}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: _red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                SliderTheme(
                  data: SliderTheme.of(ctx).copyWith(
                    activeTrackColor: _red,
                    inactiveTrackColor: Colors.grey.shade200,
                    thumbColor: _red,
                    overlayColor: _red.withOpacity(0.12),
                    rangeThumbShape: const RoundRangeSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    trackHeight: 4,
                  ),
                  child: RangeSlider(
                    min: 0,
                    max: 50000,
                    divisions: 100,
                    values: tempPrice,
                    onChanged: (v) => setSheet(() => tempPrice = v),
                  ),
                ),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: [
                    for (final preset in [
                      ['${'Under'.tr} \$500', const RangeValues(0, 500)],
                      ['\$500–\$2000', const RangeValues(500, 2000)],
                      ['\$2000–\$5000', const RangeValues(2000, 5000)],
                      ['\$5000+', const RangeValues(5000, 50000)],
                    ])
                      GestureDetector(
                        onTap: () => setSheet(
                          () => tempPrice = preset[1] as RangeValues,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: tempPrice == preset[1]
                                ? _red
                                : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Text(
                            preset[0] as String,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: tempPrice == preset[1]
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 24.h),
                Divider(color: Colors.grey.shade200),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Text(
                      'Distance'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: tempDistActive,
                        activeColor: _red,
                        onChanged: (v) => setSheet(() => tempDistActive = v),
                      ),
                    ),
                  ],
                ),
                if (tempDistActive) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: _red, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        '${'Within'.tr} ${tempDist.toInt()} km',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: _red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(ctx).copyWith(
                      activeTrackColor: _red,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: _red,
                      overlayColor: _red.withOpacity(0.12),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                      ),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      min: 1,
                      max: 100,
                      divisions: 99,
                      value: tempDist,
                      onChanged: (v) => setSheet(() => tempDist = v),
                    ),
                  ),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: [
                      for (final km in [5.0, 10.0, 25.0, 50.0])
                        GestureDetector(
                          onTap: () => setSheet(() => tempDist = km),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: tempDist == km
                                  ? _red
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Text(
                              '${km.toInt()} km',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: tempDist == km
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ] else
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      'Enable to filter by distance from you'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                SizedBox(height: 28.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCondition = tempCondition;
                        _priceRange = tempPrice;
                        _maxDistance = tempDist;
                        _distanceFilterActive = tempDistActive;
                      });
                      _filter();
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      'Apply Filters'.tr,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _condColor(String c) {
    switch (c) {
      case 'NEW':
      case 'LIKE_NEW':
      case 'EXCELLENT':
        return const Color(0xFF16A34A);
      case 'GOOD':
        return const Color(0xFF2563EB);
      case 'FAIR':
        return const Color(0xFFF97316);
      case 'POOR':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
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
        return 'Good Condition'.tr;
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
      backgroundColor: const Color(0xFFF7F1F1),
      body: SafeArea(
        child: GetBuilder<MarketController>(
          builder: (_) => RefreshIndicator(
            color: _red,
            onRefresh: () => Future.wait([
              controller.refreshMarketplace(),
              controller.fetchFeaturedListings(),
            ]),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _header(),
                // Buyer-only hero banner, placed first (before the promo
                // carousel) so finding a donor is the first thing a Buyer
                // sees on Home — Donor's screen is untouched below this.
                // if (user.userType != 'DONOR') ...[
                //   const SizedBox(height: 10),
                //   _findDonorHeroBanner(),
                // ],
                _banner(),
                const SizedBox(height: 14),
                _searchBar(),
                const SizedBox(height: 14),
                _categoryTiles(),
                const SizedBox(height: 16),
                // Donor keeps the existing "Add Your Product" prompt
                // unchanged; Buyer sees a "Find a Donor" prompt instead —
                // everything else on this screen (banner, search, category
                // tiles, featured products) stays identical for both roles.
                user.userType == 'DONOR'
                    ? _addProductCard()
                    :   _findDonorHeroBanner(),
                const SizedBox(height: 20),
                _featuredHeader(),
                const SizedBox(height: 10),
                _productGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── HEADER ─────────────────────────────────────────────────────────────
  // Same plain icon-box + title/subtitle row as before — just swapped the
  // content for a time-of-day greeting instead of the static "Market" title.
  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD9D5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Image.asset(
            'assets/AppIcon.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good".tr + ' ${getTimeOfDay()}, ${user.name}!'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: -0.4,
                  height: 1.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Buy and sell pre-loved baby products'.tr,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ── HERO BANNER ────────────────────────────────────────────────────────
  static const List<Map<String, String>> _banners = [
    {
      'tag': 'SPECIAL OFFER',
      'title': 'Quality Baby Products\nat Great Prices',
      'subtitle': 'Give pre-loved items a new home\nand make a difference',
      'badge': 'Up to 50% OFF',
    },
    {
      'tag': 'NEW ARRIVALS',
      'title': 'Fresh Listings\nEvery Day',
      'subtitle': 'Browse new pre-loved finds from\ntrusted parents near you',
      'badge': 'Just In',
    },
    {
      'tag': 'COMMUNITY',
      'title': 'Sell What You\nNo Longer Need',
      'subtitle': 'List your baby items in minutes\nand help another family',
      'badge': 'Free to List',
    },
  ];

  Widget _banner() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
    child: Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (i) => setState(() => _bannerIndex = i),
            itemCount: _banners.length,
            itemBuilder: (_, i) => _bannerSlide(_banners[i]),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            final active = i == _bannerIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: active ? _red : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    ),
  );

  Widget _bannerSlide(Map<String, String> data) => Container(
    padding: EdgeInsets.fromLTRB(14.sp, 10.sp, 14.sp, 10.sp),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFfde8e9), Color(0xFFfed9cd)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      data['tag']!.tr,
                      style:  TextStyle(
                        color: _red,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data['title']!.tr,
                    style:  TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                   SizedBox(height: 5.h),
                  Text(
                    data['subtitle']!.tr,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10.sp,
                      height: 1.2.h,
                    ),
                  ),
              SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () => _goToMarketTab(),
                    child: Container(
                      padding:  EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xfffd604d),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Shop Now'.tr,
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Positioned(
                    top: -4,
                    right: 18,
                    child: Text('💗', style: TextStyle(fontSize: 16)),
                  ),
                  const Text('🧸', style: TextStyle(fontSize: 58)),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _red,
              shape: BoxShape.circle,
            ),
            child: _bannerBadgeText(data['badge']!),
          ),
        ),
      ],
    ),
  );

  Widget _bannerBadgeText(String badge) {
    // "Up to 50% OFF" gets a stacked "Up to / 50% / OFF" treatment (matching
    // the mock); other badges ("Just In", "Free to List") render as one
    // centered block.
    final parts = badge.split(' ');
    if (badge.toLowerCase().startsWith('up to') && parts.length >= 4) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${parts[0]} ${parts[1]}'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            parts[2],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          Text(
            parts[3].tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }
    return Text(
      badge.tr,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
    );
  }

  // ── SEARCH BAR ─────────────────────────────────────────────────────────
 Widget _searchBar() => Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.w),
  child: Row(
    children: [
      Expanded(
        child: Container(
          height: 35.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) =>
                _goToMarketTab(search: value.trim()),
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,

              hintText: 'Search for baby products...'.tr,

              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),

              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade400,
                size: 20,
              ),
              isDense: true,
          
            contentPadding: EdgeInsets.symmetric(vertical: 5.h),
          
            ),
          ),
        ),
      ),

      SizedBox(width: 10.w),

      GestureDetector(
        onTap: _showFilter,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD9D5),
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.tune,
                size: 20,
                color: Color(0xFFFC7A71),
              ),
            ),
            if (_activeFilterCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: _red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$_activeFilterCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  ),
);

  // ── CATEGORY TILES ────────────────────────────────────────────────────
Widget _categoryTiles() => SizedBox(
  height: 65.w,
  width:65.w,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 14.w,vertical:2.h),
    itemCount: _categories.length,
    separatorBuilder: (_, __) => SizedBox(width: 8.w.w),
    itemBuilder: (_, i) {
      final cat = _categories[i];
      final sel = selectedCategory == cat.label;

      return GestureDetector(
        onTap: cat.label == 'Others'
            ? _showAllCategories
            : () => _selectCategory(cat.label),
        child: Container(
          width: 64.w,
          height: 64.w,
          padding: EdgeInsets.only(
            top: 8.h,
            bottom: 6.h,
          ),
          decoration: BoxDecoration(
            color: sel
                ? const Color(0xFFFFF5F3)
                : cat.bg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: sel
                  ? _red
                  : Colors.black.withOpacity(0.03),
              width: sel ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Icon(
                cat.icon,
                color: sel ? _red : cat.fg,
                size: 23.sp,
              ),

              SizedBox(height: 4.h),

              // Category name
              Text(
                cat.label.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: sel
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: sel
                      ? _red
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
);
  // ── ADD YOUR PRODUCT ──────────────────────────────────────────────────
  Widget _addProductCard() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: GestureDetector(
      onTap: () => showListingTypeSheet(
        context,
        onListed: () {
          controller.fetchMarketplaceListings(
            category: _catApiValue(selectedCategory),
            page: 1,
            isRefresh: true,
          );
          controller.fetchFeaturedListings();
        },
      ),
      child: CustomPaint(
        foregroundPainter: _DashedRRectPainter(
          color: _red.withOpacity(0.5),
          radius: 16,
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _redLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 58,
                height: 58,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD9D5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Positioned(
                      top: 2,
                      left: 6,
                      child: Icon(Icons.add, color: _red, size: 10),
                    ),
                    const Positioned(
                      bottom: 4,
                      left: 2,
                      child: Icon(Icons.add, color: _red, size: 8),
                    ),
                    const Positioned(
                      top: 6,
                      right: 4,
                      child: Icon(Icons.add, color: _red, size: 7),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _red,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Your Product'.tr,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'List your pre-loved baby items and help another family'
                          .tr,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color:Color(0xfffe514c),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      'Add Product'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // ── FIND DONORS HERO (Buyer only) ─────────────────────────────────────
  // First thing a Buyer sees on Home, ahead of the promo carousel — a bold
  // standalone CTA distinct from the softer pastel banner slides below it.
  Widget _findDonorHeroBanner() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: GestureDetector(
      onTap: () => Get.to(() => Searchdonarscreen()),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF9472)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volunteer_activism,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Trusted Donors'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Connect with verified milk donors near you'.tr,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search, color: Color(0xFFFF6B6B), size: 14),
                  const SizedBox(width: 3),
                  Text(
                    'Search'.tr,
                    style: const TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  // ── FEATURED HEADER ───────────────────────────────────────────────────
  Widget _featuredHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        Text(
          'Featured Products'.tr,
          style:  TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _goToMarketTab(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All'.tr,
                style: const TextStyle(
                  color: _red,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.arrow_forward, color: _red, size: 13),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _productGrid() {
    if (controller.isLoadingFeatured && controller.featuredListings.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: _red)),
      );
    }
    if (!controller.isLoadingFeatured && controller.featuredListings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No featured products yet'.tr,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),
      );
    }
    // 2×2 preview grid, matching the mock.
    final items = controller.featuredListings.take(4).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          // Content-driven height (image at aspectRatio 1.7 + title + price
          // row + saved row + Chat/View bar + card padding) — no leftover
          // blank space, no overflow.
          mainAxisExtent: 205.h,
        ),
        itemBuilder: (_, i) => _productCard(items[i]),
      ),
    );
  }


Widget _productCard(MarketplaceListing p) {
  final img = p.images.isNotEmpty ? p.images.first.url : '';
  final condColor = _condColor(p.condition);
  final condLabel = _condLabel(p.condition);
  final int? origPrice = p.originPrice;
  final int? discPct = p.discountPercent;
  final fav = _favorited.contains(p.id);
  final savedBy = p.count.savedBy;

  return GestureDetector(
    onTap: () => Get.to(
      () => ProductDetailsScreen(
        listingId: p.id,
        distanceKm: p.distanceKm,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.10),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(10.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =========================================================
          // IMAGE
          // =========================================================
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13.r),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: img.isNotEmpty
                      ? Image.network(
                          img,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
              ),

              // -----------------------------------------------------
              // CONDITION BADGE
              // -----------------------------------------------------
              Positioned(
                top: 7.h,
                left: 7.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: condColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    condLabel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // =========================================================
          // PRODUCT TITLE
          // =========================================================
          Text(
            p.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF242033),
            ),
          ),

          SizedBox(height: 3.h),

          // =========================================================
          // PRICE + ORIGINAL PRICE + DISCOUNT
          // =========================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${p.currencySymbol}${p.price}',
                style: TextStyle(
                  color: _red,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              if (origPrice != null) ...[
                SizedBox(width: 8.w),

                Text(
                  '${p.currencySymbol}$origPrice',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 11.sp,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey.shade400,
                  ),
                ),
              ],

              if (discPct != null) ...[
                SizedBox(width: 8.w),

                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDF7E8),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '$discPct% OFF',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF16A34A),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 2.h),

          // =========================================================
          // SAVED / RATING STYLE ROW
          // =========================================================
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                size: 14.sp,
                color: const Color(0xFFFFB800),
              ),

              SizedBox(width: 3.w),

              Text(
                savedBy > 0
                    ? '$savedBy ${'saved'.tr}'
                    : '—',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // =========================================================
          // CHAT / VIEW BUTTON
          // =========================================================
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              color: _redLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [

                // CHAT
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.initiatePurchaseChat(
                      listingId: p.id,
                      sellerId: p.userId,
                      sellerName: p.user.name,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14.sp,
                          color: _red,
                        ),

                        SizedBox(width: 5.w),

                        Text(
                          'Chat'.tr,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: _red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // DIVIDER
                Container(
                  width: 1,
                  height: 24.h,
                  color: _red.withOpacity(0.10),
                ),

                // VIEW
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(
                      () => ProductDetailsScreen(
                        listingId: p.id,
                        distanceKm: p.distanceKm,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: 14.sp,
                          color: _red,
                        ),

                        SizedBox(width: 5.w),

                        Text(
                          'View'.tr,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: _red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
class _CatTile {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  const _CatTile(this.label, this.icon, this.bg, this.fg);
}

/// Paints a dashed rounded-rectangle border — Flutter's BoxDecoration only
/// supports a solid Border, so the "Add Your Product" card's dashed outline
/// is drawn manually via CustomPaint instead.
class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  const _DashedRRectPainter({
    required this.color,
    required this.radius,
    this.strokeWidth = 1.4,
    this.dashWidth = 6,
    this.dashGap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in (Path()..addRRect(rrect)).computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.dashGap != dashGap;
}

Widget _placeholder() => Container(
  color: const Color(0xFFF0F0F0),
  child: Center(
    child: Icon(Icons.image_outlined, size: 26, color: Colors.grey.shade400),
  ),
);
