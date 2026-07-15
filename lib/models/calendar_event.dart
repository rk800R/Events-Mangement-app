import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum Priority { low, medium, high }

enum Recurrence { none, daily, weekly, monthly, yearly }

class CalendarEvent {
  final String id;
  final String title;
  final String? description;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final String category;
  final Priority priority;
  final int reminderMinutes;
  final Recurrence recurrence;
  final DateTime createdAt;
  final DateTime updatedAt;

  CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.category,
    this.priority = Priority.medium,
    this.reminderMinutes = 15,
    this.recurrence = Recurrence.none,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAllDay => endTime.difference(startTime).inHours >= 23;

  bool get isMultiDay =>
      startTime.year != endTime.year ||
      startTime.month != endTime.month ||
      startTime.day != endTime.day;

  Duration get duration => endTime.difference(startTime);

  Color get color => AppColors.categoryColors[category] ?? AppColors.primary;

  Color get priorityColor {
    switch (priority) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  bool occursOn(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return startTime.isBefore(dayEnd) && endTime.isAfter(dayStart);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'category': category,
        'priority': priority.name,
        'reminderMinutes': reminderMinutes,
        'recurrence': recurrence.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => CalendarEvent(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        location: json['location'] as String?,
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: DateTime.parse(json['endTime'] as String),
        category: json['category'] as String,
        priority: Priority.values.byName(json['priority'] as String),
        reminderMinutes: json['reminderMinutes'] as int,
        recurrence: Recurrence.values.byName(json['recurrence'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? startTime,
    DateTime? endTime,
    String? category,
    Priority? priority,
    int? reminderMinutes,
    Recurrence? recurrence,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      CalendarEvent(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        location: location ?? this.location,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        reminderMinutes: reminderMinutes ?? this.reminderMinutes,
        recurrence: recurrence ?? this.recurrence,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static List<String> get categories =>
      AppColors.categoryColors.keys.toList(growable: false);
}
