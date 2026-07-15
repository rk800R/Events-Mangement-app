import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/calendar_event.dart';
import '../../../providers/event_provider.dart';
import 'event_form_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final event = context.select<EventProvider, CalendarEvent?>(
      (p) => p.events.where((e) => e.id == eventId).firstOrNull,
    );

    if (event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Event not found')),
      );
    }

    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      event.color,
                      event.color.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            event.category.isEmpty
                                ? 'Other'
                                : event.category[0].toUpperCase() +
                                    event.category.substring(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EventFormScreen(
                        initialDate: event.startTime, existing: event),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete event?'),
                      content: Text('Delete "${event.title}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: FilledButton.styleFrom(
                              backgroundColor: AppColors.priorityHigh),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && context.mounted) {
                    await context.read<EventProvider>().deleteEvent(event.id);
                    if (context.mounted) Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoTile(
                    icon: Icons.access_time,
                    title: _formatTimeRange(event),
                    subtitle: _formatDate(event),
                  ),
                  if (event.location != null)
                    _InfoTile(
                      icon: Icons.place_outlined,
                      title: event.location!,
                    ),
                  _InfoTile(
                    icon: Icons.flag_outlined,
                    title:
                        'Priority: ${event.priority.name[0].toUpperCase()}${event.priority.name.substring(1)}',
                    iconColor: event.priorityColor,
                  ),
                  if (event.recurrence != Recurrence.none)
                    _InfoTile(
                      icon: Icons.repeat,
                      title: 'Repeats ${event.recurrence.name}',
                    ),
                  _InfoTile(
                    icon: Icons.notifications_outlined,
                    title: event.reminderMinutes == 0
                        ? 'At time of event'
                        : () {
                            final idx = AppConstants.reminderOptions
                                .indexOf(event.reminderMinutes);
                            final label = (idx >= 0)
                                ? AppConstants.reminderLabels[idx]
                                : '${event.reminderMinutes} min before';
                            return 'Reminder $label';
                          }(),
                  ),
                  if (event.description != null) ...[
                    const SizedBox(height: 20),
                    Text('Description',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event.description!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeRange(CalendarEvent e) =>
      '${DateFormat.Hm().format(e.startTime)} – ${DateFormat.Hm().format(e.endTime)}';

  String _formatDate(CalendarEvent e) {
    if (e.isMultiDay) {
      return '${DateFormat.yMMMd().format(e.startTime)} – ${DateFormat.yMMMd().format(e.endTime)}';
    }
    return '${DateFormat.EEEE().format(e.startTime)}, ${DateFormat.yMMMd().format(e.startTime)}';
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;

  const _InfoTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? theme.colorScheme.primary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: iconColor ?? theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge),
                if (subtitle != null)
                  Text(subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
