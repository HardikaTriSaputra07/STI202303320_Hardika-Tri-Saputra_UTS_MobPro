// lib/services/storage_service_io.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/event.dart';

class StorageService {
  static const _fileName = 'events.json';

  static Future<Directory> _appDir() async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<File> _file() async {
    final dir = await _appDir();
    final f = File('${dir.path}/$_fileName');
    if (!await f.exists()) {
      await f.writeAsString('[]');
    }
    return f;
  }

  static Future<List<Event>> loadEvents() async {
    try {
      final f = await _file();
      final s = await f.readAsString();
      final list = jsonDecode(s) as List<dynamic>;
      return list.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveEventsList(List<Event> events) async {
    final f = await _file();
    final jsonStr = jsonEncode(events.map((e) => e.toJson()).toList());
    await f.writeAsString(jsonStr);
  }

  // Export JSON file (returns saved path or null if not available)
  static Future<String?> exportJsonToFile(String filename, String jsonString) async {
    try {
      final dir = await _appDir();
      final f = File('${dir.path}/$filename');
      await f.writeAsString(jsonString);
      return f.path;
    } catch (_) {
      return null;
    }
  }
}
