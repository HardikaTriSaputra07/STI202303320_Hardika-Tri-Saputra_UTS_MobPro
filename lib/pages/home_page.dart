import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_item.dart';
import '../services/storage_service.dart';
import 'add_event_page.dart';

class HomePage extends StatefulWidget {
  final List<Event> events;
  final Function(Event) onAdd;
  final Function(Event) onEdit;
  final Function(int) onDeleteIndex;

  const HomePage({
    super.key,
    required this.events,
    required this.onAdd,
    required this.onEdit,
    required this.onDeleteIndex,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> _selectedIds = {};

  void _toggleSelect(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _exportJson() async {
    final list = widget.events.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(list);
    final filename =
        'events_export_${DateTime.now().millisecondsSinceEpoch}.json';
    final result =
        await StorageService.exportJsonToFile(filename, jsonString);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result != null
              ? 'Berhasil diekspor ke: $result'
              : 'Fitur ekspor belum tersedia di platform ini',
        ),
      ),
    );
  }

  void _deleteSelected() {
    if (_selectedIds.isEmpty) return;
    setState(() {
      widget.events.removeWhere((e) => _selectedIds.contains(e.id));
      _selectedIds.clear();
    });
    StorageService.saveEventsList(widget.events);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Event',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF64B5F6),
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.download_rounded),
              color: Colors.white,
              onPressed: _exportJson,
            ),
            if (_selectedIds.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.redAccent,
                onPressed: _deleteSelected,
              ),
          ],
        ),
        body: widget.events.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada event',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 84),
                itemCount: widget.events.length,
                itemBuilder: (ctx, i) {
                  final ev = widget.events[i];
                  final selected = _selectedIds.contains(ev.id);

                  return InkWell(
                    onLongPress: () => _toggleSelect(ev.id),
                    onTap: () {
                      if (_selectedIds.isNotEmpty) {
                        _toggleSelect(ev.id);
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEventPage(
                            onSave: (edited) {
                              widget.onEdit(edited);
                              StorageService.saveEventsList(widget.events);
                            },
                            existingEvent: ev,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: selected ? 0.6 : 1.0,
                          child: EventItem(
                            event: ev,
                            onDelete: () {
                              final idx = widget.events
                                  .indexWhere((e) => e.id == ev.id);
                              if (idx != -1) {
                                widget.onDeleteIndex(idx);
                                StorageService.saveEventsList(widget.events);
                              }
                            },
                          ),
                        ),
                        if (selected)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.lightBlue,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF42A5F5),
          onPressed: () async {
            final newEvent = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEventPage(onSave: (_) {}),
              ),
            );
            if (newEvent != null && newEvent is Event) {
              setState(() {
                widget.onAdd(newEvent);
              });
              await StorageService.saveEventsList(widget.events);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event berhasil ditambahkan'),
                ),
              );
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
