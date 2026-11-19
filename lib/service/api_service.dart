import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config.dart';
import '../core/json_helper.dart';
import '../model/item.dart';

class ApiService {
  static Future<dynamic> _get(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: kHeaders)
          .timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) {
        throw Exception('Server membalas kode ${response.statusCode}');
      }
      return jsonDecode(response.body);
    } on TimeoutException {
      throw Exception('Waktu habis, server lambat atau tidak ada internet');
    }
  }

  /// Ambil daftar item.
  static Future<List<Item>> getItems() async {
    final data = await _get('$kApiBase$kListPath');
    final dynamic list = kListKey.isEmpty ? data : readPath(data, kListKey);
    if (list is! List) {
      throw Exception('JSON bukan list. Cek kListKey di core/config.dart');
    }
    return list.whereType<Map<String, dynamic>>().map(Item.fromJson).toList();
  }

  /// Ambil detail satu item berdasarkan id.
  static Future<Item> getItem(String id) async {
    final path = kDetailPath.replaceAll('{id}', Uri.encodeComponent(id));
    final data = await _get('$kApiBase$path');
    dynamic detail = kDetailKey.isEmpty ? data : readPath(data, kDetailKey);
    if (detail is List && detail.isNotEmpty) detail = detail.first;
    if (detail is! Map<String, dynamic>) {
      throw Exception('JSON detail bukan object. Cek kDetailKey di core/config.dart');
    }
    return Item.fromJson(detail);
  }
}
