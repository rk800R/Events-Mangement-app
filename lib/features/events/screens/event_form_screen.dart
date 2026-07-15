import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/calendar_event.dart';
import '../../../providers/event_provider.dart';
import '../../../providers/settings_provider.dart';

class EventFormScreen extends StatefulWidget {
  final DateTime initialDate;
  final CalendarEvent? existing;

  const EventFormScreen({
    super.key,
    required this.initialDate,
    this.existing,
  });

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;

  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late String _category;
  late Priority _priority;
  late int _reminderIndex;
  late Recurrence _recurrence;
  bool _allDay = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _titleController = TextEditingController(text: e.title);
      _descriptionController = TextEditingController(text: e.description ?? '');
      _locationController = TextEditingController(text: e.location ?? '');
      _startDate = e.startTime;
      _startTime = TimeOfDay.fromDateTime(e.startTime);
      _endDate = e.endTime;
      _endTime = TimeOfDay.fromDateTime(e.endTime);
      _category = e.category;
      _priority = e.priority;
      _reminderIndex = AppConstants.reminderOptions.indexOf(e.reminderMinutes);
      _reminderIndex = _reminderIndex < 0 ? 4 : _reminderIndex;
      _recurrence = e.recurrence;
      _allDay = e.isAllDay;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _locationController = TextEditingController();
      _startDate = widget.initialDate;
      _startTime = const TimeOfDay(hour: 9, minute: 0);
      final defaultDuration = context.read<SettingsProvider>().defaultDuration;
      _endDate = _startDate;
      _endTime = TimeOfDay(
        hour: (9 + (defaultDuration ~/ 60)) % 24,
        minute: (defaultDuration % 60),
      );
      _category = 'work';
      _priority = Priority.medium;
      _reminderIndex = 4;
      _recurrence = Recurrence.none;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  DateTime _combine(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) _endDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          // Auto-adjust end time to keep duration
          final startMinutes = picked.hour * 60 + picked.minute;
          final endMinutes = _endTime.hour * 60 + _endTime.minute;
          if (endMinutes <= startMinutes) {
            _endTime = TimeOfDay(
              hour: (picked.hour + 1) % 24,
              minute: picked.minute,
            );
          }
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final start = _allDay
        ? DateTime(_startDate.year, _startDate.month, _startDate.day)
        : _combine(_startDate, _startTime);
    final end = _allDay
        ? DateTime(_startDate.year, _startDate.month, _startDate.day, 23, 59)
        : _combine(_endDate, _endTime);

    if (end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    final provider = context.read<EventProvider>();
    final now = DateTime.now();

    final event = CalendarEvent(
      id: widget.existing?.id ?? now.microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      startTime: start,
      endTime: end,
      category: _category,
      priority: _priority,
      reminderMinutes: AppConstants.reminderOptions[_reminderIndex],
      recurrence: _recurrence,
      createdAt: widget.existing?.createdAt ?? now,
      updatedAt: now,
    );

    if (_isEditing) {
      await provider.updateEvent(event);
    } else {
      await provider.addEvent(event);
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete event?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                FilledButton.styleFrom(backgroundColor: AppColors.priorityHigh),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && widget.existing != null) {
      await context.read<EventProvider>().deleteEvent(widget.existing!.id);
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Event' : 'New Event'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Event title',
                prefixIcon: Icon(Icons.title),
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),

            // All day toggle
            SwitchListTile(
              title: const Text('All day'),
              value: _allDay,
              onChanged: (v) => setState(() => _allDay = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),

            // Start date/time
            _DateTimeRow(
              label: 'Starts',
              dateText: DateFormat.yMMMd().format(_startDate),
              timeText: _allDay ? 'All day' : _startTime.format(context),
              onDateTap: () => _pickDate(true),
              onTimeTap: _allDay ? null : () => _pickTime(true),
            ),
            const SizedBox(height: 12),

            // End date/time
            _DateTimeRow(
              label: 'Ends',
              dateText: DateFormat.yMMMd().format(_endDate),
              timeText: _allDay ? 'All day' : _endTime.format(context),
              onDateTap: () => _pickDate(false),
              onTimeTap: _allDay ? null : () => _pickTime(false),
            ),
            const SizedBox(height: 20),

            // Category
            Text('Category',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: CalendarEvent.categories.map((cat) {
                final selected = _category == cat;
                final color = AppColors.categoryColors[cat]!;
                return ChoiceChip(
                  label: Text(cat[0].toUpperCase() + cat.substring(1)),
                  selected: selected,
                  onSelected: (_) => setState(() => _category = cat),
                  selectedColor: color.withValues(alpha: 0.2),
                  avatar: CircleAvatar(
                    backgroundColor: color,
                    radius: 6,
                  ),
                  labelStyle: TextStyle(
                    color: selected ? color : theme.textTheme.bodyMedium?.color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Priority
            Text('Priority',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Priority.values.map((p) {
                final selected = _priority == p;
                final color = p == Priority.high
                    ? AppColors.priorityHigh
                    : p == Priority.medium
                        ? AppColors.priorityMedium
                        : AppColors.priorityLow;
                return ChoiceChip(
                  label: Text(p.name[0].toUpperCase() + p.name.substring(1)),
                  selected: selected,
                  onSelected: (_) => setState(() => _priority = p),
                  selectedColor: color.withValues(alpha: 0.2),
                  avatar: CircleAvatar(backgroundColor: color, radius: 6),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Reminder
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Reminder'),
              trailing: DropdownButton<int>(
                value: _reminderIndex,
                items: List.generate(AppConstants.reminderOptions.length, (i) {
                  return DropdownMenuItem(
                    value: i,
                    child: Text(AppConstants.reminderLabels[i]),
                  );
                }),
                onChanged: (v) => setState(() => _reminderIndex = v ?? 0),
              ),
            ),

            // Recurrence
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.repeat),
              title: const Text('Repeat'),
              trailing: DropdownButton<Recurrence>(
                value: _recurrence,
                items: Recurrence.values.map((r) {
                  return DropdownMenuItem(
                    value: r,
                    child: Text(r.name[0].toUpperCase() + r.name.substring(1)),
                  );
                }).toList(),
                onChanged: (v) =>
                    setState(() => _recurrence = v ?? Recurrence.none),
              ),
            ),

            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (optional)',
                prefixIcon: Icon(Icons.place_outlined),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: Text(_isEditing ? 'Update Event' : 'Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  final String label;
  final String dateText;
  final String timeText;
  final VoidCallback onDateTap;
  final VoidCallback? onTimeTap;

  const _DateTimeRow({
    required this.label,
    required this.dateText,
    required this.timeText,
    required this.onDateTap,
    this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: InkWell(
            onTap: onDateTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 16, color: theme.textTheme.bodySmall?.color),
                  const SizedBox(width: 8),
                  Text(dateText),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (onTimeTap != null)
          InkWell(
            onTap: onTimeTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time,
                      size: 16, color: theme.textTheme.bodySmall?.color),
                  const SizedBox(width: 8),
                  Text(timeText),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(timeText,
                style: TextStyle(color: theme.textTheme.bodySmall?.color)),
          ),
      ],
    );
  }
}
