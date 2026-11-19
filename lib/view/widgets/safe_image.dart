import 'package:flutter/material.dart';

import '../../core/colors.dart';

/// Gambar dari URL. Aman kalau URL kosong / error / http.
class SafeImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;

  const SafeImage({super.key, required this.url, this.width, this.height});

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: kCard,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();
    return Image.network(
      url.replaceFirst('http://', 'https://'),
      width: width,
      height: height,
      fit: BoxFit.cover,
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }
}
