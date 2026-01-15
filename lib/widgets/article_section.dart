import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/api_service_kon.dart';

class ArticleSection extends StatelessWidget {
  // 1. TAMBAHKAN INI: Agar bisa menerima data yang dikirim Navigator
  final NewsModel item;

  // 2. PERBAIKI CONSTRUCTOR: Masukkan 'item' ke sini
  const ArticleSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar Detail
            Image.network(
              Uri.parse(ApiServiceKon.storageUrl + item.thumbnail).toString(),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Gunakan ini untuk melihat link yang error di Console
                debugPrint(
                  "Link Error: ${ApiServiceKon.storageUrl}${item.thumbnail}",
                );
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Isi Konten
                  Text(
                    item.content.replaceAll(RegExp(r'<[^>]*>'), ''),
                    style: const TextStyle(fontSize: 16),
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
