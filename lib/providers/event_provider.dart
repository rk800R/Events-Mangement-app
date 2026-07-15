import 'package:flutter/foundation.dart';
import '../data/local_storage.dart';
import '../models/calendar_event.dart';

class EventProvider extends ChangeNotifier {
  final LocalStorage _storage = LocalStorage();

  List<CalendarEvent> _events = [];
  bool _loading = true;

  List<CalendarEvent> get events => List.unmodifiable(_events);
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _events = await _storage.loadEvents();
    _loading = false;
    notifyListeners();
  }

  Future<void> addEvent(CalendarEvent event) async {
    _events = [..._events, event]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    notifyListeners();
    await _storage.saveEvents(_events);
  }

  Future<void> updateEvent(CalendarEvent event) async {
    _events = _events.map((e) => e.id == event.id ? event : e).toList();
    notifyListeners();
    await _storage.saveEvents(_events);
  }

  Future<void> deleteEvent(String id) async {
    _events = _events.where((e) => e.id != id).toList();
    notifyListeners();
    await _storage.saveEvents(_events);
  }

  List<CalendarEvent> eventsForDay(DateTime day) =>
      _events.where((e) => e.occursOn(day)).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

  List<CalendarEvent> eventsInRange(DateTime start, DateTime end) {
    final endExclusive = end.add(const Duration(days: 1));
    return _events
        .where((e) =>
            e.startTime.isBefore(endExclusive) && e.endTime.isAfter(start))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<CalendarEvent> upcoming({int limit = 10}) {
    final now = DateTime.now();
    final upcoming = _events.where((e) => e.endTime.isAfter(now)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return upcoming.take(limit).toList();
  }
}
