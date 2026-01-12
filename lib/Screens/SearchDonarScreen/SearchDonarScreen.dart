import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Controller/SearchDonarController.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Views/SearchDonarCard.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/Views/SendRequestBottomSheet.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class Searchdonarscreen extends StatefulWidget {
  const Searchdonarscreen({super.key});

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

      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // SliverAppBar(
          //   expandedHeight: 80,
          //   floating: false,
          //   pinned: true,
          //   leading: IconButton(
          //     onPressed: () => Navigator.pop(context),
          //     icon: const Icon(Icons.arrow_back),
          //   ),
          //   flexibleSpace: FlexibleSpaceBar(
          //     title: Text(
          //       'Find Donors',
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Theme.of(context).colorScheme.onPrimary,
          //       ),
          //     ),
          //     centerTitle: true,
          //     background: Container(
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [
          //             Theme.of(context).colorScheme.primary,
          //             Theme.of(context).colorScheme.primary.withOpacity(0.8),
          //           ],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          //       ),
          //     ),
          //   ),

          // ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSearchSection(context),
                const SizedBox(height: 20),
                _buildActiveFilters(context),
                const SizedBox(height: 20),
                _buildDonorsList(context),
                 SizedBox(height: 10,),
                  Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'We’re actively welcoming milk donors. If no donors appear in your area yet, don’t worry more will be joining shortly. Thank you for your patience and support and if new donars comes near you we will notify',
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

    // ✅ allow text + numbers
    keyboardType: TextInputType.text,

    // ✅ show DONE button
    textInputAction: TextInputAction.done,

    // ✅ handle Done action
    onSubmitted: (_) {
      FocusScope.of(context).unfocus(); // close keyboard
      controller.searchDonors(); // optional auto search
    },

    style: const TextStyle(color: Colors.black87),
    decoration: InputDecoration(
      hintStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      hintText: "Zip Code",
      prefixIcon: const Icon(Icons.location_on),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFFFE4E6),
          width: 1.4,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFFFE4E6),
          width: 1.6,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  ),
),

            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: TextField(
                controller: controller.donarSearchText,
                textInputAction: TextInputAction.search,
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Search donors...',
                  hintStyle: TextStyle(color: Colors.black, fontSize: 12),
                  prefixIcon: const Icon(Icons.search),

                  // 👇 Updated Borders
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFFFFE4E6),
                      width: 1.4,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFFFFE4E6),
                      width: 1.6,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _showFiltersBottomSheet(context),
              icon: const Icon(Icons.tune),
              tooltip: 'Filters',
            ),
          ],
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.roundButtonGradient,
              borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Search Donors",
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
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Active Filters',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    controller.clearAllFilters();
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  controller.activeFilters
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
          return const Center(child: CircularProgressIndicator());
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
            //       'Available Donors (${donors.length})',
            //       style: Theme.of(
            //         context,
            //       ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            //     ),
            //     const Spacer(),
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
            //       underline: const SizedBox(),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: donors.length + (controller.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == donors.length) {
                  // Loading indicator for pagination
                  return GetBuilder<SearchDonarController>(
                    builder:
                        (controller) =>
                            controller.isLoadingMore
                                ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                                : const SizedBox.shrink(),
                  );
                }

                final donor = donors[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Donors Found',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria or filters.',
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
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Filters',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          controller.clearAllFilters();
                        },
                        child: const Text('Clear All'),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //   Text(
                        //     'Blood Group',
                        //     style: Theme.of(context).textTheme.titleMedium
                        //         ?.copyWith(fontWeight: FontWeight.w600),
                        //   ),
                        //   const SizedBox(height: 8),
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
                        //       hintStyle: const TextStyle(color: Colors.black54),

                        //       filled: true,
                        //       fillColor: Colors.white,
                        //     ),

                        //     dropdownColor: Colors.white,
                        //     iconEnabledColor: Colors.black,

                        //     style: const TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 14,
                        //     ),

                        //     items: ['Any', ...controller.bloodGroups].map((String value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value == 'Any' ? '' : value,
                        //         child: Text(
                        //           value,
                        //           style: const TextStyle(
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
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Donor willing to share medical record',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            GetBuilder<SearchDonarController>(
                              builder:
                                  (controller) => Switch(
                                    value: controller.medicalRecordsRequired,
                                    onChanged: (value) {
                                      controller.updateMedicalRecordsFilter(
                                        value,
                                      );
                                    },
                                    activeColor:
                                        Colors.white, // thumb color when ON
                                    activeTrackColor: const Color(0xFFFB923C),
                                    inactiveThumbColor:
                                        Colors
                                            .grey
                                            .shade400, // thumb color when OFF
                                    inactiveTrackColor:
                                        Colors
                                            .grey
                                            .shade300, // track color when OFF
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Currently Available Donors',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            GetBuilder<SearchDonarController>(
                              builder:
                                  (controller) => Switch(
                                    value: controller.onlyAvailableDonors,
                                    onChanged: (value) {
                                      controller.updateAvailabilityFilter(
                                        value,
                                      );
                                    },
                                    activeColor:
                                        Colors.white, // thumb color when ON
                                    activeTrackColor: const Color(
                                      0xFFFB923C,
                                    ), // track color when ON
                                    inactiveThumbColor:
                                        Colors
                                            .grey
                                            .shade400, // thumb color when OFF
                                    inactiveTrackColor:
                                        Colors
                                            .grey
                                            .shade300, // track color when OFF
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      controller.applyFilters();
                    },
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: AppTheme.roundButtonGradient,
                      ),
                      child: const Center(
                        child: Text(
                          'Apply Filters',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
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
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
