// lib/services/storage_service_web.dart
import 'dart:convert';
import 'dart:html' as html;
import '../models/event.dart';

class StorageService {
  static const _key = 'event_planner_events';

  static Future<List<Event>> loadEvents() async {
    final s = html.window.localStorage[_key];
    if (s == null) return [];
    try {
      final list = jsonDecode(s) as List<dynamic>;
      return list.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveEventsList(List<Event> events) async {
    final jsonStr = jsonEncode(events.map((e) => e.toJson()).toList());
    html.window.localStorage[_key] = jsonStr;
  }

  // Export JSON: create download link
  static Future<String?> exportJsonToFile(String filename, String jsonString) async {
    try {
      final bytes = utf8.encode(jsonString);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement;
      anchor.href = url;
      anchor.download = filename;
      anchor.click();
      html.Url.revokeObjectUrl(url);
      return 'downloaded';
    } catch (_) {
      return null;
    }
  }
}
