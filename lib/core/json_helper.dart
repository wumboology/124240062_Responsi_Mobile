/// Ambil nilai dari JSON pakai path bertitik. Contoh: 'image.medium'.
dynamic readPath(dynamic json, String path) {
  dynamic current = json;
  for (final key in path.split('.')) {
    if (current is Map && current.containsKey(key)) {
      current = current[key];
    } else {
      return null;
    }
  }
  return current;
}

/// Coba beberapa path berurutan, kembalikan teks pertama yang ada isinya.
/// Kalau nilainya list sederhana: digabung ', ' (atau ambil elemen pertama kalau [firstOfList]).
String readText(dynamic json, List<String> paths, {bool firstOfList = false}) {
  for (final path in paths) {
    final value = readPath(json, path);
    if (value == null || value is Map) continue;
    if (value is List) {
      final items = value
          .where((e) => e != null && e is! Map && e is! List)
          .map((e) => e.toString())
          .toList();
      if (items.isEmpty) continue;
      return firstOfList ? items.first : items.join(', ');
    }
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return '';
}

/// Sama seperti [readText] tapi hasilnya angka (null kalau tidak ada / bukan angka).
double? readNumber(dynamic json, List<String> paths) {
  for (final path in paths) {
    final value = readPath(json, path);
    if (value == null) continue;
    final number = num.tryParse(value.toString());
    if (number != null) return number.toDouble();
  }
  return null;
}

/// Buang tag HTML seperti <p>, <b>.
String stripHtml(String text) => text.replaceAll(RegExp(r'<[^>]*>'), '').trim();
