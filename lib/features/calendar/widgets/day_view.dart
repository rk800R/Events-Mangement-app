import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../models/calendar_event.dart';
import '../../../providers/event_provider.dart';

class DayView extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDayChanged;

  const DayView({super.key, required this.date, required this.onDayChanged});

  static const double _hourHeight = 64;

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final isToday = DateUtilsX.isSameDay(widget.date, now);
    _scrollController = ScrollController(
      initialScrollOffset: isToday
          ? ((now.hour * 60 + now.minute) / 60 * DayView._hourHeight - 200)
              .clamp(0.0, double.infinity)
          : 7 * DayView._hourHeight, // Default: scroll to 7 AM for non-today
    );
  }

  @override
  void didUpdateWidget(DayView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!DateUtilsX.isSameDay(widget.date, oldWidget.date)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        final now = DateTime.now();
        if (widget.date.isToday) {
          final offset =
              (now.hour * 60 + now.minute) / 60 * DayView._hourHeight - 200;
          _scrollController.animateTo(
            offset.clamp(0.0, double.infinity),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final events = context.select<EventProvider, List<CalendarEvent>>(
      (p) => p.eventsForDay(widget.date),
    );
    final isToday = widget.date.isToday;

    return Column(
      children: [
        // ─── Day header ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isToday
                    ? AppColors.primary
                    : theme.colorScheme.surfaceContainerHighest,
                child: Text(
                  '${widget.date.day}',
                  style: TextStyle(
                    color: isToday
                        ? Colors.white
                        : theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.EEEE().format(widget.date),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMMd().format(widget.date),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              if (isToday)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // ─── Hour grid ────────────────────────────────────────────
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const double eventsLeftPadding = 64;
              const double eventsRightPadding = 8;
              const double columnGap = 2.0;
              final double availableWidth =
                  constraints.maxWidth - eventsLeftPadding - eventsRightPadding;

              final layouts = _computeLayout(events, availableWidth, columnGap);

              return SingleChildScrollView(
                controller: _scrollController,
                child: SizedBox(
                  height: DayView._hourHeight * 24,
                  child: Stack(
                    children: [
                      // Hour lines
                      Column(
                        children: List.generate(24, (hour) {
                          return SizedBox(
                            height: DayView._hourHeight,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 4, right: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        DateFormat('ha')
                                            .format(DateTime(2024, 1, 1, hour))
                                            .toLowerCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: theme
                                              .textTheme.bodySmall?.color
                                              ?.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: theme.dividerColor
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      // Events
                      ...layouts.map((l) => _EventBlock(
                            event: l.event,
                            day: widget.date,
                            left: eventsLeftPadding + l.left,
                            right: eventsRightPadding + l.right,
                          )),
                      // Now indicator
                      if (isToday) const _NowIndicator(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
//  Event Block
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

    final top = (startMinutes / 60) * DayView._hourHeight;
    final rawMinutes = (endMinutes - startMinutes).clamp(0, 24 * 60);
    final height = (rawMinutes / 60) * DayView._hourHeight;

    if (height <= 0) return const SizedBox.shrink();

    // Enforce a minimum visible height for very short events
    const minHeight = 24.0;
    final actualHeight = height < minHeight ? minHeight : height;

    return Positioned(
      top: top,
      left: left,
      right: right,
      height: actualHeight,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/event/${event.id}'),
        child: Material(
          color: event.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: event.color, width: 3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: actualHeight > 24 ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: event.color,
                  ),
                ),
                if (actualHeight > 40) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${DateFormat.Hm().format(event.startTime)} – ${DateFormat.Hm().format(event.endTime)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (actualHeight > 60 && event.location != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    event.location!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
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
    final top = (now.hour * 60 + now.minute) / 60 * DayView._hourHeight;
    return Positioned(
      top: top,
      left: 60,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
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
