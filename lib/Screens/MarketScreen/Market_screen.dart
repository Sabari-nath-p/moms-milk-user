import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/MarketListingModel.dart';
import 'package:mommilk_user/Screens/MarketScreen/ListingTypeSheet.dart';
import 'package:mommilk_user/Screens/MarketScreen/MyListingScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/ProductDetailScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/SellerProfileScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/market_controller.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class MarketScreen extends StatefulWidget {
  // Optional filter handed off by another screen (e.g. the Home dashboard's
  // marketplace search bar / category chips via DashboardController) so the
  // real API call fires with this filter already applied on open.
  // [initialSearch] is the raw search text; [initialCategory] is the API
  // category value (e.g. "CRADLES") — pass null/empty for "browse all".
  final String? initialSearch;
  final String? initialCategory;
  // When true, the Filters bottom sheet (same one the tune icon on this
  // screen opens) is shown automatically as soon as the screen lands —
  // used when the user tapped a "filters" shortcut on another screen
  // (e.g. Home dashboard's marketplace search box) instead of the plain
  // "go to Marketplace" action.
  final bool openFilterOnStart;

  MarketScreen({
    super.key,
    this.initialSearch,
    this.initialCategory,
    this.openFilterOnStart = false,
  });
  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late MarketController controller;
  final ScrollController _scrollController = ScrollController();

  String selectedCategory = 'All'; // plain English key, .tr applied at render
  String? selectedCondition;
  RangeValues _priceRange = RangeValues(0, 50000);
  double _maxDistance = 50;
  bool _distanceFilterActive = false;
  String _sortBy = '';
  bool _isGridView = true; // toggle grid/list view
  final TextEditingController searchController = TextEditingController();

  static const Color _red = Color(0xFFE8453C);
  static const Color _redLight = Color(0xFFFFF0EF);
  static const Color _pageBg = Color(0xFFF7F1F1);

  final List<String> _visibleCats = [
    'All',
    'Cradles',
    'Toys',
    'Clothing',
    'Strollers',
  ];
  final List<String> _allCats = [
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

  // Sort options: label → controller key
  static List<(String, String)> get _sortOptions => [
    ('Newest First'.tr, 'newest'),
    ('Oldest First'.tr, 'oldest'),
    ('Price: Low to High'.tr, 'price_asc'),
    ('Price: High to Low'.tr, 'price_desc'),
  ];

  String _catApiValue(String label) {
    if (label == 'All') return '';
    return label.toUpperCase().replaceAll(' ', '_');
  }

  @override
  void initState() {
    super.initState();

    // Apply the incoming filter (if any) so both the visible chips/search
    // box and the actual API call reflect it from the first frame.
    if (widget.initialSearch != null &&
        widget.initialSearch!.trim().isNotEmpty) {
      searchController.text = widget.initialSearch!.trim();
    }
    if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
      selectedCategory = _allCats.firstWhere(
        (c) => _catApiValue(c) == widget.initialCategory,
        orElse: () => 'All',
      );
    }

    // Reuse the existing MarketController (shared with the Home tab's
    // Featured Products section) instead of tearing it down and rebuilding
    // it from scratch on every tab switch. MainDashboard recreates this
    // screen's whole widget subtree each time the Market tab is selected,
    // so deleting the controller here threw away its cached listings and
    // forced a full network round-trip — showing a spinner (then briefly
    // "No products found") on every visit, even when nothing had changed.
    // Keeping the controller lets its previous results render immediately
    // while a fresh fetch runs quietly in the background.
    controller = Get.isRegistered<MarketController>()
        ? Get.find<MarketController>()
        : Get.put(MarketController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMarketplaceListings(
        searchText: searchController.text.trim(),
        category: _catApiValue(selectedCategory),
      );
      if (widget.openFilterOnStart) _showFilter();
    });

    // Pagination: load more when user scrolls near the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filter() {
    // FIX: pass price range and sort to controller
    // minPrice = 0 means no lower bound; maxPrice = 50000 (max) means no upper bound
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

  Color _catColor(String apiVal) {
    switch (apiVal) {
      case 'MILK':
        return AppTheme.primaryColor;
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

  // FIX: human-readable label for current sort
  String get _sortLabel {
    for (final opt in _sortOptions) {
      if (opt.$2 == _sortBy) return opt.$1;
    }
    return 'Sort'.tr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showListingTypeSheet(
          context,
          onListed: () => controller.fetchMarketplaceListings(
            searchText: searchController.text.trim(),
            category: _catApiValue(selectedCategory),
            condition: selectedCondition ?? '',
            minPriceVal: _priceRange.start.toInt(),
            maxPriceVal: _priceRange.end.toInt() >= 50000
                ? 0
                : _priceRange.end.toInt(),
            maxDistanceVal: _distanceFilterActive ? _maxDistance : 0,
            sortByVal: _sortBy,
            page: 1,
            isRefresh: true,
          ),
        ),
        backgroundColor: _red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Icon(Icons.add, color: Colors.white, size: 26.sp),
      ),
      body: SafeArea(
        child: GetBuilder<MarketController>(
          builder: (_) => RefreshIndicator(
            color: _red,
            onRefresh: controller.refreshMarketplace,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(child: _appBar()),
                SliverToBoxAdapter(child: _searchBar()),
                SliverToBoxAdapter(child: _categoryBar()),
                SliverToBoxAdapter(child: _resultHeader()),
                if (controller.isLoading && controller.listings.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: _red),
                    ),
                  )
                else if (!controller.isLoading && controller.listings.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No products found'.tr,
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    ),
                  )
                else if (_isGridView)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _card(controller.listings[i]),
                        childCount: controller.listings.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        mainAxisExtent: 290.h,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _listCard(controller.listings[i]),
                        ),
                        childCount: controller.listings.length,
                      ),
                    ),
                  ),

                // ── Load more spinner / end indicator ──────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: controller.isLoadingMore
                        ? Center(
                            child: CircularProgressIndicator(
                              color: _red,
                              strokeWidth: 2.w,
                            ),
                          )
                        : controller.hasNextPage
                        ? const SizedBox.shrink()
                        : controller.listings.isNotEmpty
                        ? Center(
                            child: Text(
                              'You\'ve seen all items'.tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() => Padding(
    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Marketplace'.tr,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Buy and sell pre-loved baby products'.tr,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(() => MyListingsScreen()),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Color(0xFFEDD8D8), width: 1.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2_outlined, color: _red, size: 17.sp),
                SizedBox(width: 6.w),
                Text(
                  'My Listings'.tr,
                  style: TextStyle(
                    color: _red,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _searchBar() => Padding(
    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 46.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onSubmitted: (_) => _filter(),
              onChanged: (value) {
                Future.delayed(Duration(milliseconds: 600), () {
                  if (searchController.text.trim() == value.trim()) {
                    // Reset category to All when searching by text
                    if (value.trim().isNotEmpty && selectedCategory != 'All') {
                      setState(() => selectedCategory = 'All');
                    }
                    _filter();
                  }
                });
              },
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search for baby products'.tr,
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                  size: 20.sp,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: _showFilter,
          child: Stack(
            children: [
              Container(
                width: 46.w,
                height: 46.h,
                decoration: BoxDecoration(
                  color: _activeFilterCount > 0 ? _red : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.tune,
                  size: 20.sp,
                  color: _activeFilterCount > 0 ? Colors.white : _red,
                ),
              ),
              if (_activeFilterCount > 0)
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$_activeFilterCount',
                        style: TextStyle(
                          color: _red,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                        ),
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

  int get _activeFilterCount {
    int count = 0;
    if (selectedCondition != null) count++;
    if (_priceRange.start > 0 || _priceRange.end < 50000) count++;
    if (_distanceFilterActive) count++;
    return count;
  }

  void _showFilter() {
    String? _tempCondition = selectedCondition;
    RangeValues _tempPrice = _priceRange;
    double _tempDist = _maxDistance;
    bool _tempDistActive = _distanceFilterActive;

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
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        setSheet(() {
                          _tempCondition = null;
                          _tempPrice = RangeValues(0, 50000);
                          _tempDist = 50;
                          _tempDistActive = false;
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
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in ['NEW', 'LIKE_NEW', 'GOOD', 'FAIR', 'POOR'])
                      GestureDetector(
                        onTap: () => setSheet(
                          () => _tempCondition = _tempCondition == c ? null : c,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: _tempCondition == c ? _red : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: _tempCondition == c
                                  ? _red
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            _condLabel(c),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: _tempCondition == c
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
                    Spacer(),
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
                        '\$${_tempPrice.start.toInt()}  –  ${_tempPrice.end.toInt() >= 50000 ? 'Any'.tr : '\$${_tempPrice.end.toInt()}'}',
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
                    rangeThumbShape: RoundRangeSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    trackHeight: 4,
                  ),
                  child: RangeSlider(
                    min: 0,
                    max: 50000,
                    divisions: 100,
                    values: _tempPrice,
                    onChanged: (v) => setSheet(() => _tempPrice = v),
                  ),
                ),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final preset in [
                      ['${'Under'.tr} \$500', RangeValues(0, 500)],
                      ['\$500–\$2000', RangeValues(500, 2000)],
                      ['\$2000–\$5000', RangeValues(2000, 5000)],
                      ['\$5000+', RangeValues(5000, 50000)],
                    ])
                      GestureDetector(
                        onTap: () => setSheet(
                          () => _tempPrice = preset[1] as RangeValues,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: _tempPrice == preset[1]
                                ? _red
                                : Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Text(
                            preset[0] as String,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: _tempPrice == preset[1]
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
                    Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _tempDistActive,
                        activeColor: _red,
                        onChanged: (v) => setSheet(() => _tempDistActive = v),
                      ),
                    ),
                  ],
                ),
                if (_tempDistActive) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: _red, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        '${'Within'.tr} ${_tempDist.toInt()} km',
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
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      min: 1,
                      max: 100,
                      divisions: 99,
                      value: _tempDist,
                      onChanged: (v) => setSheet(() => _tempDist = v),
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final km in [5.0, 10.0, 25.0, 50.0])
                        GestureDetector(
                          onTap: () => setSheet(() => _tempDist = km),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: _tempDist == km ? _red : Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Text(
                              '${km.toInt()} km',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: _tempDist == km
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
                        selectedCondition = _tempCondition;
                        _priceRange = _tempPrice;
                        _maxDistance = _tempDist;
                        _distanceFilterActive = _tempDistActive;
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

  Widget _categoryBar() => Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: SizedBox(
      height: 36.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          ..._visibleCats.map((cat) {
            final sel = selectedCategory == cat;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () {
                  setState(() => selectedCategory = cat);
                  controller.selectedCategory = _catApiValue(cat);
                  _filter();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  decoration: BoxDecoration(
                    color: sel ? _red : _redLight,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: sel ? _red : Color(0xFFEDD8D8),
                      width: 1.w,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cat.tr,
                    style: TextStyle(
                      color: sel ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: _showAllCats,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: _redLight,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: Color(0xFFEDD8D8), width: 1.w),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'More'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  void _showAllCats() => showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Categories'.tr,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allCats.map((cat) {
              final sel = selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  setState(() => selectedCategory = cat);
                  controller.selectedCategory = _catApiValue(cat);
                  _filter();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? _red : Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Text(
                    cat.tr,
                    style: TextStyle(
                      color: sel ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    ),
  );

  Widget _resultHeader() => Padding(
    padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 10.h),
    child: Row(
      children: [
        Text(
          '${controller.listings.length} items',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Spacer(),
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: _red.withOpacity(0.10),
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Icon(Icons.grid_view_rounded, size: 17.sp, color: _red),
        ),
        SizedBox(width: 12.w),

        // ── Sort dropdown ───────────────────────────────────────────────────
        GestureDetector(
          onTap: _showSortSheet,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _sortBy.isNotEmpty ? _red : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: _sortBy.isNotEmpty ? _red : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  size: 14.sp,
                  color: _sortBy.isNotEmpty
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
                SizedBox(width: 4.w),
                Text(
                  _sortLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _sortBy.isNotEmpty
                        ? Colors.white
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 14.sp,
                  color: _sortBy.isNotEmpty
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  // FIX: Sort bottom sheet
  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'Sort By'.tr,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                if (_sortBy.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() => _sortBy = '');
                      controller.applySort('');
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Clear'.tr,
                      style: TextStyle(
                        color: _red,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            ..._sortOptions.map((opt) {
              final isSelected = _sortBy == opt.$2;
              return GestureDetector(
                onTap: () {
                  setState(() => _sortBy = opt.$2);
                  controller.applySort(opt.$2); // client-side sort, no re-fetch
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? _redLight : Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? _red.withOpacity(0.4)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        opt.$1,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? _red : Colors.black87,
                        ),
                      ),
                      Spacer(),
                      if (isSelected)
                        Icon(Icons.check_circle, color: _red, size: 18.sp),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _card(MarketplaceListing p) {
    final img = p.images.isNotEmpty ? p.images.first.url : '';
    final condColor = _condColor(p.condition);
    final condLabel = _condLabel(p.condition);
    final catApiVal = p.category.toUpperCase();
    final badgeColor = _catColor(catApiVal);
    final catBadgeLabel = p.category.toUpperCase().replaceAll('_', ' ');
    final int? origPrice = p.originPrice;
    final int? discPct = p.discountPercent;
    final String? usedDur = p.usedDuration;

    return GestureDetector(
      onTap: () => Get.to(
        () => ProductDetailsScreen(listingId: p.id, distanceKm: p.distanceKm),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
                // FIX 2: No fullscreen dialog on card — just navigate to detail
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: SizedBox(
                    height: 125.h,
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
                // Category badge — top left
                Positioned(
                  top: 9.h,
                  left: 9.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
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
                // FIX 1: Condition badge — bottom left inside photo
                Positioned(
                  bottom: 8.h,
                  left: 9.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.25.h,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${p.currencySymbol}${p.price}',
                          style: TextStyle(
                            color: _red,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        if (origPrice != null)
                          Text(
                            '${p.currencySymbol}${origPrice!}',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11.sp,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey.shade400,
                            ),
                          ),
                        SizedBox(width: 4.w),
                        if (discPct != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '$discPct% OFF',
                              style: TextStyle(
                                color: Color(0xFF16A34A),
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    if (usedDur != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(
                          '${'Used'.tr} $usedDur',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    SizedBox(height: 2.h),
                    // Tapping the seller name opens their public profile —
                    // its own GestureDetector wins the tap over the card's
                    // outer one, so this doesn't also open the product.
                    GestureDetector(
                      onTap: () =>
                          Get.to(() => SellerProfileScreen(userId: p.userId)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10.r,
                            backgroundColor: _red.withOpacity(0.15),
                            child: Text(
                              p.user.name.isNotEmpty
                                  ? p.user.name[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: _red,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              p.user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12.sp, color: _red),
                        SizedBox(width: 3.w),
                        Flexible(
                          child: Text(
                            p.placeName.isNotEmpty ? p.placeName : '—',
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
                    Spacer(),
                    Container(
                      height: 34.h,
                      decoration: BoxDecoration(
                        color: _redLight,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Color(0xFFEDD8D8), width: 1.w),
                      ),
                      child: Row(
                        children: [
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
                                    size: 13.sp,
                                    color: _red,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Chat'.tr,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: _red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1.w,
                            height: 20.h,
                            color: Color(0xFFEDD8D8),
                          ),
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
                                    size: 13.sp,
                                    color: _red,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'View'.tr,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: _red,
                                      fontWeight: FontWeight.w600,
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
            ),
          ],
        ),
      ),
    );
  }

  // ── LIST VIEW CARD ─────────────────────────────────────────────────────────
  Widget _listCard(MarketplaceListing p) {
    final img = p.images.isNotEmpty ? p.images.first.url : '';
    final condColor = _condColor(p.condition);
    final condLabel = _condLabel(p.condition);
    final int? origPrice = p.originPrice;
    final int? discPct = p.discountPercent;

    return GestureDetector(
      onTap: () => Get.to(
        () => ProductDetailsScreen(listingId: p.id, distanceKm: p.distanceKm),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image — FIX 2: no fullscreen dialog on card
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(14.r),
              ),
              child: SizedBox(
                width: 110.w,
                height: 110.h,
                child: img.isNotEmpty
                    ? Image.network(
                        img,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          '${p.currencySymbol}${p.price}',
                          style: TextStyle(
                            color: _red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        if (origPrice != null)
                          Text(
                            '${p.currencySymbol}${origPrice!}',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11.sp,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey.shade400,
                            ),
                          ),
                        SizedBox(width: 4.w),
                        if (discPct != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '$discPct% OFF',
                              style: TextStyle(
                                color: Color(0xFF16A34A),
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: condColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: condColor.withOpacity(0.4),
                          width: 0.8.w,
                        ),
                      ),
                      child: Text(
                        condLabel,
                        style: TextStyle(
                          color: condColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 11.sp, color: _red),
                        SizedBox(width: 2.w),
                        Flexible(
                          child: Text(
                            p.placeName.isNotEmpty ? p.placeName : '—',
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
                    SizedBox(height: 4.h),
                    // Seller name — tap opens their public profile (same
                    // pattern as the grid card above).
                    GestureDetector(
                      onTap: () =>
                          Get.to(() => SellerProfileScreen(userId: p.userId)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 9.r,
                            backgroundColor: _red.withOpacity(0.15),
                            child: Text(
                              p.user.name.isNotEmpty
                                  ? p.user.name[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
                                color: _red,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              p.user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.r),
                        border: Border.all(color: _red.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.initiatePurchaseChat(
                                listingId: p.id,
                                sellerId: p.userId,
                                sellerName: p.user.name,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _red.withOpacity(0.08),
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(6.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 11.sp,
                                      color: _red,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Chat'.tr,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: _red,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1.w,
                            height: 18.h,
                            color: _red.withOpacity(0.3),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ProductDetailsScreen(
                                  listingId: p.id,
                                  distanceKm: p.distanceKm,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _red.withOpacity(0.08),
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(6.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 11.sp,
                                      color: _red,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'View'.tr,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: _red,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _placeholder() => Container(
  color: Color(0xFFF0F0F0),
  child: Center(
    child: Icon(Icons.image_outlined, size: 30.sp, color: Colors.grey.shade400),
  ),
);
