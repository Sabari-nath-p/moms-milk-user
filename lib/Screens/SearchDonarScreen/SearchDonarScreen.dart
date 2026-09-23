import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Controller/SearchDonarController.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Views/SearchDonarCard.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Views/SendRequestBottomSheet.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class Searchdonarscreen extends StatefulWidget {
  // Optional initial donor-name filter handed off by another screen (e.g.
  // Home dashboard's "Find Donors" search) so the real API call fires with
  // this name already applied as soon as the screen opens.
  final String? initialDonorName;

  Searchdonarscreen({super.key, this.initialDonorName});

  @override
  State<Searchdonarscreen> createState() => _SearchdonarscreenState();
}

class _SearchdonarscreenState extends State<Searchdonarscreen> {
  final SearchDonarController controller = Get.put(SearchDonarController());
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);

    // controller.onInit() already fired an unfiltered loadDonors() the
    // moment Get.put() ran above (field initializer runs before this
    // body) — re-run the search with the incoming name so results reflect
    // it instead of showing the unfiltered list.
    if (widget.initialDonorName != null &&
        widget.initialDonorName!.trim().isNotEmpty) {
      controller.donarSearchText.text = widget.initialDonorName!.trim();
      controller.searchDonors();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      controller.loadMoreDonors();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Find Donors'.tr,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        // This screen doubles as the Connect tab's own body (no back stack
        // to pop to there) and as a screen pushed from elsewhere (Home
        // dashboard's "Find Donors" search) — only show the back arrow when
        // there's actually somewhere to go back to.
        leading: Navigator.of(context).canPop()
            ? IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back),
              )
            : null,
        actions: [
          GestureDetector(
            onTap: () => Get.to(
              () => RequestScreen(),
              transition: Transition.rightToLeft,
            ),
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 16.sp,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'My Requests'.tr,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.sp),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSearchSection(context),
                SizedBox(height: 20.h),
                _buildActiveFilters(context),
                SizedBox(height: 20.h),
                _buildDonorsList(context),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'We’re actively welcoming milk donors. If no donors appear in your area yet, don’t worry more will be joining shortly. Thank you for your patience and support and if new donars comes near you we will notify'
                              .tr,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: controller.zipSearchText,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                  controller.searchDonors();
                },
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                  hintText: "Zip Code".tr,
                  prefixIcon: Icon(Icons.location_on),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Color(0xFFFFE4E6),
                      width: 1.4,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Color(0xFFFFE4E6),
                      width: 1.6,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 3,
              child: TextField(
                controller: controller.donarSearchText,
                textInputAction: TextInputAction.search,
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Search donors...'.tr,
                  hintStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
                  prefixIcon: Icon(Icons.search),

                  // 👇 Updated Borders
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Color(0xFFFFE4E6),
                      width: 1.4,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Color(0xFFFFE4E6),
                      width: 1.6,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),

                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _showFiltersBottomSheet(context),
              icon: Icon(Icons.tune),
              tooltip: 'Filters'.tr,
            ),
          ],
        ),
        SizedBox(height: 25.h),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.roundButtonGradient,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ElevatedButton(
              onPressed: () {
                controller.searchDonors();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent, // remove default background
                shadowColor: Colors.transparent, // remove shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 20.sp, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(
                    "Search Donors".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildActiveFilters(BuildContext context) {
    return GetBuilder<SearchDonarController>(
      builder: (controller) {
        if (controller.activeFilters.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Active Filters'.tr,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    controller.clearAllFilters();
                  },
                  child: Text('Clear All'.tr),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: controller.activeFilters
                  .map(
                    (filter) => _buildFilterChip(
                      context,
                      filter,
                      () => controller.removeFilter(filter),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDonorsList(BuildContext context) {
    return GetBuilder<SearchDonarController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final donors = controller.filteredDonors;

        if (donors.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Text(
            //       'Available Donors (${donors.length})'.tr,
            //
            //       style: Theme.of(
            //         context,
            //       ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            //     ),
            //     Spacer(),
            //     DropdownButton<String>(
            //       value: controller.sortBy,
            //       items:
            //           controller.sortOptions
            //               .map(
            //                 (String value) => DropdownMenuItem<String>(
            //                   value: value,
            //                   child: Text(value.capitalize!),
            //                 ),
            //               )
            //               .toList(),
            //       onChanged: (value) {
            //         if (value != null) {
            //           controller.updateSortBy(value);
            //         }
            //       },
            //       underline: SizedBox(),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: donors.length + (controller.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == donors.length) {
                  // Loading indicator for pagination
                  return GetBuilder<SearchDonarController>(
                    builder: (controller) => controller.isLoadingMore
                        ? Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : SizedBox.shrink(),
                  );
                }

                final donor = donors[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: SearchDonarCard(donar: donor),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.sp),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 64.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Donors Found'.tr,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search criteria or filters.'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: Row(
                children: [
                  Text(
                    'Filters'.tr,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      controller.clearAllFilters();
                    },
                    child: Text('Clear All'.tr),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //   Text(
                    //     'Blood Group',
                    //     style: Theme.of(context).textTheme.titleMedium
                    //         ?.copyWith(fontWeight: FontWeight.w600),
                    //   ),
                    //   SizedBox(height: 8),
                    //   GetBuilder<SearchDonarController>(
                    //   builder: (controller) => DropdownButtonFormField<String>(
                    //     value: controller.bloodGroupFilter.isEmpty
                    //         ? null
                    //         : controller.bloodGroupFilter,

                    //     decoration: InputDecoration(

                    //       border: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.black87),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.grey.shade400),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Color(0xFFFB923C), width: 2),
                    //       ),

                    //       hintText: "Select blood group",
                    //       hintStyle: TextStyle(color: Colors.black54),

                    //       filled: true,
                    //       fillColor: Colors.white,
                    //     ),

                    //     dropdownColor: Colors.white,
                    //     iconEnabledColor: Colors.black,

                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 14,
                    //     ),

                    //     items: ['Any', ...controller.bloodGroups].map((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value == 'Any' ? '' : value,
                    //         child: Text(
                    //           value,
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 14,
                    //           ),
                    //         ),
                    //       );
                    //     }).toList(),

                    //     onChanged: (value) {
                    //       controller.updateBloodGroupFilter(value ?? '');
                    //     },
                    //   ),
                    // ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Donor willing to share medical record'.tr,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        GetBuilder<SearchDonarController>(
                          builder: (controller) => Switch(
                            value: controller.medicalRecordsRequired,
                            onChanged: (value) {
                              controller.updateMedicalRecordsFilter(value);
                            },
                            activeColor: Colors.white, // thumb color when ON
                            activeTrackColor: Color(0xFFFB923C),
                            inactiveThumbColor:
                                Colors.grey.shade400, // thumb color when OFF
                            inactiveTrackColor:
                                Colors.grey.shade300, // track color when OFF
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Currently Available Donors'.tr,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        GetBuilder<SearchDonarController>(
                          builder: (controller) => Switch(
                            value: controller.onlyAvailableDonors,
                            onChanged: (value) {
                              controller.updateAvailabilityFilter(value);
                            },
                            activeColor: Colors.white, // thumb color when ON
                            activeTrackColor: Color(
                              0xFFFB923C,
                            ), // track color when ON
                            inactiveThumbColor:
                                Colors.grey.shade400, // thumb color when OFF
                            inactiveTrackColor:
                                Colors.grey.shade300, // track color when OFF
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  controller.applyFilters();
                },
                child: Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: AppTheme.roundButtonGradient,
                  ),
                  child: Center(
                    child: Text(
                      'Apply Filters'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    VoidCallback onRemove,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14.sp,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
