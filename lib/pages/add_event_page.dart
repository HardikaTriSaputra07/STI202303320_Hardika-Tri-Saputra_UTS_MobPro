import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/event.dart';

typedef OnSaveEvent = void Function(Event event);

class AddEventPage extends StatefulWidget {
  final OnSaveEvent onSave;
  final Event? existingEvent;
  const AddEventPage({super.key, required this.onSave, this.existingEvent});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _judulCtrl = TextEditingController();
  final _tanggalCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  String _kategori = 'Umum';

  @override
  void initState() {
    super.initState();
    final e = widget.existingEvent;
    if (e != null) {
      _judulCtrl.text = e.judul;
      _tanggalCtrl.text = e.tanggal;
      _descCtrl.text = e.deskripsi;
      _imageBytes = e.gambarBytes;
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000,
        maxHeight: 2000,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() => _imageBytes = bytes);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Gagal memilih gambar')));
    }
  }

  void _save() {
    final judul = _judulCtrl.text.trim();
    final tanggal = _tanggalCtrl.text.trim();
    final deskripsi = _descCtrl.text.trim();
    if (judul.isEmpty || tanggal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi judul & tanggal')));
      return;
    }

    final id = widget.existingEvent?.id ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final event = Event(
      id: id,
      judul: judul,
      tanggal: tanggal,
      deskripsi: deskripsi,
      gambarBytes: _imageBytes,
    );
    widget.onSave(event);
    Navigator.pop(context, event);
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _tanggalCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingEvent != null;
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Event' : 'Tambah Event'),
        backgroundColor: const Color(0xFF64B5F6),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _judulCtrl,
            decoration: const InputDecoration(
              labelText: 'Judul Event',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tanggalCtrl,
            decoration: const InputDecoration(
              labelText: 'Tanggal (YYYY-MM-DD)',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Deskripsi',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _kategori,
            decoration: const InputDecoration(
              labelText: 'Kategori',
              filled: true,
              fillColor: Colors.white,
            ),
            items: const [
              DropdownMenuItem(value: 'Umum', child: Text('Umum')),
              DropdownMenuItem(value: 'Seminar', child: Text('Seminar')),
              DropdownMenuItem(value: 'Ulang Tahun', child: Text('Ulang Tahun')),
              DropdownMenuItem(value: 'Kampus', child: Text('Kampus')),
            ],
            onChanged: (v) => setState(() => _kategori = v ?? 'Umum'),
          ),
          const SizedBox(height: 16),
          Row(children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('Ambil Foto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF90CAF9),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            if (_imageBytes != null)
              ElevatedButton.icon(
                onPressed: () => setState(() => _imageBytes = null),
                icon: const Icon(Icons.delete_forever),
                label: const Text('Hapus Gambar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBBDEFB),
                  foregroundColor: Colors.black87,
                ),
              ),
          ]),
          const SizedBox(height: 12),
          if (_imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  Image.memory(_imageBytes!, height: 160, fit: BoxFit.cover),
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(isEdit ? 'Simpan Perubahan' : 'Simpan Event'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF64B5F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
