// lib/widgets/event_item.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/event.dart';

class EventItem extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;

  const EventItem({super.key, required this.event, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final hasImage = event.gambarBytes != null && event.gambarBytes!.isNotEmpty;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // image area
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: hasImage
                ? Image.memory(event.gambarBytes!, height: 180, fit: BoxFit.cover)
                : Image.asset('assets/images/default_event.png', height: 180, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(event.judul, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(event.tanggal, style: TextStyle(color: Colors.grey[700])),
                  ]),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: onDelete,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
