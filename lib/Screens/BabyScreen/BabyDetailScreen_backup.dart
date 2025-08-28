// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:mommilk_user/Models/BabyModel.dart';
// import 'package:mommilk_user/Models/BabyAnalyticsModel.dart';
// import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';

// class BabyDetailsScreen extends StatefulWidget {
//   final BabyModel baby;
//   const BabyDetailsScreen({super.key, required this.baby});

//   @override
//   State<BabyDetailsScreen> createState() => _BabyDetailsScreenState();
// }

// class _BabyDetailsScreenState extends State<BabyDetailsScreen>
//     with TickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Baby")),
//       body: GetBuilder<Homecontroller>(
//         builder:
//             (controller) => Scaffold(
//               body: CustomScrollView(
//                 slivers: [
//                   SliverToBoxAdapter(
//                     child: Column(
//                       children: [
//                         _buildQuickStats(context),
//                         _buildTabBar(context),
//                       ],
//                     ),
//                   ),
//                   SliverFillRemaining(
//                     child: TabBarView(
//                       controller: TabController(length: 4, vsync: this),
//                       children: [
//                         _buildOverviewTab(),
//                         _buildFeedingTab(),
//                         _buildDiaperTab(),
//                         _buildSleepTab(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       ),
//     );
//   }

//   Widget _buildQuickStats(BuildContext context) {
//     return GetBuilder<Homecontroller>(
//       builder: (controller) {
//         if (controller.isAnalyticsLoading) {
//           return Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(40),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surface,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: const Center(
//               child: Column(
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Loading analytics...'),
//                 ],
//               ),
//             ),
//           );
//         }

//         final analytics = controller.babyAnalytics;
//         final feedingCount = analytics?.feeding?.totalFeeds?.toString() ?? '0';
//         final diaperCount = analytics?.diaper?.totalChanges?.toString() ?? '0';
//         final sleepHours = analytics?.sleep?.totalSleepHours?.toString() ?? '0';

//         return Container(
//           margin: const EdgeInsets.all(16),
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Recent Summary',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => controller.refreshAnalytics(),
//                     icon: const Icon(Icons.refresh),
//                     tooltip: 'Refresh Analytics',
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildStatCard(
//                       context,
//                       'Feedings',
//                       feedingCount,
//                       Icons.local_drink,
//                       Colors.blue,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildStatCard(
//                       context,
//                       'Diapers',
//                       diaperCount,
//                       Icons.child_care,
//                       Colors.orange,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildStatCard(
//                       context,
//                       'Sleep',
//                       '${sleepHours}h',
//                       Icons.bedtime,
//                       Colors.purple,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildStatCard(
//     BuildContext context,
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               color: color,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             title,
//             style: Theme.of(
//               context,
//             ).textTheme.bodySmall?.copyWith(color: color),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabBar(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TabBar(
//         controller: TabController(length: 4, vsync: this),
//         indicator: BoxDecoration(
//           color: Theme.of(context).colorScheme.primary,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         labelColor: Colors.white,
//         unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
//         tabs: const [
//           Tab(text: 'Overview'),
//           Tab(text: 'Feeding'),
//           Tab(text: 'Diaper'),
//           Tab(text: 'Sleep'),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverviewTab() {
//     return GetBuilder<Homecontroller>(
//       builder: (controller) {
//         final analytics = controller.babyAnalytics;

//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildInfoCard(context, 'Baby Information', [
//                   _buildInfoRow('Name', widget.baby.name ?? ""),
//                   _buildInfoRow(
//                     'Date of Birth',
//                     _formatDate(DateTime.parse(widget.baby.deliveryDate!)),
//                   ),
//                   _buildInfoRow(
//                     'Age',
//                     _calculateAge(DateTime.parse(widget.baby.deliveryDate!)),
//                   ),
//                   _buildInfoRow(
//                     'Weight',
//                     '${widget.baby.weight ?? "Not set"} kg',
//                   ),
//                   _buildInfoRow('Height', 'Not set cm'),
//                 ]),
//                 const SizedBox(height: 16),

//                 // Analytics Summary Section
//                 if (analytics != null) ...[
//                   _buildAnalyticsSummary(context, analytics),
//                   const SizedBox(height: 16),
//                 ],

//                 // Feeding Analytics
//                 if (analytics?.feeding != null) ...[
//                   _buildFeedingAnalytics(context, analytics!.feeding!),
//                   const SizedBox(height: 16),
//                 ],

//                 // Diaper Analytics
//                 if (analytics?.diaper != null) ...[
//                   _buildDiaperAnalytics(context, analytics!.diaper!),
//                   const SizedBox(height: 16),
//                 ],

//                 // Sleep Analytics
//                 if (analytics?.sleep != null) ...[
//                   _buildSleepAnalytics(context, analytics!.sleep!),
//                   const SizedBox(height: 16),
//                 ],
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFeedingTab() {
//     return GetBuilder<Homecontroller>(
//       builder: (controller) {
//         final analytics = controller.babyAnalytics;
//         final feeding = analytics?.feeding;

//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Feeding Analytics',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () => controller.refreshAnalytics(),
//                       icon: const Icon(Icons.refresh, size: 16),
//                       label: const Text('Refresh'),
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 if (controller.isAnalyticsLoading)
//                   const Center(
//                     child: Column(
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 16),
//                         Text('Loading feeding analytics...'),
//                       ],
//                     ),
//                   )
//                 else if (feeding != null) ...[
//                   _buildFeedingAnalytics(context, feeding),
//                 ] else
//                   const Center(child: Text('No feeding data available')),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDiaperTab() {
//     return GetBuilder<Homecontroller>(
//       builder: (controller) {
//         final analytics = controller.babyAnalytics;
//         final diaper = analytics?.diaper;

//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Diaper Analytics',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () => controller.refreshAnalytics(),
//                       icon: const Icon(Icons.refresh, size: 16),
//                       label: const Text('Refresh'),
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 if (controller.isAnalyticsLoading)
//                   const Center(
//                     child: Column(
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 16),
//                         Text('Loading diaper analytics...'),
//                       ],
//                     ),
//                   )
//                 else if (diaper != null) ...[
//                   _buildDiaperAnalytics(context, diaper),
//                   const SizedBox(height: 16),

//                   // Daily Patterns
//                   if (diaper.dailyPatterns != null &&
//                       diaper.dailyPatterns!.isNotEmpty) ...[
//                     _buildInfoCard(
//                       context,
//                       'Daily Diaper Patterns',
//                       diaper.dailyPatterns!
//                           .map(
//                             (pattern) =>
//                                 _buildDiaperPatternItem(context, pattern),
//                           )
//                           .toList(),
//                     ),
//                     const SizedBox(height: 16),
//                   ],

//                   // Hourly Distribution
//                   if (diaper.hourlyDistribution != null &&
//                       diaper.hourlyDistribution!.isNotEmpty) ...[
//                     _buildInfoCard(
//                       context,
//                       'Hourly Distribution',
//                       diaper.hourlyDistribution!
//                           .map(
//                             (hour) =>
//                                 _buildHourlyDistributionItem(context, hour),
//                           )
//                           .toList(),
//                     ),
//                   ],
//                 ] else
//                   const Center(child: Text('No diaper data available')),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSleepTab() {
//     return GetBuilder<Homecontroller>(
//       builder: (controller) {
//         final analytics = controller.babyAnalytics;
//         final sleep = analytics?.sleep;

//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Sleep Analytics',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () => controller.refreshAnalytics(),
//                       icon: const Icon(Icons.refresh, size: 16),
//                       label: const Text('Refresh'),
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 if (controller.isAnalyticsLoading)
//                   const Center(
//                     child: Column(
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 16),
//                         Text('Loading sleep analytics...'),
//                       ],
//                     ),
//                   )
//                 else if (sleep != null) ...[
//                   _buildSleepAnalytics(context, sleep),
//                   const SizedBox(height: 16),

//                   // Sleep Quality Trends
//                   if (sleep.sleepQualityTrends != null &&
//                       sleep.sleepQualityTrends!.isNotEmpty) ...[
//                     _buildInfoCard(
//                       context,
//                       'Sleep Quality Trends',
//                       sleep.sleepQualityTrends!
//                           .map(
//                             (trend) => _buildSleepQualityItem(context, trend),
//                           )
//                           .toList(),
//                     ),
//                     const SizedBox(height: 16),
//                   ],

//                   // Daily Sleep Patterns
//                   if (sleep.dailyPatterns != null &&
//                       sleep.dailyPatterns!.isNotEmpty) ...[
//                     _buildInfoCard(
//                       context,
//                       'Daily Sleep Patterns',
//                       sleep.dailyPatterns!
//                           .map(
//                             (pattern) =>
//                                 _buildSleepPatternItem(context, pattern),
//                           )
//                           .toList(),
//                     ),
//                   ],
//                 ] else
//                   const Center(child: Text('No sleep data available')),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInfoCard(
//     BuildContext context,
//     String title,
//     List<Widget> children,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Theme.of(context).dividerColor.withOpacity(0.1),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: Theme.of(
//               context,
//             ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 12),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.color?.withOpacity(0.7),
//             ),
//           ),
//           Text(
//             value,
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }

//   String _calculateAge(DateTime birthDate) {
//     final now = DateTime.now();
//     final difference = now.difference(birthDate);

//     if (difference.inDays < 30) {
//       return '${difference.inDays} days';
//     } else if (difference.inDays < 365) {
//       final months = (difference.inDays / 30).floor();
//       return '$months months';
//     } else {
//       final years = (difference.inDays / 365).floor();
//       final months = ((difference.inDays % 365) / 30).floor();
//       return '$years years, $months months';
//     }
//   }

//   // Additional helper methods for analytics display

//     if (difference.inDays < 30) {
//       return '${difference.inDays} days';
//     } else if (difference.inDays < 365) {
//       final months = (difference.inDays / 30).floor();
//       return '$months months';
//     } else {
//       final years = (difference.inDays / 365).floor();
//       final months = ((difference.inDays % 365) / 30).floor();
//       return '$years years, $months months';
//     }
//   }

//   Color _getDiaperTypeColor(String type) {
//     switch (type.toLowerCase()) {
//       case 'wet':
//         return Colors.blue;
//       case 'dirty':
//         return Colors.brown;
//       case 'both':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   Color _getSleepQualityColor(String quality) {
//     switch (quality.toLowerCase()) {
//       case 'excellent':
//         return Colors.green;
//       case 'good':
//         return Colors.blue;
//       case 'fair':
//         return Colors.orange;
//       case 'poor':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   List<Map<String, dynamic>> _getDummyFeedings() {
//     return [
//       {
//         'amount': 120,
//         'type': 'Breast Milk',
//         'time': '2 hours ago',
//         'notes': null,
//       },
//       {
//         'amount': 100,
//         'type': 'Formula',
//         'time': '5 hours ago',
//         'notes': 'Baby seemed extra hungry',
//       },
//       {
//         'amount': 140,
//         'type': 'Breast Milk',
//         'time': '8 hours ago',
//         'notes': null,
//       },
//     ];
//   }

//   List<Map<String, dynamic>> _getDummyDiapers() {
//     return [
//       {'type': 'Wet', 'time': '45 minutes ago'},
//       {'type': 'Both', 'time': '3 hours ago'},
//       {'type': 'Dirty', 'time': '6 hours ago'},
//     ];
//   }

//   List<Map<String, dynamic>> _getDummySleeps() {
//     return [
//       {
//         'duration': '2h 30m',
//         'quality': 'Good',
//         'startTime': '1:00 PM',
//         'endTime': '3:30 PM',
//       },
//       {
//         'duration': '1h 45m',
//         'quality': 'Excellent',
//         'startTime': '10:00 AM',
//         'endTime': '11:45 AM',
//       },
//       {
//         'duration': '3h 15m',
//         'quality': 'Fair',
//         'startTime': '6:00 AM',
//         'endTime': '9:15 AM',
//       },
//     ];
//   }

//   // Analytics building methods
//   Widget _buildAnalyticsSummary(
//     BuildContext context,
//     BabyAnalyticsLog analytics,
//   ) {
//     final dateRange = analytics.dateRange;
//     final startDate =
//         dateRange?.startDate != null
//             ? _formatDate(DateTime.parse(dateRange!.startDate!))
//             : 'Unknown';
//     final endDate =
//         dateRange?.endDate != null
//             ? _formatDate(DateTime.parse(dateRange!.endDate!))
//             : 'Unknown';

//     return _buildInfoCard(context, 'Analytics Period', [
//       _buildInfoRow('Period', '$startDate - $endDate'),
//       _buildInfoRow(
//         'Generated',
//         analytics.generatedAt != null
//             ? _formatDate(DateTime.parse(analytics.generatedAt!))
//             : 'Unknown',
//       ),
//     ]);
//   }

//   Widget _buildFeedingAnalytics(BuildContext context, Feeding feeding) {
//     return _buildInfoCard(context, 'Feeding Analytics', [
//       _buildInfoRow('Total Feeds', '${feeding.totalFeeds ?? 0}'),
//       _buildInfoRow(
//         'Total Feed Time',
//         '${feeding.totalFeedTimeMinutes ?? 0} minutes',
//       ),
//       _buildInfoRow(
//         'Average Feed Time',
//         '${feeding.averageFeedTimeMinutes ?? 0} minutes',
//       ),
//       _buildInfoRow('Total Amount', '${feeding.totalAmountMl ?? 0} ml'),
//       _buildInfoRow('Average Amount', '${feeding.averageAmountMl ?? 0} ml'),
//       if (feeding.feedMethodCount != null) ...[
//         _buildInfoRow(
//           'Breast Feeds',
//           '${feeding.feedMethodCount!.bREAST ?? 0}',
//         ),
//         _buildInfoRow(
//           'Bottle Feeds',
//           '${feeding.feedMethodCount!.bOTTLE ?? 0}',
//         ),
//         _buildInfoRow('Other Feeds', '${feeding.feedMethodCount!.oTHER ?? 0}'),
//       ],
//       if (feeding.positionBreakdown != null) ...[
//         _buildInfoRow(
//           'Left Position',
//           '${feeding.positionBreakdown!.lEFT ?? 0}',
//         ),
//         _buildInfoRow(
//           'Right Position',
//           '${feeding.positionBreakdown!.rIGHT ?? 0}',
//         ),
//         _buildInfoRow(
//           'Both Position',
//           '${feeding.positionBreakdown!.bOTH ?? 0}',
//         ),
//       ],
//     ]);
//   }

//   Widget _buildDiaperAnalytics(BuildContext context, Diaper diaper) {
//     return _buildInfoCard(context, 'Diaper Analytics', [
//       _buildInfoRow('Total Changes', '${diaper.totalChanges ?? 0}'),
//       _buildInfoRow(
//         'Average Per Day',
//         '${diaper.averageChangesPerDay?.toStringAsFixed(1) ?? '0.0'}',
//       ),
//       if (diaper.diaperTypeBreakdown != null) ...[
//         _buildInfoRow(
//           'Solid Changes',
//           '${diaper.diaperTypeBreakdown!.sOLID ?? 0}',
//         ),
//         _buildInfoRow(
//           'Liquid Changes',
//           '${diaper.diaperTypeBreakdown!.lIQUID ?? 0}',
//         ),
//         _buildInfoRow('Both Types', '${diaper.diaperTypeBreakdown!.bOTH ?? 0}'),
//       ],
//     ]);
//   }

//   Widget _buildSleepAnalytics(BuildContext context, Sleep sleep) {
//     return _buildInfoCard(context, 'Sleep Analytics', [
//       _buildInfoRow('Total Sleep Sessions', '${sleep.totalSleepSessions ?? 0}'),
//       _buildInfoRow('Total Sleep Hours', '${sleep.totalSleepHours ?? 0} hours'),
//       _buildInfoRow(
//         'Average Sleep Hours',
//         '${sleep.averageSleepHours ?? 0} hours',
//       ),
//       _buildInfoRow(
//         'Average Session Duration',
//         '${sleep.averageSessionDurationMinutes ?? 0} minutes',
//       ),
//       _buildInfoRow(
//         'Longest Session',
//         '${sleep.longestSleepSessionMinutes ?? 0} minutes',
//       ),
//       _buildInfoRow(
//         'Shortest Session',
//         '${sleep.shortestSleepSessionMinutes ?? 0} minutes',
//       ),
//       if (sleep.locationBreakdown != null) ...[
//         _buildInfoRow('Crib Sleep', '${sleep.locationBreakdown!.cRIB ?? 0}'),
//         _buildInfoRow('Bed Sleep', '${sleep.locationBreakdown!.bED ?? 0}'),
//         _buildInfoRow(
//           'Stroller Sleep',
//           '${sleep.locationBreakdown!.sTROLLER ?? 0}',
//         ),
//         _buildInfoRow(
//           'Other Locations',
//           '${sleep.locationBreakdown!.oTHER ?? 0}',
//         ),
//       ],
//     ]);
//   }

//   // Additional helper methods for analytics display
//   Widget _buildDiaperPatternItem(BuildContext context, DailyPatterns pattern) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             _formatDate(DateTime.parse(pattern.date ?? '')),
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.color?.withOpacity(0.7),
//             ),
//           ),
//           Text(
//             '${pattern.changeCount ?? 0} changes',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHourlyDistributionItem(
//     BuildContext context,
//     HourlyDistribution hour,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             '${hour.hour ?? 0}:00',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.color?.withOpacity(0.7),
//             ),
//           ),
//           Text(
//             '${hour.changeCount ?? 0} changes',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSleepQualityItem(
//     BuildContext context,
//     SleepQualityTrends trend,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             _formatDate(DateTime.parse(trend.date ?? '')),
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.color?.withOpacity(0.7),
//             ),
//           ),
//           Text(
//             '${trend.totalHours ?? 0}h - ${trend.averageQuality ?? 'Unknown'}',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSleepPatternItem(
//     BuildContext context,
//     DailySleepPatterns pattern,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             _formatDate(DateTime.parse(pattern.date ?? '')),
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.color?.withOpacity(0.7),
//             ),
//           ),
//           Text(
//             '${pattern.sessionCount ?? 0} sessions, ${pattern.totalHours ?? 0}h',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
// }
