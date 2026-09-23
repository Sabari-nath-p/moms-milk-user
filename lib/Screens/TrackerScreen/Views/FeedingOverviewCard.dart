import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauge_chart/gauge_chart.dart';
import 'package:get/utils.dart';
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
        borderRadius: BorderRadius.circular(12.r),
        gradient: AppTheme.CardGradient,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child:
            (totalFeeds == 0)
                ? Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 100.h,
                    child: Text('No data available'.tr),
                  ),
                )
                : Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 60.h),
                          RepaintBoundary(
                            child: SizedBox(
                              height: 100.h,
                              width: 170.w,
                              child: GaugeChart(
                                key: ValueKey(
                                  totalFeeds,
                                ), // <-- Prevents inversion
                                start: 180,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$totalFeeds".tr,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Total Feeds".tr,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 2.r,
                                          backgroundColor: Colors.amber,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          "Breast".tr,
                                          style: TextStyle(fontSize: 9.sp),
                                        ),
                                        SizedBox(width: 5.w),
                                        CircleAvatar(
                                          radius: 2.r,
                                          backgroundColor: Colors.red,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          "Bottle",
                                          style: TextStyle(fontSize: 9.sp),
                                        ),
                                        SizedBox(width: 5.w),
                                        CircleAvatar(
                                          radius: 2.r,
                                          backgroundColor: Colors.indigo,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          "Solid".tr,
                                          style: TextStyle(fontSize: 9.sp),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Avg feed / Day : ".tr,
                                          style: TextStyle(
                                            fontSize: 12.sp,
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
                                    description: "Breast".tr,
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
                          title: "Left".tr,
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
                          title: "Right".tr,
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
                          title: "Both".tr,
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
    this.barColor = const Color.fromRGBO(255, 152, 0, 1),
    this.gradientColors =const  [Colors.orange, Colors.orangeAccent],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0.r),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        width: 100.w,
        height: 35.h,
        //  padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Colored Vertical Bar
            Container(
              width: 6.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0.r),
                  bottomLeft: Radius.circular(8.0.r),
                ),
              ),
            ),
            SizedBox(width: 10.w),
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
                // SizedBox(width: 8),
                Text(
                  "$title  : ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 12.sp,
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
