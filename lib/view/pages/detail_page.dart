import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/config.dart';
import '../../model/item.dart';
import '../../service/api_service.dart';
import '../../service/saved_storage.dart';
import '../widgets/safe_image.dart';

/// Terima Item dari list, tampilkan langsung, lalu (kalau kDetailPath diisi)
/// ambil detail lengkap dari API berdasarkan id.
class DetailPage extends StatefulWidget {
  final Item item;

  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Item _item;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _isSaved = SavedStorage.contains(widget.item.id);
    if (kDetailPath.isNotEmpty) _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final detail = await ApiService.getItem(widget.item.id);
      if (!mounted) return;
      setState(() {
        _item = detail;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _toggleSaved() {
    if (_isSaved) {
      SavedStorage.remove(_item.id);
    } else {
      SavedStorage.save(_item);
    }
    setState(() => _isSaved = !_isSaved);
  }

  Widget _buildStatus() {
    if (_isLoading) {
      return const LinearProgressIndicator(color: kAccent);
    }
    if (_errorMessage != null) {
      return Container(
        color: kCard,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Detail gagal dimuat: $_errorMessage',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
            TextButton(onPressed: _fetchDetail, child: const Text('Coba Lagi')),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail', style: TextStyle(fontSize: 16))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatus(),
            SafeImage(url: item.image, width: double.infinity, height: 300),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (item.rating != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text('${item.rating}', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      if (item.category.isNotEmpty) _chip(item.category),
                      if (item.date.isNotEmpty) _chip(item.date),
                    ],
                  ),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: _toggleSaved,
                      icon: Icon(_isSaved ? Icons.check : Icons.add),
                      label: Text(
                        _isSaved
                            ? 'Hapus dari $kSavedWord'
                            : 'Tambah ke $kSavedWord',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSaved ? kCard : kAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description.isEmpty
                        ? 'Tidak ada deskripsi.'
                        : item.description,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
