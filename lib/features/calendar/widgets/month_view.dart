import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../models/calendar_event.dart';
import '../../../providers/event_provider.dart';
import '../../../providers/settings_provider.dart';

class MonthView extends StatelessWidget {
  final DateTime focusedDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  const MonthView({
    super.key,
    required this.focusedDate,
    required this.selectedDate,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final weekStart = settings.weekStart;
    final firstVisible =
        DateUtilsX.firstDayVisibleInMonth(focusedDate, weekStart);

    return Column(
      children: [
        _WeekdayHeader(weekStart: weekStart),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cellWidth = (constraints.maxWidth - 16) / 7;
              final aspectRatio =
                  (cellWidth / (constraints.maxHeight / 6)).clamp(0.0, 1.0);
              return ClipRect(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: 42,
                  itemBuilder: (context, index) {
                    final date = firstVisible.add(Duration(days: index));
                    return _DayCell(
                      date: date,
                      isCurrentMonth: date.month == focusedDate.month,
                      isSelected: DateUtilsX.isSameDay(date, selectedDate),
                      onDaySelected: onDaySelected,
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _SelectedDayEvents(date: selectedDate),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final int weekStart;
  const _WeekdayHeader({required this.weekStart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: List.generate(7, (i) {
          final day = (weekStart + i - 1) % 7 + 1; // 1..7 (Mon..Sun)
          return Expanded(
            child: Center(
              child: Text(
                DateUtilsX.weekdayName(day, short: true),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final ValueChanged<DateTime> onDaySelected;

  const _DayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final events = context.select<EventProvider, List<CalendarEvent>>(
      (p) => p.eventsForDay(date),
    );
    final isToday = date.isToday;

    return GestureDetector(
      onTap: () => onDaySelected(date),
      onLongPress: () => onDaySelected(date),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border:
              isToday ? Border.all(color: AppColors.primary, width: 1.5) : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            const SizedBox(height: 4),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isToday || isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : isCurrentMonth
                          ? theme.textTheme.bodyMedium?.color
                          : theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: 4),
            if (events.isNotEmpty)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 2,
                runSpacing: 2,
                children: events
                    .take(5)
                    .map((e) => Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: e.color,
                            shape: BoxShape.circle,
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectedDayEvents extends StatelessWidget {
  final DateTime date;
  const _SelectedDayEvents({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final events = context.select<EventProvider, List<CalendarEvent>>(
      (p) => p.eventsForDay(date),
    );

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                children: [
                  Text(
                    DateFormat.EEEE().format(date),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${events.length} ${events.length == 1 ? 'event' : 'events'}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: events.isEmpty
                  ? _EmptyDay(date: date)
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: events.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _EventTile(event: events[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  final DateTime date;
  const _EmptyDay({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available,
              size: 48,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text(
            'No events on ${DateFormat.MMMd().format(date)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final CalendarEvent event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14,
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.6)),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat.Hm().format(event.startTime)} – ${DateFormat.Hm().format(event.endTime)}',
                          style: theme.textTheme.bodySmall,
                        ),
                        if (event.location != null) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.place_outlined,
                              size: 14,
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
