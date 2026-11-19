import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/colors.dart';
import '../../core/config.dart';
import '../../service/saved_storage.dart';
import '../widgets/item_tile.dart';
import 'detail_page.dart';

/// Daftar tersimpan. Hapus: tombol tong sampah ATAU swipe ke kiri.
class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kSavedWord, style: TextStyle(fontSize: 16)),
      ),
      body: ValueListenableBuilder<Box<String>>(
        valueListenable: SavedStorage.box.listenable(),
        builder: (context, box, child) {
          final items = SavedStorage.all();
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada data tersimpan'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  margin: const EdgeInsets.only(bottom: 8),
                  color: kAccent,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => SavedStorage.remove(item.id),
                child: ItemTile(
                  item: item,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(item: item),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: kAccent, size: 20),
                    onPressed: () => SavedStorage.remove(item.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
