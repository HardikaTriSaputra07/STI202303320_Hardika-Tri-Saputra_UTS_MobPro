// lib/main.dart
import 'package:flutter/material.dart';
import 'models/event.dart';
import 'pages/home_page.dart';
import 'pages/add_event_page.dart';
import 'pages/media_page.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Event> _events = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await StorageService.loadEvents();
    setState(() => _events.addAll(list));
  }

  void _addEvent(Event e) {
    setState(() {
      _events.insert(0, e);
    });
    StorageService.saveEventsList(_events);
  }

  void _editEvent(Event e) {
    final idx = _events.indexWhere((ev) => ev.id == e.id);
    if (idx != -1) {
      setState(() => _events[idx] = e);
      StorageService.saveEventsList(_events);
    }
  }

  void _deleteAt(int index) {
    setState(() {
      _events.removeAt(index);
    });
    StorageService.saveEventsList(_events);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(events: _events, onAdd: _addEvent, onEdit: _editEvent, onDeleteIndex: _deleteAt),
      MediaPage(events: _events),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Planner',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFF8F8),
        primaryColor: const Color(0xFF6C6CFF),
        useMaterial3: false,
      ),
      home: Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Media'),
          ],
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: const Color(0xFF6C6CFF),
        ),
      ),
    );
  }
}
