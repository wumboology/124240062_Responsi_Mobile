import '../core/config.dart';
import '../core/json_helper.dart';

/// Model umum. Ganti nama field kalau perlu, tapi biasanya cukup ubah key di core/config.dart.
class Item {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String image;
  final String description;
  final String date;
  final String link;
  final double? rating;

  const Item({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.image,
    required this.description,
    required this.date,
    required this.link,
    required this.rating,
  });

  /// Judul aman untuk ditampilkan (kalau key judul salah, kelihatan jelas).
  String get displayTitle =>
      title.isEmpty ? '(judul kosong, cek kTitleKeys)' : title;

  /// Dari JSON API. Nama key diatur di core/config.dart.
  factory Item.fromJson(Map<String, dynamic> json) {
    final title = readText(json, kTitleKeys);
    final id = readText(json, kIdKeys);
    return Item(
      id: id.isEmpty ? title : id,
      title: title,
      subtitle: readText(json, kSubtitleKeys),
      category: readText(json, kCategoryKeys, firstOfList: true),
      image: readText(json, kImageKeys, firstOfList: true),
      description: stripHtml(readText(json, kDescriptionKeys)),
      date: readText(json, kDateKeys),
      link: readText(json, kLinkKeys),
      rating: readNumber(json, kRatingKeys),
    );
  }

  /// Dari data yang disimpan di Hive (key-nya milik kita sendiri, bukan milik API).
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      category: map['category'] as String? ?? '',
      image: map['image'] as String? ?? '',
      description: map['description'] as String? ?? '',
      date: map['date'] as String? ?? '',
      link: map['link'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'image': image,
      'description': description,
      'date': date,
      'link': link,
      'rating': rating,
    };
  }
}
