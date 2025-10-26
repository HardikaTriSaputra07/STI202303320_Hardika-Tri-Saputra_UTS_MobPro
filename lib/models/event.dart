// lib/models/event.dart
import 'dart:convert';
import 'dart:typed_data';

class Event {
  final String id;
  String judul;
  String tanggal; // format sederhana: YYYY-MM-DD atau bebas
  String deskripsi;
  Uint8List? gambarBytes;

  Event({
    required this.id,
    required this.judul,
    required this.tanggal,
    this.deskripsi = '',
    this.gambarBytes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'tanggal': tanggal,
      'deskripsi': deskripsi,
      // gambar disimpan sebagai base64 string bila ada
      'gambarBase64': gambarBytes != null ? base64Encode(gambarBytes!) : null,
    };
  }

  factory Event.fromJson(Map<String, dynamic> j) {
    final base64Str = j['gambarBase64'] as String?;
    Uint8List? bytes;
    if (base64Str != null) {
      try {
        bytes = base64Decode(base64Str);
      } catch (_) {
        bytes = null;
      }
    }
    return Event(
      id: j['id'] as String,
      judul: j['judul'] as String? ?? '',
      tanggal: j['tanggal'] as String? ?? '',
      deskripsi: j['deskripsi'] as String? ?? '',
      gambarBytes: bytes,
    );
  }
}
