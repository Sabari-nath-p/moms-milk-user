import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mommilk_user/Models/BabyModel.dart';
import 'package:mommilk_user/Models/BabyAnalyticsModel.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Homecontroller homeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize analytics data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        homeController = Get.find<Homecontroller>();
      } catch (e) {
        // If HomeController is not found, create a new one
        homeController = Get.put(Homecontroller());
      }

      // Ensure babies are fetched first
      if (homeController.myBabies.isEmpty) {
        homeController.fetchBabies();
      } else {
        // If babies exist but no baby is selected, select the first one
        if (homeController.selectedBady == null &&
            homeController.myBabies.isNotEmpty) {
          homeController.selectedBady = homeController.myBabies.first;
          homeController.update();
        }

        // Fetch analytics for the selected baby if not already available
        if (homeController.babyAnalytics == null &&
            homeController.selectedBady != null) {
          homeController.fetchBabyAnalytics(
            babyId: homeController.selectedBady!.id!,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<Homecontroller>(
        builder: (controller) {
          if (controller.isAnalyticsLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading analytics...'),
                ],
              ),
            );
          }
          // Handle different states
          else if (controller.myBabies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.child_care,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text('No babies found'),
                  const SizedBox(height: 8),
                  const Text(
                    'Please add a baby profile first',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchBabies(),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          } else if (controller.babyAnalytics == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text('No analytics data available'),
                  const SizedBox(height: 8),
                  Text(
                    'For ${controller.selectedBady?.name ?? 'selected baby'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.refreshAnalytics(),
                    child: const Text('Load Analytics'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Baby Selector
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.local_drink), text: 'Feeding'),
                  Tab(icon: Icon(Icons.child_care), text: 'Diaper'),
                  Tab(icon: Icon(Icons.bedtime), text: 'Sleep'),
                ],
              ),

              // Tab Content
              Expanded(
                child:
                    controller.babyAnalytics != null
                        ? TabBarView(
                          controller: _tabController,
                          children: [
                            _buildFeedingAnalytics(controller.babyAnalytics!),
                            _buildDiaperAnalytics(controller.babyAnalytics!),
                            _buildSleepAnalytics(controller.babyAnalytics!),
                          ],
                        )
                        : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.analytics,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text('No analytics data available'),
                              SizedBox(height: 8),
                              Text(
                                'Select a baby to view analytics',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeedingAnalytics(BabyAnalyticsLog analytics) {
    final feeding = analytics.feeding;
    if (feeding == null) {
      return const Center(child: Text('No feeding data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          _buildSummaryCards([
            _SummaryCardData(
              'Total Feeds',
              '${feeding.totalFeeds ?? 0}',
              Icons.local_drink,
              Colors.blue,
            ),
            _SummaryCardData(
              'Avg Amount',
              '${feeding.averageAmountMl?.toStringAsFixed(0) ?? 0} ml',
              Icons.water_drop,
              Colors.cyan,
            ),
            _SummaryCardData(
              'Avg Time',
              '${feeding.averageFeedTimeMinutes?.toStringAsFixed(0) ?? 0} min',
              Icons.timer,
              Colors.orange,
            ),
          ]),

          const SizedBox(height: 24),

          // Feeding Method Breakdown
          if (feeding.feedMethodCount != null) ...[
            _buildSectionTitle('Feeding Method Distribution'),
            const SizedBox(height: 16),
            _buildFeedingMethodChart(feeding.feedMethodCount!),
            const SizedBox(height: 24),
          ],

          // Position Breakdown
          if (feeding.positionBreakdown != null) ...[
            _buildSectionTitle('Position Distribution'),
            const SizedBox(height: 16),
            _buildPositionChart(feeding.positionBreakdown!),
            const SizedBox(height: 24),
          ],

          // Daily Patterns
          if (feeding.feedingPatterns != null &&
              feeding.feedingPatterns!.isNotEmpty) ...[
            _buildSectionTitle('Daily Feeding Patterns'),
            const SizedBox(height: 16),
            _buildFeedingPatternsList(feeding.feedingPatterns!),
          ],
        ],
      ),
    );
  }

  Widget _buildDiaperAnalytics(BabyAnalyticsLog analytics) {
    final diaper = analytics.diaper;
    if (diaper == null) {
      return const Center(child: Text('No diaper data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          _buildSummaryCards([
            _SummaryCardData(
              'Total Changes',
              '${diaper.totalChanges ?? 0}',
              Icons.child_care,
              Colors.orange,
            ),
            _SummaryCardData(
              'Avg Per Day',
              '${diaper.averageChangesPerDay?.toStringAsFixed(1) ?? 0.0}',
              Icons.today,
              Colors.purple,
            ),
          ]),

          const SizedBox(height: 24),

          // Diaper Type Breakdown
          if (diaper.diaperTypeBreakdown != null) ...[
            _buildSectionTitle('Diaper Type Distribution'),
            const SizedBox(height: 16),
            _buildDiaperTypeChart(diaper.diaperTypeBreakdown!),
            const SizedBox(height: 24),
          ],

          // Daily Patterns
          if (diaper.dailyPatterns != null &&
              diaper.dailyPatterns!.isNotEmpty) ...[
            _buildSectionTitle('Daily Change Patterns'),
            const SizedBox(height: 16),
            _buildDiaperPatternsList(diaper.dailyPatterns!),
            const SizedBox(height: 24),
          ],

          // Hourly Distribution
          if (diaper.hourlyDistribution != null &&
              diaper.hourlyDistribution!.isNotEmpty) ...[
            _buildSectionTitle('Hourly Distribution'),
            const SizedBox(height: 16),
            _buildHourlyDistributionList(diaper.hourlyDistribution!),
          ],
        ],
      ),
    );
  }

  Widget _buildSleepAnalytics(BabyAnalyticsLog analytics) {
    final sleep = analytics.sleep;
    if (sleep == null) {
      return const Center(child: Text('No sleep data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          _buildSummaryCards([
            _SummaryCardData(
              'Total Sessions',
              '${sleep.totalSleepSessions ?? 0}',
              Icons.bedtime,
              Colors.purple,
            ),
            _SummaryCardData(
              'Total Hours',
              '${sleep.totalSleepHours?.toStringAsFixed(1) ?? 0}h',
              Icons.access_time,
              Colors.indigo,
            ),
            _SummaryCardData(
              'Avg Session',
              '${sleep.averageSessionDurationMinutes?.toStringAsFixed(0) ?? 0} min',
              Icons.timer,
              Colors.blue,
            ),
          ]),

          const SizedBox(height: 24),

          // Location Breakdown
          if (sleep.locationBreakdown != null) ...[
            _buildSectionTitle('Sleep Location Distribution'),
            const SizedBox(height: 16),
            _buildLocationList(sleep.locationBreakdown!),
            const SizedBox(height: 24),
          ],

          // Sleep Quality Trends
          if (sleep.sleepQualityTrends != null &&
              sleep.sleepQualityTrends!.isNotEmpty) ...[
            _buildSectionTitle('Sleep Quality Trends'),
            const SizedBox(height: 16),
            _buildSleepQualityList(sleep.sleepQualityTrends!),
            const SizedBox(height: 24),
          ],

          // Daily Sleep Patterns
          if (sleep.dailyPatterns != null &&
              sleep.dailyPatterns!.isNotEmpty) ...[
            _buildSectionTitle('Daily Sleep Patterns'),
            const SizedBox(height: 16),
            _buildSleepPatternsList(sleep.dailyPatterns!),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<_SummaryCardData> cards) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            width: 140,
            margin: EdgeInsets.only(right: index < cards.length - 1 ? 12 : 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: card.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: card.color.withOpacity(0.3), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(card.icon, color: card.color, size: 24),
                const SizedBox(height: 8),
                Text(
                  card.value,
                  style: TextStyle(
                    color: card.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  card.title,
                  style: TextStyle(
                    color: card.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFeedingMethodChart(FeedMethodCount feedMethod) {
    final sections = <PieChartSectionData>[];
    final colors = [Colors.blue, Colors.green, Colors.orange];
    final data = [
      ('Breast', feedMethod.bREAST ?? 0),
      ('Bottle', feedMethod.bOTTLE ?? 0),
      ('Other', feedMethod.oTHER ?? 0),
    ];

    for (int i = 0; i < data.length; i++) {
      if (data[i].$2 > 0) {
        sections.add(
          PieChartSectionData(
            color: colors[i],
            value: data[i].$2.toDouble(),
            title: '${data[i].$2}',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:
          sections.isNotEmpty
              ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          data.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: colors[index],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${item.$1}: ${item.$2}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              )
              : const Center(child: Text('No data available')),
    );
  }

  Widget _buildPositionChart(PositionBreakdown position) {
    final data = [
      ('Left', position.lEFT ?? 0),
      ('Right', position.rIGHT ?? 0),
      ('Both', position.bOTH ?? 0),
      ('Not Specified', position.nOTSPECIFIED ?? 0),
    ];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          barGroups:
              data.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.$2.toDouble(),
                      color: Colors.blue.withOpacity(0.8),
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        data[value.toInt()].$1,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildFeedingPatternsList(List<FeedingPatterns> patterns) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.local_drink, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Feeding Pattern Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // List Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: patterns.length,
            separatorBuilder:
                (context, index) =>
                    Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
            itemBuilder: (context, index) {
              final pattern = patterns[index];
              final date = DateTime.parse(pattern.date ?? '');

              return Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Date
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${date.day}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            _getMonthName(date.month).substring(0, 3),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.numbers,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Feeds: ${pattern.feedCount ?? 0}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Duration: ${pattern.totalTimeMinutes?.toStringAsFixed(0) ?? 0} min',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.water_drop,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Amount: ${pattern.totalAmountMl?.toStringAsFixed(0) ?? 0} ml',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Progress indicator
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getFeedingIntensityColor(
                          pattern.feedCount ?? 0,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiaperPatternsList(List<DailyPatterns> patterns) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.child_care, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Diaper Change Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // List Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: patterns.length,
            separatorBuilder:
                (context, index) =>
                    Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
            itemBuilder: (context, index) {
              final pattern = patterns[index];
              final date = DateTime.parse(pattern.date ?? '');

              return Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Date
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${date.day}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            _getMonthName(date.month).substring(0, 3),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.numbers,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Total Changes: ${pattern.changeCount ?? 0}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDiaperTypeChip(
                                'Solid',
                                pattern.solidCount ?? 0,
                                Colors.brown,
                              ),
                              _buildDiaperTypeChip(
                                'Liquid',
                                pattern.liquidCount ?? 0,
                                Colors.blue,
                              ),
                              _buildDiaperTypeChip(
                                'Both',
                                pattern.bothCount ?? 0,
                                Colors.purple,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Progress indicator
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getDiaperIntensityColor(
                          pattern.changeCount ?? 0,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSleepPatternsList(List<DailySleepPatterns> patterns) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.bedtime, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Sleep Pattern Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // List Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: patterns.length,
            separatorBuilder:
                (context, index) =>
                    Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
            itemBuilder: (context, index) {
              final pattern = patterns[index];
              final date = DateTime.parse(pattern.date ?? '');

              return Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Date
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${date.day}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          Text(
                            _getMonthName(date.month).substring(0, 3),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.purple.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.hotel,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Sessions: ${pattern.sessionCount ?? 0}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Total: ${pattern.totalHours?.toStringAsFixed(1) ?? 0} hours',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.timeline,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Avg Session: ${pattern.averageSessionMinutes?.toStringAsFixed(0) ?? 0} min',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Sleep quality indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getSleepQualityColor(pattern.totalHours ?? 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getSleepQualityText(pattern.totalHours ?? 0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiaperTypeChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  Color _getFeedingIntensityColor(int feedCount) {
    if (feedCount >= 8) return Colors.green;
    if (feedCount >= 6) return Colors.orange;
    if (feedCount >= 4) return Colors.red;
    return Colors.grey;
  }

  Color _getDiaperIntensityColor(int changeCount) {
    if (changeCount >= 8) return Colors.orange;
    if (changeCount >= 6) return Colors.amber;
    if (changeCount >= 4) return Colors.yellow;
    return Colors.grey;
  }

  Color _getSleepQualityColor(double hours) {
    if (hours >= 10) return Colors.green;
    if (hours >= 8) return Colors.blue;
    if (hours >= 6) return Colors.orange;
    return Colors.red;
  }

  String _getSleepQualityText(double hours) {
    if (hours >= 10) return 'Excellent';
    if (hours >= 8) return 'Good';
    if (hours >= 6) return 'Fair';
    return 'Poor';
  }

  Widget _buildHourlyDistributionList(List<HourlyDistribution> distribution) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Hourly Distribution',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Grid Layout
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: distribution.length,
              itemBuilder: (context, index) {
                final item = distribution[index];
                return Container(
                  // padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${item.hour ?? 0}h',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${item.changeCount ?? 0}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      Text(
                        'changes',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.purple.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationList(LocationBreakdown location) {
    final data = [
      ('Crib', location.cRIB ?? 0, Icons.crib, Colors.brown),
      ('Bed', location.bED ?? 0, Icons.bed, Colors.blue),
      ('Stroller', location.sTROLLER ?? 0, Icons.stroller, Colors.green),
      ('Other', location.oTHER ?? 0, Icons.more_horiz, Colors.grey),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.indigo, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Sleep Locations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // List Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder:
                (context, index) =>
                    Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
            itemBuilder: (context, index) {
              final item = data[index];
              final total = data.fold(0, (sum, item) => sum + item.$2);
              final percentage = total > 0 ? (item.$2 / total * 100) : 0;

              return Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: item.$4.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.$3, color: item.$4, size: 20),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$1,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${item.$2} sessions (${percentage.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.$4.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${item.$2}',
                        style: TextStyle(
                          color: item.$4,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSleepQualityList(List<SleepQualityTrends> trends) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.indigo, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Sleep Quality Trends',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // List Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trends.length,
            separatorBuilder:
                (context, index) =>
                    Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
            itemBuilder: (context, index) {
              final trend = trends[index];
              final date = DateTime.parse(trend.date ?? '');

              return Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Date
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${date.day}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          Text(
                            _getMonthName(date.month).substring(0, 3),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.indigo.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.hotel,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Sessions: ${trend.sessionCount ?? 0}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Total: ${trend.totalHours?.toStringAsFixed(1) ?? 0} hours',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Quality: ${trend.averageQuality ?? 'Unknown'}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Quality indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getSleepQualityColor(trend.totalHours ?? 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getSleepQualityText(trend.totalHours ?? 0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiaperTypeChart(DiaperTypeBreakdown breakdown) {
    final sections = <PieChartSectionData>[];
    final colors = [Colors.brown, Colors.blue, Colors.orange];
    final data = [
      ('Solid', breakdown.sOLID ?? 0),
      ('Liquid', breakdown.lIQUID ?? 0),
      ('Both', breakdown.bOTH ?? 0),
    ];

    for (int i = 0; i < data.length; i++) {
      if (data[i].$2 > 0) {
        sections.add(
          PieChartSectionData(
            color: colors[i],
            value: data[i].$2.toDouble(),
            title: '${data[i].$2}',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:
          sections.isNotEmpty
              ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          data.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: colors[index],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${item.$1}: ${item.$2}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              )
              : const Center(child: Text('No data available')),
    );
  }
}

class _SummaryCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _SummaryCardData(this.title, this.value, this.icon, this.color);
}
