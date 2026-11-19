import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../core/config.dart';
import '../model/item.dart';

/// Favorit / keranjang / bookmark. Hive Box<String> berisi JSON, key = id item.
/// Tidak pakai TypeAdapter, jadi tidak perlu build_runner.
class SavedStorage {
  static Box<String> get box => Hive.box<String>(kSavedBox);

  static bool contains(String id) => box.containsKey(id);

  static Future<void> save(Item item) =>
      box.put(item.id, jsonEncode(item.toMap()));

  static Future<void> remove(String id) => box.delete(id);

  static List<Item> all() {
    return box.values
        .map((text) => Item.fromMap(jsonDecode(text) as Map<String, dynamic>))
        .toList();
  }
}
