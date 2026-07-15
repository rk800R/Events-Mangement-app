import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calendar_event.dart';

class LocalStorage {
  static const _eventsKey = 'harmonical_events_v1';

  Future<List<CalendarEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_eventsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveEvents(List<CalendarEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(events.map((e) => e.toJson()).toList());
    await prefs.setString(_eventsKey, raw);
  }
}
