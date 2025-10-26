import 'package:flutter/material.dart';
import '../models/event.dart';

class MediaPage extends StatelessWidget {
  final List<Event> events;
  const MediaPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final mediaItems =
        events.where((e) => e.gambarBytes != null && e.gambarBytes!.isNotEmpty).toList();

    if (mediaItems.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFE3F2FD),
        appBar: AppBar(
          title: const Text('Media'),
          backgroundColor: const Color(0xFF64B5F6),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: const Center(
          child: Text(
            'Belum ada media.',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Media'),
        backgroundColor: const Color(0xFF64B5F6),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: mediaItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, i) {
            final e = mediaItems[i];
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (e.gambarBytes != null)
                            Image.memory(e.gambarBytes!, fit: BoxFit.contain),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.judul),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(e.gambarBytes!, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
