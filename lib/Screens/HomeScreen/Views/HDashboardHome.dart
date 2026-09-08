import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/Dashboard/Controller/DashboardController.dart';
import 'package:mommilk_user/Screens/MarketScreen/ListingTypeSheet.dart';
import 'package:mommilk_user/Screens/MarketScreen/MyListingScreen.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/SearchDonarScreen.dart';
import 'package:mommilk_user/theme/app_theme.dart';

/// Exact UI replica of the Buyer / Donor home dashboard design.
/// UI only — no data wiring / integrations. Values below are static
/// placeholders matching the approved design.
class HDashboardHome extends StatelessWidget {
  const HDashboardHome({super.key});

  bool get _isDonor => user.userType == 'DONOR';

  // Switches the bottom-nav tab on MainDashboard (same pattern used by
  // ChatScreen's "Go to Connect" button).
  void _goToTab(int index) {
    final controller = Get.put(DashboardController());
    controller.selectedMenu = index;
    controller.update();
  }

  // Switches to the Market tab, handing MarketScreen a search/category
  // filter to apply (via a real API call) as soon as it opens — same
  // behaviour as searching/filtering directly on the Marketplace tab.
  void _goToMarket(
    BuildContext context, {
    String? search,
    String? category,
    bool openFilter = false,
  }) {
    Get.put(
      DashboardController(),
    ).goToMarket(search: search, category: category, openFilter: openFilter);
  }

  // English category label → marketplace API value, matching Market_screen's
  // own mapping (e.g. "Cradles" -> "CRADLES", "Car Seats" -> "CAR_SEATS").
  String _marketCatApiValue(String label) =>
      label.toUpperCase().replaceAll(' ', '_');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 16),
              _buildGreetingCard(context),
              const SizedBox(height: 16),
              _isDonor
                  ? _buildDonorSummaryCard(context)
                  : _buildBuyerRequestsCard(context),
              const SizedBox(height: 16),
              _isDonor
                  ? _buildAddProductBanner(context)
                  : _buildRequestMilkBanner(context),
              const SizedBox(height: 16),
              _buildQuickActionsGrid(context),

              if (_isDonor) _buildMarketplaceSearchCard(context),
              if (_isDonor) const SizedBox(height: 16),
              _buildRecentRequestsCard(context),
              const SizedBox(height: 16),
              _isDonor
                  ? _buildRecentAcceptancesCard(context)
                  : _buildMarketplaceBrowseCard(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // TOP BAR — logo + notification bell
  // ---------------------------------------------------------------------
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.favorite, color: AppTheme.primaryColor, size: 26),
        const SizedBox(width: 8),
        Text(
          "Mom's Milk".tr,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.notifications_none,
              color: AppTheme.textPrimaryColor,
              size: 26,
            ),
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // GREETING CARD
  // ---------------------------------------------------------------------
  Widget _buildGreetingCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: AppTheme.CardGradient,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile icon
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              gradient: AppTheme.buttonCardGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: Colors.white, size: 19.sp),
          ),

          SizedBox(width: 14.w),

          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isDonor
                      ? "Good Evening, ${user.name ?? 'donor'}!".tr
                      : "Good Evening, ${user.name ?? 'buyer'}!".tr,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2.h),
                Text(
                  _isDonor
                      ? "Here's your quick summary".tr
                      : "Find and request the best for your little one".tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // TOP RIGHT BUTTON
          // Donor: static "Donor" badge, unchanged.
          // Buyer: "Find Donors" pill that turns into an inline name field
          // on tap — typing a name and hitting enter goes straight to
          // Searchdonarscreen with that name applied as a real search.
          _isDonor
              ? Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.cardGradientStart,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 1.sp,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: AppTheme.primaryColor,
                          size: 14.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Donor'.tr,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const _FindDonorsButton(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // GENERIC WHITE SECTION CARD
  // ---------------------------------------------------------------------
  Widget _sectionCard({
    required BuildContext context,
    required IconData leadingIcon,
    required String title,
    required String actionLabel,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.cardGradientStart, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppTheme.cardGradientStart,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  leadingIcon,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    //  fontSize: 13.sp,
                  ),
                ),
              ),
              _pillLink(actionLabel),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _pillLink(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7),
        decoration: BoxDecoration(
          color: AppTheme.cardGradientStart,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
            const SizedBox(width: 1),
            Icon(Icons.chevron_right, color: AppTheme.primaryColor, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyerRequestsCard(BuildContext context) {
    final stats = [
      _statItem(
        context,
        value: '2',
        label: 'Active\nRequests'.tr,
        color: const Color(0xFF16A34A),
        icon: Icons.description,
      ),
      _statItem(
        context,
        value: '1',
        label: 'Pending\nAcceptance'.tr,
        color: const Color(0xFFF97316),
        icon: Icons.access_time,
      ),
      _statItem(
        context,
        value: '3',
        label: 'Accepted\nDonors'.tr,
        color: const Color(0xFF2563EB),
        icon: Icons.check_circle,
      ),
      _statItem(
        context,
        value: '1',
        label: 'Completed\nDeliveries'.tr,
        color: const Color(0xFFE11D48),
        icon: Icons.favorite,
      ),
    ];

    return _sectionCard(
      context: context,
      leadingIcon: Icons.description_outlined,
      title: 'Your Requests'.tr,
      actionLabel: 'View All'.tr,
      child: Row(
        children: List.generate(stats.length * 2 - 1, (index) {
          // Divider
          if (index.isOdd) {
            return Container(
              height: 90.h,
              width: 1,
              color: AppTheme.cardGradientStart,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
            );
          }

          // Statistic
          return Expanded(child: stats[index ~/ 2]);
        }),
      ),
    );
  }

  Widget _buildDonorSummaryCard(BuildContext context) {
    final stats = [
      _statItem(
        context,
        value: '3',
        label: 'Active\nListings'.tr,
        color: const Color(0xFF16A34A),
        icon: FontAwesomeIcons.babyCarriage,
        isFa: true,
      ),
      _statItem(
        context,
        value: '2',
        label: 'Pending\nRequests'.tr,
        color: const Color(0xFFF97316),
        icon: Icons.access_time,
      ),
      _statItem(
        context,
        value: '5',
        label: 'Accepted\nRequests'.tr,
        color: Colors.blue,
        icon: Icons.check_circle,
      ),
      _statItem(
        context,
        value: '1',
        label: 'Total\nDonations'.tr,
        color: const Color(0xFFE11D48),
        icon: Icons.favorite,
      ),
    ];

    return _sectionCard(
      context: context,
      leadingIcon: Icons.person_outline,
      title: 'Donor Summary'.tr,
      actionLabel: 'View Details'.tr,
      child: Row(
        children: List.generate(stats.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Container(
              height: 90.h,
              width: 1,
              color: AppTheme.cardGradientStart,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
            );
          }

          return Expanded(child: stats[index ~/ 2]);
        }),
      ),
    );
  }

  Widget _statItem(
    BuildContext context, {
    required String value,
    required String label,
    required Color color,
    required IconData icon,
    bool isFa = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              height: 1.h,
            ),
          ),
          const SizedBox(height: 8),
          isFa
              ? FaIcon(icon, color: color, size: 18)
              : Icon(icon, color: color, size: 20),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // BANNERS — "Request Milk" (buyer) / "Add Baby Product" (donor)
  // ---------------------------------------------------------------------
  Widget _buildRequestMilkBanner(BuildContext context) {
    return _buildBanner(
      context: context,
      icon: Icons.note_add_outlined,
      title: 'Request Milk'.tr,
      subtitle: 'Post a new request for your little one'.tr,
      buttonLabel: 'New Request'.tr,
      // Same destination as the "Browse Donors" quick action — requests are
      // sent to a specific donor from Searchdonarscreen (its donor cards
      // open the existing SendRequestBottomSheet flow).
      onPressed: () => Get.to(() => Searchdonarscreen()),
    );
  }

  Widget _buildAddProductBanner(BuildContext context) {
    return _buildBanner(
      context: context,
      icon: Icons.add,
      title: 'Add Baby Product'.tr,
      subtitle: 'List your pre-loved items'.tr,
      buttonLabel: 'Add Now'.tr,
      // Same "Baby Item / Breast Milk" chooser → AddItemScreen flow as the
      // Marketplace tab's FAB.
      onPressed: () => showListingTypeSheet(context),
    );
  }

  Widget _buildBanner({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    VoidCallback? onPressed,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppTheme.cardGradientStart.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.cardGradientStart, width: 1.5.w),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: AppTheme.buttonCardGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.roundButtonGradient,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: TextButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              label: Text(
                buttonLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // QUICK ACTIONS GRID (4 tiles)
  // ---------------------------------------------------------------------
  Widget _buildQuickActionsGrid(BuildContext context) {
    final List<_QuickAction> actions = _isDonor
        ? [
            _QuickAction(
              'Marketplace'.tr,
              '',
              Icons.shopping_bag,
              AppTheme.cardGradientStart,
              const Color(0xFFE11D48),
              onTap: () => _goToTab(1), // Market tab
            ),
            _QuickAction(
              'My Listings'.tr,
              '',
              FontAwesomeIcons.prescriptionBottle,
              const Color(0xFFDCEBFC),
              const Color(0xFF2563EB),
              isFa: true,
              onTap: () => Get.to(() => MyListingsScreen()),
            ),
            _QuickAction(
              'My Requests'.tr,
              '',
              Icons.list_alt,
              const Color(0xFFDCF7E3),
              const Color(0xFF16A34A),
              onTap: () => _goToTab(2), // Connect tab
            ),
          ]
        : [
            _QuickAction(
              'Browse Donors'.tr,
              'Find trusted mums'.tr,
              FontAwesomeIcons.prescriptionBottle,
              AppTheme.cardGradientStart,
              const Color(0xFFE11D48),
              isFa: true,
              onTap: () => Get.to(() => Searchdonarscreen()),
            ),
            _QuickAction(
              'My Requests'.tr,
              'Track your requests'.tr,
              Icons.favorite_border,
              const Color(0xFFDCEBFC),
              const Color(0xFF2563EB),
              onTap: () => _goToTab(2), // Connect tab
            ),
            _QuickAction(
              'My Listings'.tr,
              'View your listings'.tr,
              Icons.verified_outlined,
              const Color(0xFFDCF7E3),
              const Color(0xFF16A34A),
              onTap: () => Get.to(() => MyListingsScreen()),
            ),
            _QuickAction(
              'Marketplace'.tr,
              'Buy baby products'.tr,
              Icons.shopping_cart_outlined,
              const Color(0xFFE9E1FB),
              const Color(0xFF7C3AED),
              onTap: () => _goToTab(1), // Market tab
            ),
          ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _quickActionTile(context, action),
          ),
        );
      }).toList(),
    );
  }

  Widget _quickActionTile(BuildContext context, _QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          // Icon container
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              color: action.bg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: action.isFa
                  ? FaIcon(action.icon, color: action.iconColor, size: 26.sp)
                  : Icon(action.icon, color: action.iconColor, size: 28.sp),
            ),
          ),

          SizedBox(height: 8.h),

          // Fixed text area
          SizedBox(
            height: 40.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),

                SizedBox(height: 2.h),

                // Always reserve subtitle space
                SizedBox(
                  height: 14.h,
                  child: action.subtitle.isNotEmpty
                      ? Text(
                          action.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppTheme.textSecondaryColor,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // DONOR — Marketplace search + category chips
  // ---------------------------------------------------------------------
  Widget _buildMarketplaceSearchCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppTheme.cardGradientStart.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.cardGradientStart, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.cardGradientStart,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  color: Color(0xFFE11D48),
                  size: 20.sp,
                ),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Marketplace'.tr,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Buy and sell pre-loved baby products'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 10.5.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 6.w),
              _pillLink('View All'.tr, onTap: () => _goToMarket(context)),
            ],
          ),
          SizedBox(height: 10.h),

          _MarketplaceSearchBox(
            onSubmit: (text) => _goToMarket(context, search: text),

            // Tune icon: same "go to Market tab" navigation, but also opens
            // the Filters bottom sheet immediately — same sheet as the tune
            // icon on the Marketplace tab itself.
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _categoryChip(
                  'All'.tr,
                  selected: true,
                  onTap: () => _goToMarket(context),
                ),
                for (final cat in const [
                  'Cradles',
                  'Toys',
                  'Clothing',
                  'Strollers',
                ])
                  _categoryChip(
                    cat.tr,
                    onTap: () =>
                        _goToMarket(context, category: _marketCatApiValue(cat)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(
    String label, {
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? Color(0xFFE11D48).withOpacity(0.8)
              : AppTheme.cardGradientStart,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // RECENT REQUESTS
  // ---------------------------------------------------------------------
  Widget _buildRecentRequestsCard(BuildContext context) {
    final List<_RequestRow> rows = _isDonor
        ? [
            _RequestRow(
              name: 'dmir',
              subtitle: 'Requested 2 bottles of milk'.tr,
              meta: '2 days ago'.tr,
              status: 'Pending'.tr,
              avatarColor: const Color(0xFFE11D48),
            ),
          ]
        : [
            _RequestRow(
              name: 'kavya',
              subtitle: '1 bottle of milk • 3 days ago'.tr,
              status: 'Pending'.tr,
              avatarColor: const Color(0xFF7C3AED),
            ),
            _RequestRow(
              name: 'reema',
              subtitle: '2 bottles of milk • 1 week ago'.tr,
              status: 'Accepted'.tr,
              avatarColor: const Color(0xFFE11D48),
            ),
          ];

    return _sectionCard(
      context: context,
      leadingIcon: Icons.people_outline,
      title: 'Recent Requests'.tr,
      actionLabel: 'View All'.tr,
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            _requestRowTile(context, rows[i]),
            if (i != rows.length - 1) SizedBox(height: 5.h),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentAcceptancesCard(BuildContext context) {
    return _sectionCard(
      context: context,
      leadingIcon: Icons.check_circle_outline,
      title: 'Recent Acceptances'.tr,
      actionLabel: 'View All'.tr,
      child: _requestRowTile(
        context,
        _RequestRow(
          name: 'kavya',
          subtitle: 'Accepted your milk request'.tr,
          meta: '3 days ago'.tr,
          status: 'Accepted'.tr,
          avatarColor: const Color(0xFF7C3AED),
        ),
      ),
    );
  }

  Widget _requestRowTile(BuildContext context, _RequestRow row) {
    final bool accepted =
        row.status.toLowerCase() == 'accepted'.tr.toLowerCase() ||
        row.status.toLowerCase() == 'accepted';
    final Color statusColor = accepted
        ? const Color(0xFF16A34A)
        : const Color(0xFFF97316);
    final Color statusBg = accepted
        ? const Color(0xFFDCF7E3)
        : const Color(0xFFFFEEDC);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: AppTheme.cardGradientStart, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: row.avatarColor,
            child: Text(
              row.name.isNotEmpty ? row.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  row.subtitle,
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      accepted ? Icons.check_circle : Icons.access_time,
                      size: 12,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      row.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (row.meta != null) ...[
                const SizedBox(height: 4),
                Text(
                  row.meta!,
                  style: TextStyle(
                    color: AppTheme.textDisabledColor,
                    fontSize: 11,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 4),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.textDisabledColor,
                  size: 18,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // BUYER — Marketplace browse (categories)
  // ---------------------------------------------------------------------
  Widget _buildMarketplaceBrowseCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFF3C7D2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------------
          // HEADER
          // ------------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Marketplace icon
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppTheme.cardGradientStart,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  color: const Color(0xFFFF4F6D),
                  size: 18.sp,
                ),
              ),

              SizedBox(width: 10.w),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Marketplace'.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      'Buy and sell pre-loved baby products'.tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),
              _pillLink("View All".tr, onTap: () => _goToMarket(context)),
            ],
          ),

          SizedBox(height: 10.h),

          // ------------------------------------------------------------
          // CATEGORY TILES
          // ------------------------------------------------------------
          Row(
            children: [
              _marketCategoryTile(
                context,
                'Cradles',
                Icons.crib_outlined,
                const Color(0xFFFFE8EF),
              ),

              _marketCategoryTile(
                context,
                'Toys',
                Icons.toys_outlined,
                const Color(0xFFE2F0FF),
              ),

              _marketCategoryTile(
                context,
                'Clothing',
                Icons.checkroom_outlined,
                const Color(0xFFE2F7E7),
              ),

              _marketCategoryTile(
                context,
                'Strollers',
                Icons.stroller_outlined,
                const Color(0xFFF0E7FB),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // [label] is the raw English category name — translated for display,
  // mapped to its API value (via _marketCatApiValue) for the actual filter.
  Widget _marketCategoryTile(
    BuildContext context,
    String label,
    IconData icon,
    Color bg,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _goToMarket(context, category: _marketCatApiValue(label)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: AppTheme.textPrimaryColor,
                    size: 25.sp,
                  ),
                ),
              ),

              SizedBox(height: 5.h),

              Text(
                label.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Donor marketplace search box — its own StatefulWidget (rather than a
// field on HDashboardHome) so the TextEditingController is created and
// disposed correctly across rebuilds.
// Buyer greeting card's "Find Donors" pill — the pill itself is the input
// (no separate tap-to-expand step): type a name and hit enter to go
// straight to Searchdonarscreen with that name applied as a real search.
class _FindDonorsButton extends StatefulWidget {
  const _FindDonorsButton();

  @override
  State<_FindDonorsButton> createState() => _FindDonorsButtonState();
}

class _FindDonorsButtonState extends State<_FindDonorsButton> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    Get.to(() => Searchdonarscreen(initialDonorName: trimmed));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppTheme.cardGradientStart,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppTheme.primaryColor, width: 1.sp),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, color: AppTheme.primaryColor, size: 14.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: _submit,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
              decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Find Donors'.tr,
                hintStyle: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketplaceSearchBox extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  // final VoidCallback onFilterTap;

  const _MarketplaceSearchBox({
    required this.onSubmit,
    // required this.onFilterTap,
  });

  @override
  State<_MarketplaceSearchBox> createState() => _MarketplaceSearchBoxState();
}

class _MarketplaceSearchBoxState extends State<_MarketplaceSearchBox> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppTheme.textSecondaryColor,
                  size: 18.sp,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: widget.onSubmit,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimaryColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Search for baby products...'.tr,
                      hintStyle: TextStyle(
                        color: AppTheme.textDisabledColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 5.w),
        // GestureDetector(
        //   onTap: widget.onFilterTap,
        //   child: Container(
        //     padding: const EdgeInsets.all(12),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       border: Border.all(color: Colors.grey.shade200, width: 1),
        //       borderRadius: BorderRadius.circular(12.r),
        //     ),
        //     child: Icon(Icons.tune, size: 18, color: AppTheme.textPrimaryColor),
        //   ),
        // ),
      ],
    );
  }
}

class _QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final VoidCallback? onTap;

  final bool isFa;
  _QuickAction(
    this.title,
    this.subtitle,
    this.icon,
    this.bg,
    this.iconColor, {
    this.isFa = false,
    this.onTap,
  });
}

class _RequestRow {
  final String name;
  final String subtitle;
  final String? meta;
  final String status;
  final Color avatarColor;
  _RequestRow({
    required this.name,
    required this.subtitle,
    this.meta,
    required this.status,
    required this.avatarColor,
  });
}
