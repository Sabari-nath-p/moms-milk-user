import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gauge_chart/gauge_chart.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Models/AnalyticsOverviewModel.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class Feedingoverviewcard extends StatefulWidget {
  final FeedAnalytics model;
  Feedingoverviewcard({Key? key, required this.model}) : super(key: key);

  @override
  State<Feedingoverviewcard> createState() => _FeedingoverviewcardState();
}

class _FeedingoverviewcardState extends State<Feedingoverviewcard> {
  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final int breastFeeds = model.feedTypeBreakdown?.bREAST ?? 0;
    final int bottlefeeds = model.feedTypeBreakdown?.bOTTLE ?? 0;
    final int otherfeeds = model.feedTypeBreakdown?.oTHER ?? 0;
    final int totalFeeds = model.totalFeeds ?? 0;

    final double breast =
        (totalFeeds > 0) ? (breastFeeds / totalFeeds) * 180 : 0.0;
    final double bottle =
        (totalFeeds > 0) ? (bottlefeeds / totalFeeds) * 180 : 0.0;
    final double other =
        (totalFeeds > 0) ? (otherfeeds / totalFeeds) * 180 : 0.0;

    return Container(
      key: ValueKey(totalFeeds), // <-- Ensures proper rebuild
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: AppTheme.CardGradient,
      ),
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
                          RepaintBoundary(
                            child: SizedBox(
                              height: 100,
                              width: 170,
                              child: GaugeChart(
                                key: ValueKey(
                                  totalFeeds,
                                ), // <-- Prevents inversion
                                start: 180,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$totalFeeds",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Avg feed / Day : ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${model.averageFeedingTimePerDay} hr",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
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
                          barColor: Colors.orange,
                          gradientColors: [
                            Colors.orange.withOpacity(0.8),
                            Colors.orange.withOpacity(0.4),
                          ],
                        ),
                        TicketCard(
                          title: "Right",
                          count:
                              (model.feedPositionBreakdown!.rIGHT ?? 0)
                                  .toString(),
                          isRotateImage: true,
                          iconAsset: "lib/Assets/breastFeeding.png",
                          barColor: Colors.red,
                          gradientColors: [
                            Colors.red.withOpacity(0.8),
                            Colors.red.withOpacity(0.4),
                          ],
                        ),
                        TicketCard(
                          title: "Both",
                          count:
                              (model.feedPositionBreakdown!.bOTH ?? 0)
                                  .toString(),
                          iconAsset: "lib/Assets/feedingBottle.png",
                          barColor: Colors.indigo,
                          gradientColors: [
                            Colors.indigo.withOpacity(0.8),
                            Colors.indigo.withOpacity(0.4),
                          ],
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
  final bool isRotateImage;
  final List<Color> gradientColors;

  TicketCard({
    super.key,
    required this.title,
    required this.count,
    required this.iconAsset,
    this.isRotateImage = false,
    this.barColor = Colors.orange,
    this.gradientColors = const [Colors.orange, Colors.orangeAccent],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        width: 100,
        height: 35,
        //  padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Colored Vertical Bar
            Container(
              width: 6,
              height: 35,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 2. Icon + Text
            Row(
              children: [
                // if (isRotateImage)
                //   Transform(
                //     alignment: Alignment.center,
                //     transform: Matrix4.rotationY(math.pi),
                //     child: Image.asset(
                //       iconAsset,
                //       width: 20,
                //       height: 20,
                //       color: Colors.white.withOpacity(.76),
                //     ),
                //   )
                // else
                //   Image.asset(
                //     iconAsset,
                //     width: 20,
                //     height: 20,
                //     color: Colors.white.withOpacity(.76),
                //   ),
                // const SizedBox(width: 8),
                Text(
                  "$title  : ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  count,
                  style: TextStyle(
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
    );
  }
}
