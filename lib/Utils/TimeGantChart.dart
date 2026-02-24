import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'dart:math' as math;

/// Controller to programmatically control the TimeGanttChart.
class TimeGanttChartController {
  _TimeGanttChartState? _state;

  /// Attaches the controller to the Gantt chart's state.
  /// This is done internally by the widget.
  void _attach(_TimeGanttChartState state) {
    _state = state;
  }

  /// Detaches the controller.
  /// This is done internally by the widget.
  void _detach() {
    _state = null;
  }

  /// Scrolls the Gantt chart to the specified date.
  /// If [duration] is provided, it will animate the scroll.
  /// Otherwise, it will jump directly to the date.
  void scrollToDate(DateTime date, {Duration? duration, Curve? curve}) {
    _state?._scrollToDate(date, duration: duration, curve: curve);
  }

  /// A convenience method to scroll to the current date and time.
  void scrollToCurrentTime({Duration? duration, Curve? curve}) {
    _state?._scrollToDate(DateTime.now(), duration: duration, curve: curve);
  }

  /// Requests a change to the visible date range of the Gantt chart.
  /// This invokes the onDateRangeChanged callback and updates the internal state.
  void updateDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    if (_state == null) return;

    // Call the callback first (if provided)
    _state!.widget.onDateRangeChanged?.call(startDate, endDate);

    // Update internal state directly
    _state!._updateDateRangeInternal(startDate, endDate);
  }
}

/// Model class for Gantt chart activities
class GanttActivity {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String type;
  final String? description;
  final List<String>? subCategories;
  final Map<String, dynamic>? metadata;
  final Color? color;
  final Color? textColor;

  GanttActivity({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.description,
    this.subCategories,
    this.metadata,
    this.color,
    this.textColor,
  }) : assert(
         startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime),
         'Start time must be before or same as end time',
       );

  Duration get duration => endTime.difference(startTime);
}

/// Configuration class for styling the Gantt chart
class GanttChartStyle {
  final Color backgroundColor;
  final Color chartBackgroundColor;
  final Color gridColor;
  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color timeAxisBackgroundColor;
  final Color timeAxisTextColor;
  final Color dateTextColor;
  final Color currentTimeIndicatorColor;
  final TextStyle? headerTextStyle;
  final TextStyle? timeAxisTextStyle;
  final TextStyle? activityTextStyle;
  final TextStyle? dateTextStyle;
  final double cellHeight;
  final double headerHeight;
  final double timeAxisWidth;
  final double columnWidth;
  final EdgeInsets activityPadding;
  final BorderRadius? activityBorderRadius;
  final double activityBorderWidth;
  final Color activityBorderColor;
  final double gridLineWidth;
  final bool showCurrentTimeIndicator;

  GanttChartStyle({
    this.backgroundColor =const Color(0xFF1E293B),
    this.chartBackgroundColor =const Color(0xFF1E293B),
    this.gridColor =const Color(0xFF334155),
    this.headerBackgroundColor =const Color(0xFF1E293B),
    this.headerTextColor =const Color(0xFF94A3B8),
    this.timeAxisBackgroundColor =const Color(0xFF1E293B),
    this.timeAxisTextColor =const Color(0xFF94A3B8),
    this.dateTextColor =const Color(0xFF94A3B8),
    this.currentTimeIndicatorColor = Colors.red,
    this.headerTextStyle,
    this.timeAxisTextStyle,
    this.activityTextStyle,
    this.dateTextStyle,
    this.cellHeight = 40.0,
    this.headerHeight = 70.0,
    this.timeAxisWidth = 60.0,
    this.columnWidth = 80.0,
    this.activityPadding =const EdgeInsets.symmetric(
      horizontal: 2.0,
      vertical: 4.0,
    ),
    this.activityBorderRadius,
    this.activityBorderWidth = 0.0,
    this.activityBorderColor = Colors.transparent,
    this.gridLineWidth = 1.0,
    this.showCurrentTimeIndicator = true,
  });

  GanttChartStyle copyWith({
    Color? backgroundColor,
    Color? chartBackgroundColor,
    Color? gridColor,
    Color? headerBackgroundColor,
    Color? headerTextColor,
    Color? timeAxisBackgroundColor,
    Color? timeAxisTextColor,
    Color? dateTextColor,
    Color? currentTimeIndicatorColor,
    TextStyle? headerTextStyle,
    TextStyle? timeAxisTextStyle,
    TextStyle? activityTextStyle,
    TextStyle? dateTextStyle,
    double? cellHeight,
    double? headerHeight,
    double? timeAxisWidth,
    double? columnWidth,
    EdgeInsets? activityPadding,
    BorderRadius? activityBorderRadius,
    double? activityBorderWidth,
    Color? activityBorderColor,
    double? gridLineWidth,
    bool? showCurrentTimeIndicator,
  }) {
    return GanttChartStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      chartBackgroundColor: chartBackgroundColor ?? this.chartBackgroundColor,
      gridColor: gridColor ?? this.gridColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      timeAxisBackgroundColor:
          timeAxisBackgroundColor ?? this.timeAxisBackgroundColor,
      timeAxisTextColor: timeAxisTextColor ?? this.timeAxisTextColor,
      dateTextColor: dateTextColor ?? this.dateTextColor,
      currentTimeIndicatorColor:
          currentTimeIndicatorColor ?? this.currentTimeIndicatorColor,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      timeAxisTextStyle: timeAxisTextStyle ?? this.timeAxisTextStyle,
      activityTextStyle: activityTextStyle ?? this.activityTextStyle,
      dateTextStyle: dateTextStyle ?? this.dateTextStyle,
      cellHeight: cellHeight ?? this.cellHeight,
      headerHeight: headerHeight ?? this.headerHeight,
      timeAxisWidth: timeAxisWidth ?? this.timeAxisWidth,
      columnWidth: columnWidth ?? this.columnWidth,
      activityPadding: activityPadding ?? this.activityPadding,
      activityBorderRadius: activityBorderRadius ?? this.activityBorderRadius,
      activityBorderWidth: activityBorderWidth ?? this.activityBorderWidth,
      activityBorderColor: activityBorderColor ?? this.activityBorderColor,
      gridLineWidth: gridLineWidth ?? this.gridLineWidth,
      showCurrentTimeIndicator:
          showCurrentTimeIndicator ?? this.showCurrentTimeIndicator,
    );
  }

  factory GanttChartStyle.fromTheme(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return GanttChartStyle(
      backgroundColor:
          isDark ? Color(0xFF1E293B) : theme.scaffoldBackgroundColor,
      chartBackgroundColor: isDark ? Color(0xFF1E293B) : theme.cardColor,
      gridColor: isDark ? Color(0xFF334155) : theme.dividerColor,
      headerBackgroundColor:
          isDark ? Color(0xFF1E293B) : theme.primaryColor,
      headerTextColor:
          isDark
              ? Color(0xFF94A3B8)
              : theme.primaryTextTheme.titleLarge?.color ?? Colors.white,
      timeAxisBackgroundColor:
          isDark ? Color(0xFF1E293B) : theme.cardColor,
      timeAxisTextColor:
          isDark
              ? Color(0xFF94A3B8)
              : theme.textTheme.bodyMedium?.color ?? Colors.black87,
      dateTextColor:
          isDark
              ? Color(0xFF94A3B8)
              : theme.textTheme.bodyMedium?.color ?? Colors.black87,
    );
  }
}

/// Main Gantt Chart Widget
class TimeGanttChart extends StatefulWidget {
  final List<GanttActivity> activities;
  final DateTime startDate;
  final DateTime endDate;
  final GanttChartStyle? style;
  final TimeGanttChartController? controller;

  /// Defines the time interval for the labels on the Y-axis.
  /// Defaults to 2 hours.
  final Duration yAxisTimeIncrement;

  /// Callback invoked when the controller requests a date range update.
  final Function(DateTime startDate, DateTime endDate)? onDateRangeChanged;
  final VoidCallback? onReachStart;
  final VoidCallback? onReachEnd;
  final Function(GanttActivity)? onActivityTap;
  final bool showGrid;
  final bool enableZoom;
  final bool enableScroll;
  final bool showZoomControls;

  TimeGanttChart({
    Key? key,
    required this.activities,
    required this.startDate,
    required this.endDate,
    this.style,
    this.controller,
    this.yAxisTimeIncrement =const Duration(hours: 2),
    this.onDateRangeChanged,
    this.onReachStart,
    this.onReachEnd,
    this.onActivityTap,
    this.showGrid = true,
    this.enableZoom = true,
    this.enableScroll = true,
    this.showZoomControls = false,
  }) : super(key: key);

  @override
  State<TimeGanttChart> createState() => _TimeGanttChartState();
}

class _TimeGanttChartState extends State<TimeGanttChart> {
  late LinkedScrollControllerGroup _horizontalControllers;
  late LinkedScrollControllerGroup _verticalControllers;
  late ScrollController _headerScrollController;
  late ScrollController _contentScrollController;
  late ScrollController _timeAxisScrollController;
  late ScrollController _chartVerticalScrollController;
  late GanttChartStyle _style;
  late List<DateTime> _dates;
  // Internal state for date range (can be overridden by controller)
  late DateTime _internalStartDate;
  late DateTime _internalEndDate;
  double _zoomLevel = 1.0;
  static double _minZoom = 0.5;
  static double _maxZoom = 3.0;

  @override
  void initState() {
    super.initState();
    _horizontalControllers = LinkedScrollControllerGroup();
    _verticalControllers = LinkedScrollControllerGroup();
    _headerScrollController = _horizontalControllers.addAndGet();
    _contentScrollController = _horizontalControllers.addAndGet();
    _timeAxisScrollController = _verticalControllers.addAndGet();
    _chartVerticalScrollController = _verticalControllers.addAndGet();

    _internalStartDate = widget.startDate;
    _internalEndDate = widget.endDate;
    widget.controller?._attach(this);
    _dates = _generateDateRange();

    _contentScrollController.addListener(_checkScrollPosition);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateStyle();
  }

  @override
  void didUpdateWidget(TimeGanttChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style) {
      _updateStyle();
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
    // If parent changes the date range, update internal state and regenerate dates
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      setState(() {
        _internalStartDate = widget.startDate;
        _internalEndDate = widget.endDate;
        _dates = _generateDateRange();
      });
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _contentScrollController.removeListener(_checkScrollPosition);
    _headerScrollController.dispose();
    _contentScrollController.dispose();
    _timeAxisScrollController.dispose();
    _chartVerticalScrollController.dispose();
    super.dispose();
  }

  void _updateStyle() {
    setState(() {
      _style = widget.style ?? GanttChartStyle.fromTheme(Theme.of(context));
    });
  }

  /// Internal method called by controller to update date range
  void _updateDateRangeInternal(DateTime startDate, DateTime endDate) {
    if (mounted) {
      setState(() {
        _internalStartDate = startDate;
        _internalEndDate = endDate;
        _dates = _generateDateRange();
      });
    }
  }

  void _checkScrollPosition() {
    if (!_contentScrollController.hasClients) return;
    if (_contentScrollController.position.pixels <=
        _contentScrollController.position.minScrollExtent) {
      widget.onReachStart?.call();
    } else if (_contentScrollController.position.pixels >=
        _contentScrollController.position.maxScrollExtent) {
      widget.onReachEnd?.call();
    }
  }

  void _handleZoom(double delta) {
    if (!widget.enableZoom) return;

    final scrollOffset = _contentScrollController.offset;
    final totalWidth = _dates.length * _style.columnWidth * _zoomLevel;
    final scrollProportion = totalWidth > 0 ? scrollOffset / totalWidth : 0.0;

    setState(() {
      _zoomLevel = (_zoomLevel + delta).clamp(_minZoom, _maxZoom);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newTotalWidth = _dates.length * _style.columnWidth * _zoomLevel;
      final newScrollOffset = scrollProportion * newTotalWidth;
      _contentScrollController.jumpTo(newScrollOffset);
    });
  }

  void _scrollToDate(DateTime date, {Duration? duration, Curve? curve}) {
    final targetDate = DateTime(date.year, date.month, date.day);
    final int dateIndex = _dates.indexWhere(
      (d) => d.isAtSameMomentAs(targetDate),
    );

    if (dateIndex != -1 && _contentScrollController.hasClients) {
      final double offset = dateIndex * _style.columnWidth * _zoomLevel;
      final double clampedOffset = offset.clamp(
        0.0,
        _contentScrollController.position.maxScrollExtent,
      );

      if (duration != null) {
        _contentScrollController.animateTo(
          clampedOffset,
          duration: duration,
          curve: curve ?? Curves.easeInOut,
        );
      } else {
        _contentScrollController.jumpTo(clampedOffset);
      }
    }
  }

  List<DateTime> _generateDateRange() {
    List<DateTime> dates = [];
    if (_internalStartDate.isAfter(_internalEndDate)) return dates;

    DateTime current = DateTime(
      _internalStartDate.year,
      _internalStartDate.month,
      _internalStartDate.day,
    );

    final end = DateTime(
      _internalEndDate.year,
      _internalEndDate.month,
      _internalEndDate.day,
    );

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      dates.add(current);
      current = current.add(Duration(days: 1));
    }
    return dates;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;

    String period = 'am';
    int displayHour = hour;

    if (hour == 0) {
      displayHour = 12;
    } else if (hour == 12) {
      period = 'pm';
    } else if (hour > 12) {
      displayHour = hour - 12;
      period = 'pm';
    }

    final minuteStr = minute.toString().padLeft(2, '0');

    if (minute == 0) {
      return '$displayHour $period';
    }
    return '$displayHour:$minuteStr $period';
  }

  List<String> _generateTimeSlots() {
    List<String> slots = [];
    final increment = widget.yAxisTimeIncrement;
    if (increment.inSeconds <= 0) {
      slots.add(_formatTime(DateTime(2025, 1, 1, 0, 0)));
      return slots;
    }

    DateTime time = DateTime(2025, 1, 1, 0, 0);
    final endOfDay = time.add(Duration(days: 1));

    while (time.isBefore(endOfDay)) {
      slots.add(_formatTime(time));
      time = time.add(increment);
    }
    return slots;
  }

  Color _getActivityColor(GanttActivity activity) {
    if (activity.color != null) return activity.color!;
    final hash = activity.type.hashCode;
    return Color((hash & 0xFFFFFF) | 0xFF000000).withOpacity(1.0);
  }

  String _getWeekdayName(int weekday) {
   const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return  days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = _generateTimeSlots();
    final totalWidth = _dates.length * _style.columnWidth * _zoomLevel;
    final totalHeight = timeSlots.length * _style.cellHeight;

    return Container(
      color: _style.backgroundColor,
      child: Column(
        children: [
          _buildHeader(_dates, totalWidth),
          Expanded(
            child: Row(
              children: [
                _buildTimeAxis(timeSlots),
                Expanded(
                  child: _buildChartArea(
                    _dates,
                    timeSlots,
                    totalWidth,
                    totalHeight,
                  ),
                ),
              ],
            ),
          ),
          if (widget.enableZoom && widget.showZoomControls)
            _buildZoomControls(),
        ],
      ),
    );
  }

  Widget _buildHeader(List<DateTime> dates, double totalWidth) {
    final headerStyle =
        _style.headerTextStyle ??
        TextStyle(
          color: _style.headerTextColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        );

    final dateStyle =
        _style.dateTextStyle ??
        TextStyle(color: _style.dateTextColor, fontSize: 12);

    return Container(
      height: _style.headerHeight,
      decoration: BoxDecoration(
        color: _style.headerBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: _style.gridColor,
            width: _style.gridLineWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: _style.timeAxisWidth,
            decoration: BoxDecoration(
              color: _style.headerBackgroundColor,
              border: Border(
                right: BorderSide(
                  color: _style.gridColor,
                  width: _style.gridLineWidth,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getMonthName(_internalStartDate.month),
                  style: headerStyle,
                ),
                Text(_internalStartDate.year.toString(), style: dateStyle),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _headerScrollController,
              scrollDirection: Axis.horizontal,
              physics:
                  widget.enableScroll
                      ? ClampingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: totalWidth,
                child: Row(
                  children:
                      dates.map((date) {
                        return Container(
                          width: _style.columnWidth * _zoomLevel,
                          decoration: BoxDecoration(
                            color: _style.headerBackgroundColor,
                            border: Border(
                              right: BorderSide(
                                color: _style.gridColor,
                                width: _style.gridLineWidth,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getWeekdayName(date.weekday),
                                style: headerStyle,
                              ),
                              SizedBox(height: 4),
                              Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: _style.dateTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAxis(List<String> timeSlots) {
    final timeStyle =
        _style.timeAxisTextStyle ??
        TextStyle(
          color: _style.timeAxisTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );

    return Container(
      width: _style.timeAxisWidth,
      decoration: BoxDecoration(
        color: _style.timeAxisBackgroundColor,
        border: Border(
          right: BorderSide(
            color: _style.gridColor,
            width: _style.gridLineWidth,
          ),
        ),
      ),
      child: SingleChildScrollView(
        controller: _timeAxisScrollController,
        physics:
            widget.enableScroll
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
        child: Column(
          children:
              timeSlots.map((slot) {
                return Container(
                  height: _style.cellHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _style.timeAxisBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: _style.gridColor,
                        width: _style.gridLineWidth,
                      ),
                    ),
                  ),
                  child: Text(slot, style: timeStyle),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildChartArea(
    List<DateTime> dates,
    List<String> timeSlots,
    double totalWidth,
    double totalHeight,
  ) {
    return GestureDetector(
      onScaleUpdate:
          widget.enableZoom
              ? (details) => _handleZoom((details.scale - 1.0) * 0.1)
              : null,
      child: Container(
        color: _style.chartBackgroundColor,
        child: SingleChildScrollView(
          controller: _contentScrollController,
          scrollDirection: Axis.horizontal,
          physics:
              widget.enableScroll
                  ? ClampingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
          child: SingleChildScrollView(
            controller: _chartVerticalScrollController,
            physics:
                widget.enableScroll
                    ? ClampingScrollPhysics()
                    : NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: totalWidth,
              height: totalHeight,
              child: Stack(
                children: [
                  if (widget.showGrid)
                    _buildGrid(dates, timeSlots, totalWidth, totalHeight),
                  ..._buildActivities(dates, totalHeight),
                  if (_style.showCurrentTimeIndicator)
                    _buildCurrentTimeIndicator(dates, totalHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(
    List<DateTime> dates,
    List<String> timeSlots,
    double totalWidth,
    double totalHeight,
  ) {
    return CustomPaint(
      size: Size(totalWidth, totalHeight),
      painter: GridPainter(
        columnCount: dates.length,
        rowCount: timeSlots.length,
        columnWidth: _style.columnWidth * _zoomLevel,
        rowHeight: _style.cellHeight,
        gridColor: _style.gridColor,
        gridLineWidth: _style.gridLineWidth,
        backgroundColor: _style.chartBackgroundColor,
      ),
    );
  }

  List<Widget> _buildActivities(List<DateTime> dates, double totalHeight) {
    List<Widget> widgets = [];
    double totalMinutesInDay = 24 * 60.0;

    for (var activity in widget.activities) {
      final activityStartDate = DateTime(
        activity.startTime.year,
        activity.startTime.month,
        activity.startTime.day,
      );

      final columnIndex = dates.indexWhere(
        (date) => date.isAtSameMomentAs(activityStartDate),
      );

      if (columnIndex == -1) continue;

      final startMinutes =
          activity.startTime.hour * 60.0 + activity.startTime.minute;
      final activityDurationInMinutes = activity.duration.inMinutes.toDouble();

      final top = (startMinutes / totalMinutesInDay) * totalHeight;
      final height =
          (activityDurationInMinutes / totalMinutesInDay) * totalHeight;

      final left = columnIndex * _style.columnWidth * _zoomLevel;

      widgets.add(
        Positioned(
          left: left + _style.activityPadding.left,
          top: top + _style.activityPadding.top,
          child: Tooltip(
            message: activity.description ?? activity.type,
            triggerMode: TooltipTriggerMode.tap,
            //   onTap: () => widget.onActivityTap?.call(activity),
            child: Container(
              width:
                  _style.columnWidth * _zoomLevel -
                  _style.activityPadding.horizontal,
              height: math.max(0, height - _style.activityPadding.vertical),
              decoration: BoxDecoration(
                color: _getActivityColor(activity),
                borderRadius:
                    _style.activityBorderRadius ?? BorderRadius.circular(3),
                border:
                    _style.activityBorderWidth > 0
                        ? Border.all(
                          color: _style.activityBorderColor,
                          width: _style.activityBorderWidth,
                        )
                        : null,
              ),
              child: Center(
                child: Text(
                  "", //   activity.type,
                  style:
                      _style.activityTextStyle ??
                      TextStyle(
                        color: activity.textColor ?? Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildCurrentTimeIndicator(List<DateTime> dates, double totalHeight) {
    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);

    final columnIndex = dates.indexWhere(
      (date) => date.isAtSameMomentAs(currentDate),
    );

    if (columnIndex == -1) return SizedBox.shrink();

    double totalMinutesInDay = 24 * 60.0;
    final nowMinutes = now.hour * 60.0 + now.minute;

    final y = (nowMinutes / totalMinutesInDay) * totalHeight;
    final x = (columnIndex * _style.columnWidth * _zoomLevel);

    return Positioned(
      left: x,
      top: y,
      child: Row(
        children: [
          Container(
            transform: Matrix4.translationValues(-4, -3, 0),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _style.currentTimeIndicatorColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width:
                (dates.length - columnIndex) * _style.columnWidth * _zoomLevel,
            height: 2,
            color: _style.currentTimeIndicatorColor,
          ),
        ],
      ),
    );
  }

  Widget _buildZoomControls() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: _style.backgroundColor,
        border: Border(
          top: BorderSide(color: _style.gridColor, width: _style.gridLineWidth),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: _style.headerTextColor),
            onPressed: _zoomLevel > _minZoom ? () => _handleZoom(-0.1) : null,
            tooltip: 'Zoom Out',
            style: IconButton.styleFrom(
              foregroundColor: _style.headerTextColor,
            ),
          ),
          SizedBox(width: 16),
          Text(
            '${(_zoomLevel * 100).toInt()}%',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: _style.headerTextColor,
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.add, color: _style.headerTextColor),
            onPressed: _zoomLevel < _maxZoom ? () => _handleZoom(0.1) : null,
            tooltip: 'Zoom In',
            style: IconButton.styleFrom(
              foregroundColor: _style.headerTextColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
  const  months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

/// Custom painter for the grid
class GridPainter extends CustomPainter {
  final int columnCount;
  final int rowCount;
  final double columnWidth;
  final double rowHeight;
  final Color gridColor;
  final double gridLineWidth;
  final Color backgroundColor;

  GridPainter({
    required this.columnCount,
    required this.rowCount,
    required this.columnWidth,
    required this.rowHeight,
    required this.gridColor,
    required this.gridLineWidth,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final paint =
        Paint()
          ..color = gridColor
          ..strokeWidth = gridLineWidth;

    for (int i = 0; i <= columnCount; i++) {
      final x = i * columnWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 0; i <= rowCount; i++) {
      final y = i * rowHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.columnCount != columnCount ||
        oldDelegate.rowCount != rowCount ||
        oldDelegate.columnWidth != columnWidth ||
        oldDelegate.rowHeight != rowHeight ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.gridLineWidth != gridLineWidth ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
