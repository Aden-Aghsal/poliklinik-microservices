import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class ApiServiceKon {
  // Base URL utama
  static const String baseUrl = 'http://192.168.0.19:9000/api';
  
  // URL untuk mengambil gambar dari storage admin
  static const String storageUrl = 'http://192.168.0.19:9000/storage/';
  // ================== FUNGSI AMBIL BERITA ==================
  Future<List<NewsModel>> getNews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/news'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['data'] != null) {
          final List<dynamic> newsList = responseData['data'];
          return newsList.map((e) => NewsModel.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Server Error Berita: ${response.statusCode}');
      }
    } catch (e) {
      print("Error Detail Berita: $e");
      throw Exception('Kesalahan koneksi berita: $e');
    }
  }

  // ================== FUNGSI AMBIL ARTIKEL ==================
  Future<List<NewsModel>> getArticles() async {
    try {
      // Pastikan endpoint di web admin kamu adalah /api/articles
      final response = await http.get(Uri.parse('$baseUrl/articles'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['data'] != null) {
          final List<dynamic> articleList = responseData['data'];
          // Menggunakan model yang sama (NewsModel) karena struktur datanya mirip
          return articleList.map((e) => NewsModel.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Server Error Artikel: ${response.statusCode}');
      }
    } catch (e) {
      print("Error Detail Artikel: $e");
      throw Exception('Kesalahan koneksi artikel: $e');
    }
  }
}