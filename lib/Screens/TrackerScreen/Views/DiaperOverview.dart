import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
          'Diaper Analytics',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          width: 390,
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
          radius: 30,
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
     // gradient: AppTheme.CardGradient,
      borderRadius: BorderRadius.circular(16),
      //boxShadow: [
        //BoxShadow(
          //color: Colors.black.withOpacity(0.05),
          //blurRadius: 10,
        //  offset: const Offset(0, 2),
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
                      centerSpaceRadius: 30,
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
