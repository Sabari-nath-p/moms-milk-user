import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/MarketListingModel.dart';
import 'package:mommilk_user/Screens/MarketScreen/Additem_screen.dart';
import 'package:mommilk_user/Screens/MarketScreen/MyListingScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/ProductDetailScreen.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/market_controller.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Controller/ChatController.dart';

class MarketScreen extends StatefulWidget {
  MarketScreen({super.key});
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
    print("======= MARKET SCREEN INITSTATE =======");

    try {
      if (Get.isRegistered<MarketController>()) {
        print("======= OLD CONTROLLER EXISTS - DELETING =======");
        Get.delete<MarketController>(force: true);
      }
      controller = Get.put(MarketController());
      print("======= NEW CONTROLLER CREATED: ${controller.hashCode} =======");
    } catch (e) {
      print("======= CONTROLLER INIT ERROR: $e =======");
      controller = Get.put(MarketController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("======= POST FRAME CALLBACK - CALLING FETCH =======");
      controller.fetchMarketplaceListings();
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
        onPressed: () => Get.to(() => AddItemScreen())?.then((_) {
          controller.fetchMarketplaceListings(
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
          );
        }),
        backgroundColor: _red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.add, color: Colors.white, size: 26),
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
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  )
                else if (_isGridView)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _card(controller.listings[i]),
                        childCount: controller.listings.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 290,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _listCard(controller.listings[i]),
                        ),
                        childCount: controller.listings.length,
                      ),
                    ),
                  ),

                // ── Load more spinner / end indicator ──────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: controller.isLoadingMore
                        ? Center(
                            child: CircularProgressIndicator(
                              color: _red,
                              strokeWidth: 2,
                            ),
                          )
                        : controller.hasNextPage
                        ? const SizedBox.shrink()
                        : controller.listings.isNotEmpty
                        ? Center(
                            child: Text(
                              'You\'ve seen all items'.tr,
                              style: TextStyle(
                                fontSize: 12,
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
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
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
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Buy and sell pre-loved baby products'.tr,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(() => MyListingsScreen()),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFEDD8D8), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.inventory_2_outlined, color: _red, size: 20),
          ),
        ),
      ],
    ),
  );

  Widget _searchBar() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search for baby products'.tr,
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: _showFilter,
          child: Stack(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _activeFilterCount > 0 ? _red : Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
                  size: 20,
                  color: _activeFilterCount > 0 ? Colors.white : _red,
                ),
              ),
              if (_activeFilterCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$_activeFilterCount',
                        style: TextStyle(
                          color: _red,
                          fontSize: 9,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Filters'.tr,
                      style: TextStyle(
                        fontSize: 18,
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
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Divider(color: Colors.grey.shade200),
                SizedBox(height: 16),
                Text(
                  'Condition'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _tempCondition == c ? _red : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _tempCondition == c
                                  ? _red
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            _condLabel(c),
                            style: TextStyle(
                              fontSize: 13,
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
                SizedBox(height: 24),
                Divider(color: Colors.grey.shade200),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Price Range'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _redLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹${_tempPrice.start.toInt()}  –  ${_tempPrice.end.toInt() >= 50000 ? 'Any'.tr : '₹${_tempPrice.end.toInt()}'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: _red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
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
                      ['${'Under'.tr} ₹500', RangeValues(0, 500)],
                      ['₹500–₹2000', RangeValues(500, 2000)],
                      ['₹2000–₹5000', RangeValues(2000, 5000)],
                      ['₹5000+', RangeValues(5000, 50000)],
                    ])
                      GestureDetector(
                        onTap: () => setSheet(
                          () => _tempPrice = preset[1] as RangeValues,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _tempPrice == preset[1]
                                ? _red
                                : Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            preset[0] as String,
                            style: TextStyle(
                              fontSize: 11,
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
                SizedBox(height: 24),
                Divider(color: Colors.grey.shade200),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Distance'.tr,
                      style: TextStyle(
                        fontSize: 14,
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
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: _red, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${'Within'.tr} ${_tempDist.toInt()} km',
                        style: TextStyle(
                          fontSize: 13,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _tempDist == km ? _red : Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              '${km.toInt()} km',
                              style: TextStyle(
                                fontSize: 11,
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
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Enable to filter by distance from you'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
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
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Apply Filters'.tr,
                      style: TextStyle(
                        fontSize: 15,
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
    padding: const EdgeInsets.only(bottom: 10),
    child: SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ..._visibleCats.map((cat) {
            final sel = selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() => selectedCategory = cat);
                  controller.selectedCategory = _catApiValue(cat);
                  _filter();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: sel ? _red : _redLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: sel ? _red : Color(0xFFEDD8D8),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cat.tr,
                    style: TextStyle(
                      color: sel ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: _showAllCats,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _redLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFFEDD8D8), width: 1),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'More'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? _red : Color(0xFFF5F5F5),
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
          SizedBox(height: 12),
        ],
      ),
    ),
  );

  Widget _resultHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
    child: Row(
      children: [
        Text(
          '${controller.listings.length} items',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Spacer(),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _red.withOpacity(0.10),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(Icons.grid_view_rounded, size: 17, color: _red),
        ),
        SizedBox(width: 12),

        // ── Sort dropdown ───────────────────────────────────────────────────
        GestureDetector(
          onTap: _showSortSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _sortBy.isNotEmpty ? _red : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _sortBy.isNotEmpty ? _red : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  size: 14,
                  color: _sortBy.isNotEmpty
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
                SizedBox(width: 4),
                Text(
                  _sortLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: _sortBy.isNotEmpty
                        ? Colors.white
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'Sort By'.tr,
                  style: TextStyle(
                    fontSize: 17,
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
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            ..._sortOptions.map((opt) {
              final isSelected = _sortBy == opt.$2;
              return GestureDetector(
                onTap: () {
                  setState(() => _sortBy = opt.$2);
                  controller.applySort(opt.$2); // client-side sort, no re-fetch
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? _redLight : Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? _red : Colors.black87,
                        ),
                      ),
                      Spacer(),
                      if (isSelected)
                        Icon(Icons.check_circle, color: _red, size: 18),
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
                // FIX 2: No fullscreen dialog on card — just navigate to detail
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 125,
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
                  top: 9,
                  left: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                // FIX 1: Condition badge — bottom left inside photo
                Positioned(
                  bottom: 8,
                  left: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${p.price}',
                          style: TextStyle(
                            color: _red,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 5),
                        if (origPrice != null)
                          Text(
                            '\$$origPrice',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey.shade400,
                            ),
                          ),
                        SizedBox(width: 4),
                        if (discPct != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$discPct% OFF',
                              style: TextStyle(
                                color: Color(0xFF16A34A),
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 5),
                    if (usedDur != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${'Used'.tr} $usedDur',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: _red.withOpacity(0.15),
                          child: Text(
                            p.user.name.isNotEmpty
                                ? p.user.name[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: _red,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            p.user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: _red),
                        SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            p.placeName.isNotEmpty ? p.placeName : '—',
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
                    Spacer(),
                    Container(
                      height: 34,
                      decoration: BoxDecoration(
                        color: _redLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFEDD8D8), width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                final c = Get.isRegistered<Chatcontroller>()
                                    ? Get.find<Chatcontroller>()
                                    : Get.put(Chatcontroller());
                                c.OpenChatUser(
                                  userID: p.userId,
                                  isDonar: false,
                                  userName: p.user.name,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 13,
                                    color: _red,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Chat'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 20,
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
                                    size: 13,
                                    color: _red,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'View'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
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
          borderRadius: BorderRadius.circular(14),
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
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14),
              ),
              child: SizedBox(
                width: 110,
                height: 110,
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
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '\$${p.price}',
                          style: TextStyle(
                            color: _red,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 5),
                        if (origPrice != null)
                          Text(
                            '\$$origPrice',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey.shade400,
                            ),
                          ),
                        SizedBox(width: 4),
                        if (discPct != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$discPct% OFF',
                              style: TextStyle(
                                color: Color(0xFF16A34A),
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: condColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: condColor.withOpacity(0.4),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        condLabel,
                        style: TextStyle(
                          color: condColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 11, color: _red),
                        SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            p.placeName.isNotEmpty ? p.placeName : '—',
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
                    SizedBox(height: 6),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: _red.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                final c = Get.isRegistered<Chatcontroller>()
                                    ? Get.find<Chatcontroller>()
                                    : Get.put(Chatcontroller());
                                c.OpenChatUser(
                                  userID: p.userId,
                                  isDonar: false,
                                  userName: p.user.name,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _red.withOpacity(0.08),
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(6),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 11,
                                      color: _red,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Chat'.tr,
                                      style: TextStyle(
                                        fontSize: 11,
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
                            width: 1,
                            height: 18,
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
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(6),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 11,
                                      color: _red,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'View'.tr,
                                      style: TextStyle(
                                        fontSize: 11,
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
    child: Icon(Icons.image_outlined, size: 30, color: Colors.grey.shade400),
  ),
);
