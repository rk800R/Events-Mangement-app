import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../models/calendar_event.dart';
import '../../../providers/event_provider.dart';
import '../../../providers/settings_provider.dart';

class WeekView extends StatefulWidget {
  final DateTime focusedDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const WeekView({
    super.key,
    required this.focusedDate,
    required this.selectedDate,
    required this.onDaySelected,
  });

  static const double hourHeight = 56;
  static const double timeColumnWidth = 52;

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _scrollController = ScrollController(
      initialScrollOffset:
          (now.hour * 60 + now.minute) / 60 * WeekView.hourHeight - 200,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final weekStart =
        DateUtilsX.startOfWeek(widget.focusedDate, settings.weekStart);
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final now = DateTime.now();
    final todayInWeek = days.any((d) => DateUtilsX.isSameDay(d, now));

    return Column(
      children: [
        // ─── Fixed day headers (outside scroll) ───────────────────
        _DayHeadersRow(
          days: days,
          selectedDate: widget.selectedDate,
          onDaySelected: widget.onDaySelected,
        ),
        // ─── Scrollable time grid ─────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              height: WeekView.hourHeight * 24,
              child: Row(
                children: [
                  SizedBox(
                    width: WeekView.timeColumnWidth,
                    child: _TimeColumn(),
                  ),
                  ...days.map((d) => Expanded(
                        child: _DayColumn(
                          date: d,
                          onSelected: widget.onDaySelected,
                          showNowIndicator:
                              todayInWeek && DateUtilsX.isSameDay(d, now),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Day Headers Row (fixed, not scrollable)
// ════════════════════════════════════════════════════════════════
class _DayHeadersRow extends StatelessWidget {
  final List<DateTime> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const _DayHeadersRow({
    required this.days,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: WeekView.timeColumnWidth),
          ...days.map((d) {
            final isToday = d.isToday;
            final isSelected = DateUtilsX.isSameDay(d, selectedDate);
            return Expanded(
              child: GestureDetector(
                onTap: () => onDaySelected(d),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.E().format(d),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isToday
                              ? AppColors.primary
                              : theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isToday
                              ? AppColors.primary
                              : isSelected
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : Colors.transparent,
                          border: isSelected && !isToday
                              ? Border.all(color: AppColors.primary, width: 1.5)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${d.day}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isToday
                                ? Colors.white
                                : theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Time Column
// ════════════════════════════════════════════════════════════════
class _TimeColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: List.generate(24, (hour) {
        return SizedBox(
          height: WeekView.hourHeight,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 2, right: 6),
              child: Text(
                DateFormat('ha')
                    .format(DateTime(2024, 1, 1, hour))
                    .toLowerCase(),
                style: TextStyle(
                  fontSize: 10,
                  color:
                      theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Event Layout Logic (handles concurrent events)
// ════════════════════════════════════════════════════════════════
class _EventLayout {
  final CalendarEvent event;
  final double left;
  final double right;

  _EventLayout({
    required this.event,
    required this.left,
    required this.right,
  });
}

List<_EventLayout> _computeLayout(
    List<CalendarEvent> events, double availableWidth, double columnGap) {
  if (events.isEmpty || availableWidth <= 0) return [];

  final sorted = [...events]..sort((a, b) {
      final cmp = a.startTime.compareTo(b.startTime);
      if (cmp != 0) return cmp;
      return b.endTime.compareTo(a.endTime);
    });

  final clusters = <List<CalendarEvent>>[];
  List<CalendarEvent> currentCluster = [];
  DateTime clusterEnd = DateTime(0);

  for (final e in sorted) {
    if (currentCluster.isEmpty || e.startTime.isBefore(clusterEnd)) {
      currentCluster.add(e);
      if (e.endTime.isAfter(clusterEnd)) {
        clusterEnd = e.endTime;
      }
    } else {
      clusters.add(currentCluster);
      currentCluster = [e];
      clusterEnd = e.endTime;
    }
  }
  if (currentCluster.isNotEmpty) clusters.add(currentCluster);

  final layouts = <_EventLayout>[];

  for (final cluster in clusters) {
    final columns = <List<CalendarEvent>>[];
    final eventColumns = <CalendarEvent, int>{};

    for (final e in cluster) {
      bool placed = false;
      for (int i = 0; i < columns.length; i++) {
        final last = columns[i].last;
        if (!e.startTime.isBefore(last.endTime)) {
          columns[i].add(e);
          eventColumns[e] = i;
          placed = true;
          break;
        }
      }
      if (!placed) {
        columns.add([e]);
        eventColumns[e] = columns.length - 1;
      }
    }

    final numColumns = columns.length;
    final double columnWidth =
        (availableWidth - columnGap * (numColumns - 1)) / numColumns;

    for (final e in cluster) {
      final colIndex = eventColumns[e]!;
      final double left = colIndex * (columnWidth + columnGap);
      final double right = availableWidth - (left + columnWidth);
      layouts.add(_EventLayout(
        event: e,
        left: left,
        right: right,
      ));
    }
  }

  return layouts;
}

// ════════════════════════════════════════════════════════════════
//  Day Column (hour grid + events, NO header — header is fixed above)
// ════════════════════════════════════════════════════════════════
class _DayColumn extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onSelected;
  final bool showNowIndicator;

  const _DayColumn({
    required this.date,
    required this.onSelected,
    this.showNowIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final events = context.select<EventProvider, List<CalendarEvent>>(
      (p) => p.eventsForDay(date),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        const double columnGap = 2.0;
        final double availableWidth =
            constraints.maxWidth - 4; // 2px padding each side
        final layouts = _computeLayout(events, availableWidth, columnGap);

        return GestureDetector(
          onTap: () => onSelected(date),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // Hour grid lines
              Column(
                children: List.generate(24, (i) {
                  return Container(
                    height: WeekView.hourHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: theme.dividerColor.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                        right: BorderSide(
                          color: theme.dividerColor.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              // Events
              ...layouts.map((l) => _EventBlock(
                    event: l.event,
                    day: date,
                    left: l.left + 2,
                    right: l.right + 2,
                  )),
              // Now indicator
              if (showNowIndicator) const _NowIndicator(),
            ],
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Event Block (handles multi-day events correctly)
// ════════════════════════════════════════════════════════════════
class _EventBlock extends StatelessWidget {
  final CalendarEvent event;
  final DateTime day;
  final double left;
  final double right;

  const _EventBlock({
    required this.event,
    required this.day,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Clamp event boundaries to this day for multi-day events
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final effectiveStart =
        event.startTime.isBefore(dayStart) ? dayStart : event.startTime;
    final effectiveEnd = event.endTime.isAfter(dayEnd) ? dayEnd : event.endTime;

    final startMinutes = effectiveStart.hour * 60 + effectiveStart.minute;
    // If end falls on next day's midnight (== dayEnd), treat as 24:00
    final endMinutes = effectiveEnd.day == day.day
        ? effectiveEnd.hour * 60 + effectiveEnd.minute
        : 24 * 60;

    final top = (startMinutes / 60) * WeekView.hourHeight;
    final rawMinutes = (endMinutes - startMinutes).clamp(0, 24 * 60);
    final height = (rawMinutes / 60) * WeekView.hourHeight;

    if (height <= 0) return const SizedBox.shrink();

    // Enforce a minimum visible height for very short events
    const minHeight = 20.0;
    final actualHeight = height < minHeight ? minHeight : height;

    return Positioned(
      top: top,
      left: left,
      right: right,
      height: actualHeight,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/event/${event.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border(
              left: BorderSide(color: event.color, width: 2.5),
            ),
          ),
          child: Text(
            event.title,
            maxLines: actualHeight > 20 ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Now Indicator
// ════════════════════════════════════════════════════════════════
class _NowIndicator extends StatelessWidget {
  const _NowIndicator();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final top = (now.hour * 60 + now.minute) / 60 * WeekView.hourHeight;
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              height: 1.5,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
