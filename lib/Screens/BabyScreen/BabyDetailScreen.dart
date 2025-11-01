import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/BabyModel.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';

class BabyDetailsScreen extends StatefulWidget {
  BabyModel baby;
  BabyDetailsScreen({super.key, required this.baby});

  @override
  State<BabyDetailsScreen> createState() => _BabyDetailsScreenState();
}

class _BabyDetailsScreenState extends State<BabyDetailsScreen> {
  int _currentTabIndex = 0;
  late Homecontroller controller;

  // Date range state
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    controller = Get.find<Homecontroller>();
    _setDefaultDateRange();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedBady = widget.baby;
      controller.fetchBabyAnalytics(babyId: widget.baby.id!);
      controller.fetchAllLogsForBaby(widget.baby.id!);
    });
  }

  void _setDefaultDateRange() {
    selectedEndDate = DateTime.now();
    selectedStartDate = selectedEndDate!.subtract(const Duration(days: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Baby - ${widget.baby.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showDatePicker(context),
            tooltip: 'Select Date',
          ),
        ],
      ),
      body: GetBuilder<Homecontroller>(
        builder:
            (controller) => Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildQuickStats(context, controller),
                        _buildTabBar(context),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    child: IndexedStack(
                      index: _currentTabIndex,
                      children: [
                        _buildOverviewTab(controller),
                        _buildFeedingTab(controller),
                        _buildDiaperTab(controller),
                        _buildSleepTab(controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
        selectedEndDate = picked;
      });

      // controller.fetchBabyAnalytics(
      //   babyId: widget.baby.id!,
      //   startDate: picked,
      //   endDate: picked,
      // );

      controller.fetchAllLogsForBaby(
        widget.baby.id!,
        startDate: picked,
        endDate: picked,
      );
    }
  }

  Widget _buildQuickStats(BuildContext context, Homecontroller controller) {
    final analytics = controller.babyAnalytics;
    final isLoading = controller.isAnalyticsLoading;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Summary for ${widget.baby.name}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Feedings',
                    '${analytics?.feeding?.totalFeeds ?? 0}',
                    Icons.local_drink,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Diapers',
                    '${analytics?.diaper?.totalChanges ?? 0}',
                    Icons.child_care,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Sleep',
                    '${analytics?.sleep?.totalSleepSessions ?? 0}',
                    Icons.bedtime,
                    Colors.green,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final tabs = ['Overview', 'Feeding', 'Diaper', 'Sleep'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children:
            tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final title = entry.value;
              final isSelected = _currentTabIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isSelected
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildOverviewTab(Homecontroller controller) {
    final analytics = controller.babyAnalytics;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context, 'Baby Information', [
            _buildInfoRow('Name', widget.baby.name ?? "Not set"),
            _buildInfoRow('Gender', widget.baby.gender ?? "Not set"),
            if (widget.baby.deliveryDate != null) ...[
              _buildInfoRow(
                'Date of Birth',
                _formatDate(DateTime.parse(widget.baby.deliveryDate!)),
              ),
              _buildInfoRow(
                'Age',
                controller.calculateAge(
                  DateTime.parse(widget.baby.deliveryDate!),
                ),
              ),
            ],
            _buildInfoRow('Weight', '${widget.baby.weight ?? "Not set"} kg'),
            _buildInfoRow('Blood Group', widget.baby.bloodGroup ?? "Not set"),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context, 'Analytics Summary', [
            if (analytics != null) ...[
              _buildInfoRow(
                'Total Feedings',
                '${analytics.feeding?.totalFeeds ?? 0}',
              ),
              _buildInfoRow(
                'Average Feed Amount',
                '${analytics.feeding?.averageAmountMl?.toStringAsFixed(1) ?? "0.0"} ml',
              ),
              _buildInfoRow(
                'Total Sleep Hours',
                '${analytics.sleep?.totalSleepHours?.toStringAsFixed(1) ?? "0.0"} hours',
              ),
              _buildInfoRow(
                'Average Sleep Session',
                '${analytics.sleep?.averageSessionDurationMinutes?.toStringAsFixed(1) ?? "0"} minutes',
              ),
              _buildInfoRow(
                'Total Diaper Changes',
                '${analytics.diaper?.totalChanges ?? 0}',
              ),
              _buildInfoRow(
                'Average Changes/Day',
                '${analytics.diaper?.averageChangesPerDay?.toStringAsFixed(1) ?? "0.0"}',
              ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No analytics data available'),
              ),
            ],
          ]),
        ],
      ),
    );
  }

  Widget _buildFeedingTab(Homecontroller controller) {
    final analytics = controller.babyAnalytics;
    final feedingLogs = controller.feedingLogs;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Feeding History',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (analytics?.feeding != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${analytics!.feeding?.totalFeeds ?? 0}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Text('Total Feeds'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${analytics.feeding?.averageAmountMl?.toStringAsFixed(0) ?? "0"}ml',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text('Avg Amount'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${analytics.feeding?.averageFeedTimeMinutes?.toStringAsFixed(0) ?? "0"}m',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const Text('Avg Time'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          Expanded(
            child:
                controller.isFeedingLogsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : feedingLogs.isNotEmpty
                    ? ListView.builder(
                      itemCount: feedingLogs.length,
                      itemBuilder: (context, index) {
                        final log = feedingLogs[index];
                        final duration = controller.getFeedingDurationString(
                          log,
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).dividerColor.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Icon Circle
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.local_drink,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Log Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ⏰ Start - End Time
                                    Text(
                                      log.startTime != null &&
                                              log.endTime != null
                                          ? "Start Time: ${_formatDateTime(log.startTime!)}"
                                          : log.startTime != null
                                          ? "Start Time: ${_formatDateTime(log.startTime!)}"
                                          : "Unknown time",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white, // subtle highlight
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Amount
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Amount: ${log.amount ?? 0} ml",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        Text(
                                          "Type : ${log.feedType.name ?? "Unknown"}",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Feed Type
                                    const SizedBox(height: 4),

                                    // Duration
                                    Text(
                                      "Duration: $duration",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: Colors.white.withOpacity(.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                    : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_drink, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No feeding logs available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // 🔧 CORRECTED: Diaper Tab with enum handling
  Widget _buildDiaperTab(Homecontroller controller) {
    final analytics = controller.babyAnalytics;
    final diaperLogs = controller.diaperLogs;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Diaper Changes',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (analytics?.diaper != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${analytics!.diaper?.totalChanges ?? 0}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const Text('Total Changes'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${analytics.diaper?.averageChangesPerDay?.toStringAsFixed(1) ?? "0.0"}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const Text('Avg Per Day'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          Expanded(
            child:
                controller.isDiaperLogsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : diaperLogs.isNotEmpty
                    ? ListView.builder(
                      itemCount: diaperLogs.length,
                      itemBuilder: (context, index) {
                        final log = diaperLogs[index];
                        final diaperTypeString =
                            log.diaperType?.toString().split('.').last ??
                            "Unknown";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).dividerColor.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Icon circle
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.child_care,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Log details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Time
                                    Text(
                                      log.time != null
                                          ? 'Change Time:    ${_formatTime(log.time!)}'
                                          : "Unknown time",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70, // highlight
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Diaper type with label
                                    Row(
                                      children: [
                                        Text(
                                          "Type: ",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getChangeTypeColor(
                                              diaperTypeString,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            diaperTypeString,
                                            style: TextStyle(
                                              color: _getChangeTypeColor(
                                                diaperTypeString,
                                              ),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                    : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.child_care, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No diaper logs available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // 🔧 CORRECTED: Sleep Tab with enum handling
  Widget _buildSleepTab(Homecontroller controller) {
    final analytics = controller.babyAnalytics;
    final sleepLogs = controller.sleepLogs;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sleep Sessions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (analytics?.sleep != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${analytics!.sleep?.totalSleepSessions ?? 0}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const Text('Total Sessions'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${analytics.sleep?.totalSleepHours?.toStringAsFixed(1) ?? "0.0"}h',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text('Total Hours'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${analytics.sleep?.averageSessionDurationMinutes?.toStringAsFixed(0) ?? "0"}m',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Text('Avg Session'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          Expanded(
            child:
                controller.isSleepLogsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : sleepLogs.isNotEmpty
                    ? ListView.builder(
                      itemCount: sleepLogs.length,
                      itemBuilder: (context, index) {
                        final log = sleepLogs[index];
                        final duration = controller.getSleepDurationString(log);

                        // Extract values safely
                        final locationString =
                            log.location?.toString().split('.').last ??
                            "Unknown";
                        final qualityString =
                            log.sleepQuality?.toString().split('.').last ??
                            "Unknown";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).dividerColor.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon circle
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.bedtime,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Main details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 🕒 Sleep Time Range
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (log.startTime != null)
                                          Text(
                                            'Start Time: ${_formatTime(log.startTime!)}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        if (false)
                                          if (log.endTime != null)
                                            const SizedBox(width: 30),
                                        if (false)
                                          Text(
                                            'End Time: ${_formatTime(log.endTime!)}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white70,
                                            ),
                                          ),

                                        if (log.startTime == null &&
                                            log.endTime == null)
                                          const Text(
                                            "Unknown time",
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    // 🛏️ Duration + Location
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Duration: $duration",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                        const SizedBox(width: 20),
                                        const Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getQualityColor(
                                              qualityString,
                                            ).withOpacity(0.1), // ✅ fixed
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            qualityString,
                                            style: TextStyle(
                                              color: _getQualityColor(
                                                qualityString,
                                              ), // ✅ consistent
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),

                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.white70,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          locationString,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                    : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bedtime, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No sleep logs available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // 🔧 FIXED: Updated to handle enum string values
  Color _getChangeTypeColor(String changeType) {
    switch (changeType.toLowerCase()) {
      case 'wet':
        return Colors.blue;
      case 'dirty':
      case 'soiled':
        return Colors.brown;
      case 'mixed':
      case 'both':
        return Colors.orange;
      case 'clean':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case "good":
        return Colors.green;
      case "fair":
        return Colors.orange;
      case "poor":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
