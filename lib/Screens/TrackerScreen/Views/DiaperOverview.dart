import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Screens/TrackerScreen/Models/AnalyticsOverviewModel.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class DiaperOverviewCard extends StatelessWidget {
  DiaperAnalytics model;
  DiaperOverviewCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Diaper Analytics'.tr,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 150.h,
          width: 390.w,
          child: _buildDiaperTypeChart(context, model.diaperTypeBreakdown!!),
        ),
      ],
    );
  }
}

Widget _buildDiaperTypeChart(BuildContext context, DiaperTypeBreakdown model) {
  final sections = <PieChartSectionData>[];
  final colors = [Colors.brown, Colors.blue, Colors.orange, Colors.red];
  final data = [
    ('Solid', model.sOLID ?? 0),
    ('Liquid', model.lIQUID ?? 0),
    ('Both', model.bOTH ?? 0),
    ("Empty", model.eMPTY ?? 0),
  ];

  for (int i = 0; i < data.length; i++) {
    if (data[i].$2 > 0) {
      sections.add(
        PieChartSectionData(
          color: colors[i],
          value: data[i].$2.toDouble(),
          title: '${data[i].$2}',
          radius: 30.r,
          titleStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  return Container(
    height: 200.h,
    decoration: BoxDecoration(
     // gradient: AppTheme.CardGradient,
      borderRadius: BorderRadius.circular(16.r),
      //boxShadow: [
        //BoxShadow(
          //color: Colors.black.withOpacity(0.05),
          //blurRadius: 10,
        //  offset: Offset(0, 2),
       // ),
     // ],
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
                      centerSpaceRadius: 30.r,
                      sectionsSpace: 2.w,
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
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 12.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    color: colors[index],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '${item.$1}: ${item.$2}',
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            )
            : Center(child: Text('No data available'.tr)),
  );
}
