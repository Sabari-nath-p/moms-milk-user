import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:mommilk_user/Screens/TimeLineScreen/Service/TimelineController.dart';
import 'package:mommilk_user/theme/app_theme.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';


class ActivityTimeLineBody extends StatelessWidget {
  ActivityTimeLineBody({super.key});
  final Timelinecontroller tcltr = Get.find();
 final Homecontroller homeCtrl = Get.find();


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Picker
        DatePicker(
          DateTime.now().subtract(Duration(days: 45)),
          controller: tcltr.dateController,
          height: 100,
          daysCount: 90,
          initialSelectedDate: DateTime.now(),
          selectionColor: AppTheme.primaryColor,
          selectedTextColor: Colors.white,
          dateTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            height: 1.2, // line height fixed
          ),
          dayTextStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            height: 1.2,
          ),
          monthTextStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            height: 1.2,
          ),
          onDateChange: (date) {
            tcltr.fetchTimeLogs(date);
          },
        ),
      
        
        // Statistics Cards
        _buildStatisticsSection(),
        SizedBox(height: 15,),

        // Filter Chips
        _buildFilterChips(),

        // Timeline
        Expanded(
          child: GetBuilder<Timelinecontroller>(
            builder: (__) {
              return Obx(() {
                if (__.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }

                if (__.filteredTimeDataList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No activities for this day'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            height: 1.3, // fixed line height
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Timeline.tileBuilder(
                  theme: TimelineThemeData(
                    nodePosition: 0.2,
                    connectorTheme: ConnectorThemeData(
                      thickness: 3.0,
                      color: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  builder: TimelineTileBuilder.fromStyle(
                    contentsAlign: ContentsAlign.basic,
                    connectorStyle: ConnectorStyle.solidLine,
                    indicatorStyle: IndicatorStyle.dot,
                    indicatorPositionBuilder: (context, index) => 0.2,
                    oppositeContentsBuilder: (context, index) {
                      final item = __.filteredTimeDataList[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat("hh:mm").format(item.dateTime),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              DateFormat("a").format(item.dateTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    contentsBuilder: (context, index) {
                      final item = __.filteredTimeDataList[index];
                      return _buildTimelineCard(context, item, index);
                    },
                    itemCount: __.filteredTimeDataList.length,
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

 Widget _buildStatisticsSection() {
  return Obx(() {
   

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
   
          Row(
            children: [
             
              Expanded(
                child: _buildStatCard(
                  FontAwesomeIcons.personBreastfeeding,
                  '${tcltr.totalFeedings.value}',
                  'Feedings'.tr,
                  Colors.orange.shade400,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  Icons.baby_changing_station,
                  '${tcltr.totalDiaperChanges.value}',
                  'Diapers'.tr,
                  Colors.blue.shade400,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  Icons.bedtime,
                  tcltr.totalSleepDuration.value,
                  'Sleep'.tr,
                  Colors.purple.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  });
}

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.2,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
        final baby = homeCtrl.selectedBady;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       
            // 👶 Baby Name Title
          Padding(
            padding:  EdgeInsets.only(left: 20),
            child: Text(
             baby != null
                  ? "${baby.name} ${'Log'.tr}"
                  : "Baby Activity Summary".tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                
                _buildFilterChip(
                  'Feeding'.tr,
                  FontAwesomeIcons.personBreastfeeding,
                  Colors.orange.shade400,
                  tcltr.showFeeding.value,
                  () => tcltr.toggleFilter('feeding'),
                ),
                SizedBox(width: 8),
                _buildFilterChip(
                  'Diaper'.tr,
                  Icons.baby_changing_station,
                  Colors.blue.shade400,
                  tcltr.showDiaper.value,
                  () => tcltr.toggleFilter('diaper'),
                ),
                SizedBox(width: 8),
                _buildFilterChip(
                  'Sleep'.tr,
                  FontAwesomeIcons.moon,
                  Colors.purple.shade400,
                  tcltr.showSleep.value,
                  () => tcltr.toggleFilter('sleep'),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFilterChip(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: isSelected ? 2 : 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : color),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : color,
                    height: 1.2,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineCard(
    BuildContext context,
    TimeLineData item,
    int index,
  ) {
    return GestureDetector(
      // onTap: () => _showActivityDetails(context, item),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: item.color.withOpacity(0.2), width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.icon, size: 16, color: item.color),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.activity,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          height: 1.3, // fix overlap
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                if (item.descirpiton.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Text(
                    item.descirpiton,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      height: 1.4, // fix overlap
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showActivityDetails(BuildContext context, TimeLineData item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 28),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.activity,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat(
                              "MMMM dd, yyyy 'at' hh:mm a",
                            ).format(item.dateTime),
                            style: TextStyle(
                              color: Colors.white.withOpacity(.7),
                              fontSize: 14,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (item.descirpiton.isNotEmpty) ...[
                  SizedBox(height: 24),
                  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(.7),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    item.descirpiton,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(.7),
                      height: 1.4,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
                SizedBox(height: 24),
              ],
            ),
          ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Filter Activities'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => CheckboxListTile(
                    title: Text('Feeding'),
                    value: tcltr.showFeeding.value,
                    onChanged: (_) => tcltr.toggleFilter('feeding'),
                    activeColor: Colors.orange.shade400,
                  ),
                ),
                Obx(
                  () => CheckboxListTile(
                    title: Text('Diaper Changes'),
                    value: tcltr.showDiaper.value,
                    onChanged: (_) => tcltr.toggleFilter('diaper'),
                    activeColor: Colors.blue.shade400,
                  ),
                ),
                Obx(
                  () => CheckboxListTile(
                    title: Text('Sleep'),
                    value: tcltr.showSleep.value,
                    onChanged: (_) => tcltr.toggleFilter('sleep'),
                    activeColor: Colors.purple.shade400,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }
}
