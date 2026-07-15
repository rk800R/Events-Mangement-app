import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../models/calendar_event.dart';
import '../../../providers/event_provider.dart';

class AgendaView extends StatelessWidget {
  final DateTime startDate;
  final ValueChanged<CalendarEvent> onEventTap;

  const AgendaView({
    super.key,
    required this.startDate,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    final allEvents = provider.events;

    // Group events by day, starting from startDate
    final grouped = <DateTime, List<CalendarEvent>>{};
    final start = DateTime(startDate.year, startDate.month, startDate.day);

    // Always include today so the user sees where "today" is
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    grouped.putIfAbsent(today, () => []);

    // Include startDate if different from today
    if (!DateUtilsX.isSameDay(start, today)) {
      grouped.putIfAbsent(start, () => []);
    }

    for (final e in allEvents) {
      var day = DateTime(e.startTime.year, e.startTime.month, e.startTime.day);
      while (!day.isAfter(e.endTime)) {
        if (!day.isBefore(start)) {
          grouped.putIfAbsent(day, () => []).add(e);
        }
        day = day.add(const Duration(days: 1));
      }
    }
    final sortedDays = grouped.keys.toList()..sort();

    if (sortedDays.isEmpty) {
      return _EmptyAgenda(startDate: startDate);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: sortedDays.length,
      itemBuilder: (context, index) {
        final day = sortedDays[index];
        final dayEvents = grouped[day]!
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

        // Show a gap separator when there's a break between days
        final showGap =
            index > 0 && day.difference(sortedDays[index - 1]).inDays > 1;

        return Column(
          children: [
            if (showGap) _GapSeparator(),
            _DaySection(
              date: day,
              events: dayEvents,
              onEventTap: onEventTap,
            ),
          ],
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Empty Agenda
// ════════════════════════════════════════════════════════════════
class _EmptyAgenda extends StatelessWidget {
  final DateTime startDate;
  const _EmptyAgenda({required this.startDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note,
              size: 64,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'No upcoming events',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first event',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Gap Separator (shown when days are not consecutive)
// ════════════════════════════════════════════════════════════════
class _GapSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 60),
          Expanded(
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '· · ·',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.4),
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Day Section
// ════════════════════════════════════════════════════════════════
class _DaySection extends StatelessWidget {
  final DateTime date;
  final List<CalendarEvent> events;
  final ValueChanged<CalendarEvent> onEventTap;

  const _DaySection({
    required this.date,
    required this.events,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = date.isToday;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(
                  DateFormat.E().format(date).toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isToday ? AppColors.primary : null,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday ? AppColors.primary : Colors.transparent,
                    border: isToday
                        ? null
                        : Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.5)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
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
          Expanded(
            child: events.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'No events',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : Column(
                    children: events
                        .map((e) => _AgendaEventCard(
                              event: e,
                              onTap: () => onEventTap(e),
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Agenda Event Card
// ════════════════════════════════════════════════════════════════
class _AgendaEventCard extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback onTap;

  const _AgendaEventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(color: event.color, width: 4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
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
                      Wrap(
                        spacing: 12,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
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
                            ],
                          ),
                          if (event.location != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.place_outlined,
                                    size: 14,
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withValues(alpha: 0.6)),
                                const SizedBox(width: 4),
                                Text(
                                  event.location!,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: event.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    event.category.isEmpty
                        ? 'Other'
                        : event.category[0].toUpperCase() +
                            event.category.substring(1),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: event.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
