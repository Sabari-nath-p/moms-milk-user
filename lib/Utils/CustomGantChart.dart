import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//-///////////////////////////////////////////////////////////////////////////
// 1. DATA MODELS
//-///////////////////////////////////////////////////////////////////////////

/// Represents a single activity or event to be displayed on the chart.
class ScheduleActivity {
  /// The unique identifier for the activity, used for finding the correct color.
  final String type;

  /// A brief description or title for the activity, displayed inside the block.
  final String description;

  /// The exact start time of the activity.
  final DateTime startTime;

  /// The exact end time of the activity.
  final DateTime endTime;

  /// Optional list of sub-categories for more granular filtering or styling.
  final List<String>? subcategories;

  /// Optional flexible JSON data for storing any extra information.
  final Map<String, dynamic>? jsonData;

  ScheduleActivity({
    required this.type,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.subcategories,
    this.jsonData,
  }) : assert(endTime.isAfter(startTime), 'endTime must be after startTime');
}

//-///////////////////////////////////////////////////////////////////////////
// 2. STYLING CLASS
//-///////////////////////////////////////////////////////////////////////////

/// Defines the visual appearance of the schedule chart.
class ScheduleChartStyle {
  /// A map associating an activity's `type` string with a specific color.
  final Map<String, Color> activityTypeColors;

  /// Color of the main background behind the grid.
  final Color backgroundColor;

  /// Color of the grid lines (both horizontal and vertical).
  final Color gridLineColor;

  /// Width of the grid lines.
  final double gridLineWidth;

  /// TextStyle for the date labels in the top header (X-axis).
  final TextStyle dateHeaderTextStyle;

  /// TextStyle for the time labels on the left side (Y-axis).
  final TextStyle timeAxisTextStyle;

  /// The width of a single day's column on the chart.
  final double dayColumnWidth;

  /// The height of a single hour's row on the chart.
  final double hourRowHeight;

  /// The width of the time axis column on the left.
  final double timeAxisWidth;

  /// The height of the date header row on the top.
  final double dateHeaderHeight;

  const ScheduleChartStyle({
    this.activityTypeColors = const {'default': Colors.blue},
    this.backgroundColor = Colors.white,
    this.gridLineColor = Colors.black12,
    this.gridLineWidth = 1.0,
    this.dateHeaderTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.black87,
    ),
    this.timeAxisTextStyle = const TextStyle(
      fontSize: 10,
      color: Colors.black54,
    ),
    this.dayColumnWidth = 120.0,
    this.hourRowHeight = 50.0,
    this.timeAxisWidth = 50.0,
    this.dateHeaderHeight = 40.0,
  });
}

//-///////////////////////////////////////////////////////////////////////////
// 3. CONTROLLER
//-///////////////////////////////////////////////////////////////////////////

/// Controls the programmatic behavior of the CustomScheduleChart.
class ScheduleChartController extends ChangeNotifier {
  final ScrollController _horizontalController = ScrollController();
  DateTime _startDate;
  final double _dayColumnWidth;

  ScheduleChartController({
    required DateTime startDate,
    required double dayColumnWidth,
  }) : _startDate = startDate,
       _dayColumnWidth = dayColumnWidth;

  /// Jumps the view to the specified date.
  void jumpToDate(DateTime date) {
    if (date.isBefore(_startDate)) return;
    final offset = date.difference(_startDate).inDays * _dayColumnWidth;
    _horizontalController.jumpTo(offset);
  }

  /// Animates the view to the specified date.
  void animateToDate(
    DateTime date, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.ease,
  }) {
    if (date.isBefore(_startDate)) return;
    final offset = date.difference(_startDate).inDays * _dayColumnWidth;
    _horizontalController.animateTo(offset, duration: duration, curve: curve);
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }
}

//-///////////////////////////////////////////////////////////////////////////
// 4. MAIN WIDGET
//-///////////////////////////////////////////////////////////////////////////

class CustomScheduleChart extends StatefulWidget {
  /// The list of activities to display on the chart.
  final List<ScheduleActivity> activities;

  /// The starting date for the X-axis.
  final DateTime startDate;

  /// The ending date for the X-axis.
  final DateTime endDate;

  /// The controller for programmatic control.
  final ScheduleChartController? controller;

  /// Custom styling for the chart.
  final ScheduleChartStyle style;

  /// Callback fired when the user scrolls to the far right end of the date range.
  final VoidCallback? onEndReachedRight;

  /// Callback fired when the user scrolls to the far left end of the date range.
  final VoidCallback? onEndReachedLeft;

  const CustomScheduleChart({
    Key? key,
    required this.activities,
    required this.startDate,
    required this.endDate,
    this.controller,
    this.style = const ScheduleChartStyle(),
    this.onEndReachedRight,
    this.onEndReachedLeft,
  }); //: assert(endDate.isAfter(startDate), 'endDate must be after startDate'),
  //   super(key: key);

  @override
  State<CustomScheduleChart> createState() => _CustomScheduleChartState();
}

class _CustomScheduleChartState extends State<CustomScheduleChart> {
  late final ScheduleChartController _controller;
  late final ScrollController _horizontalController;
  final ScrollController _verticalController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        ScheduleChartController(
          startDate: widget.startDate,
          dayColumnWidth: widget.style.dayColumnWidth,
        );
    _horizontalController = _controller._horizontalController;

    _horizontalController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_horizontalController.position.pixels ==
        _horizontalController.position.maxScrollExtent) {
      widget.onEndReachedRight?.call();
    }
    if (_horizontalController.position.pixels ==
        _horizontalController.position.minScrollExtent) {
      widget.onEndReachedLeft?.call();
    }
  }

  @override
  void dispose() {
    _horizontalController.removeListener(_scrollListener);
    // Dispose the controller only if it was created internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.style.backgroundColor,
      child: Column(children: [_buildHeader(), Expanded(child: _buildBody())]),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: widget.style.dateHeaderHeight,
      child: Row(
        children: [
          SizedBox(width: widget.style.timeAxisWidth), // Spacer
          Expanded(
            child: ListView.builder(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              physics:
                  const ClampingScrollPhysics(), // Match body scroll physics
              itemCount: _dayCount,
              itemBuilder: (context, index) {
                final date = widget.startDate.add(Duration(days: index));
                return SizedBox(
                  width: widget.style.dayColumnWidth,
                  child: Center(
                    child: Text(
                      DateFormat('EEE, MMM d').format(date),
                      style: widget.style.dateHeaderTextStyle,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      controller: _verticalController,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimeAxis(style: widget.style),
          Expanded(
            child: SizedBox(
              height: 24 * widget.style.hourRowHeight,
              child: SingleChildScrollView(
                // This controller is intentionally not linked to the header.
                // It is controlled via the header's scroll notifications.
                controller: _horizontalController,
                scrollDirection: Axis.horizontal,
                child: CustomPaint(
                  size: Size(
                    _dayCount * widget.style.dayColumnWidth,
                    24 * widget.style.hourRowHeight,
                  ),
                  painter: _GridPainter(
                    activities: widget.activities,
                    startDate: widget.startDate,
                    style: widget.style,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get _dayCount => widget.endDate.difference(widget.startDate).inDays + 1;
}

//-///////////////////////////////////////////////////////////////////////////
// 5. HELPER WIDGETS & PAINTER
//-///////////////////////////////////////////////////////////////////////////

class _TimeAxis extends StatelessWidget {
  final ScheduleChartStyle style;
  const _TimeAxis({required this.style});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: style.timeAxisWidth,
      height: 24 * style.hourRowHeight,
      child: Column(
        children: List.generate(24, (index) {
          return SizedBox(
            height: style.hourRowHeight,
            child: Center(
              child: Text(
                DateFormat('ha').format(DateTime(2022, 1, 1, index)),
                style: style.timeAxisTextStyle,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final List<ScheduleActivity> activities;
  final DateTime startDate;
  final ScheduleChartStyle style;

  _GridPainter({
    required this.activities,
    required this.startDate,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint =
        Paint()
          ..color = style.gridLineColor
          ..strokeWidth = style.gridLineWidth;

    // Draw horizontal grid lines (for hours)
    for (int i = 0; i <= 24; i++) {
      final y = i * style.hourRowHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw vertical grid lines (for days)
    final dayCount = (size.width / style.dayColumnWidth).round();
    for (int i = 0; i <= dayCount; i++) {
      final x = i * style.dayColumnWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw activities
    for (final activity in activities) {
      _drawActivity(canvas, size, activity);
    }
  }

  void _drawActivity(Canvas canvas, Size size, ScheduleActivity activity) {
    final daysFromStart = activity.startTime.difference(startDate).inDays;
    if (daysFromStart < 0) return; // Skip activities before the start date

    final x = daysFromStart * style.dayColumnWidth;
    final y =
        (activity.startTime.hour * 60 + activity.startTime.minute) /
        60 *
        style.hourRowHeight;

    final durationInMinutes =
        activity.endTime.difference(activity.startTime).inMinutes;
    final height = durationInMinutes / 60 * style.hourRowHeight;

    final rect = Rect.fromLTWH(x, y, style.dayColumnWidth, height);

    final activityPaint =
        Paint()
          ..color =
              style.activityTypeColors[activity.type] ??
              style.activityTypeColors['default']!;

    canvas.drawRect(rect.deflate(2.0), activityPaint); // Deflate for padding

    // Draw text inside the activity block
    final textSpan = TextSpan(
      text: activity.description,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      //  textDirection: TextDirection.LTR,
      maxLines: 2,
      ellipsis: '...',
    );
    textPainter.layout(minWidth: 0, maxWidth: rect.width - 8); // -8 for padding
    textPainter.paint(canvas, rect.topLeft + const Offset(4, 4));
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.activities != activities || oldDelegate.style != style;
  }
}
