import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gauge_chart/gauge_chart.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Models/AnalyticsOverviewModel.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class Feedingoverviewcard extends StatelessWidget {
  FeedAnalytics model;
  Feedingoverviewcard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final int breastFeeds = model.feedTypeBreakdown?.bREAST ?? 0;
    final int bottlefeeds = model.feedTypeBreakdown?.bOTTLE ?? 0;
    final int otherfeeds = model.feedTypeBreakdown?.oTHER ?? 0;

    // Safely get the total number of feeds. Default to 0 if null.
    final int totalFeeds = model.totalFeeds ?? 0;

    // Calculate the value, ensuring we don't divide by zero.
    // If totalFeeds is 0, the result will be 0.0.
    final double breast =
        (totalFeeds > 0) ? (breastFeeds / totalFeeds) * 180 : 0.0;
    final double bottle =
        (totalFeeds > 0) ? (bottlefeeds / totalFeeds) * 180 : 0.0;
    final double other =
        (totalFeeds > 0) ? (otherfeeds / totalFeeds) * 180 : 0.0;

    return Card(
      color: Theme.of(context).primaryColor.withOpacity(.15),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            (totalFeeds == 0)
                ? Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    child: Text('No data available'),
                  ),
                )
                : Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 60),
                          SizedBox(
                            height: 100,
                            width: 170,
                            child: GaugeChart(
                              start: 180,

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${totalFeeds}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Total Feeds",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 2,
                                        backgroundColor: Colors.amber,
                                      ),
                                      SizedBox(width: 2),

                                      Text(
                                        "Breast",
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      SizedBox(width: 5),

                                      CircleAvatar(
                                        radius: 2,
                                        backgroundColor: Colors.red,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Bottle",
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      SizedBox(width: 5),

                                      CircleAvatar(
                                        radius: 2,
                                        backgroundColor: Colors.indigo,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Solid",
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Avg feed / Day : ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "${model.averageFeedingTimePerDay} hr",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              gap: 20,
                              borderWidth: 22,
                              borderEdge: StrokeCap.butt,
                              shouldAnimate: true,
                              isHalfChart: true,
                              children: [
                                PieData(
                                  value: breast,
                                  color: Colors.orange,
                                  description: "Breast",
                                ),
                                PieData(
                                  value: bottle,
                                  color: Colors.red,
                                  description: "",
                                ),
                                PieData(
                                  value: other,
                                  color: Colors.indigo,
                                  description: "",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        TicketCard(
                          title: "Left",
                          count:
                              (model.feedPositionBreakdown!.lEFT ?? 0)
                                  .toString(),
                          iconAsset: "lib/Assets/breastFeeding.png",
                        ),
                        TicketCard(
                          title: "Right",
                          count:
                              (model.feedPositionBreakdown!.rIGHT ?? 0)
                                  .toString(),
                          isRotateImage: true,
                          iconAsset: "lib/Assets/breastFeeding.png",
                        ),
                        TicketCard(
                          title: "Both",
                          count:
                              (model.feedPositionBreakdown!.bOTH ?? 0)
                                  .toString(),
                          iconAsset: "lib/Assets/feedingBottle.png",
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final String title;
  final String count;
  final String iconAsset;
  final Color barColor;
  final Color iconBackgroundColor;
  bool isRotateImage;

  TicketCard({
    super.key,
    required this.title,
    required this.count,
    required this.iconAsset,
    this.isRotateImage = false,
    this.barColor = Colors.orange,
    this.iconBackgroundColor = const Color(0xFFE0F2F1), // A light teal
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      //  elevation: 2.0,
      shadowColor: Colors.black26,
      color: AppTheme.primaryColor.withOpacity(.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(color: AppTheme.primaryColor.withOpacity(.5)),
      ),
      child: Container(
        width: 120,
        child: Row(
          mainAxisSize: MainAxisSize.min, // Make the card fit its content
          children: [
            // 1. Colored Vertical Bar
            Container(
              width: 6,
              height: 50,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
            ),

            // 2. Card Content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: Row(
                children: [
                  // 3. Icon with colored background
                  if (isRotateImage)
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Image.asset(
                        iconAsset,
                        width: 20,
                        height: 20,
                        color: Colors.white.withOpacity(.76),
                      ),
                    )
                  else
                    Image.asset(
                      iconAsset,
                      width: 20,
                      height: 20,
                      color: Colors.white.withOpacity(.76),
                    ),
                  const SizedBox(width: 16),

                  // 4. Text Column
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title + "  : ",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        count,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
