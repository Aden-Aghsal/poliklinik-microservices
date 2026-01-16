import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api_service.dart';
import '../../utils/storage.dart';

class ApiLogbookService {
  // Gunakan baseUrl dari ApiService utama
  static const String baseUrl = "http://192.168.0.6:8001/api/logbooks";

  // Header helper (sama seperti ApiService but we need it here cleanly)
  static Map<String, String> _headers({bool auth = true}) {
    final token = Storage.getToken();
    return {
      "Accept": "application/json",
      if (auth && token != null) "Authorization": "Bearer $token",
      // Content-Type handled automatically specifically for multipart request
    };
  }

  /// ==================================================
  /// GET LECTURERS (DOSEN)
  /// ==================================================
  static Future<List<Map<String, dynamic>>> getLecturers() async {
    try {
      // Endpoint asumsi: /users?role=dosen
      final uri = Uri.parse("$baseUrl/users?role=dosen");
      final token = Storage.getToken();

      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
      return [];
    } catch (e) {
      print("Error getLecturers: $e");
      return [];
    }
  }

  /// ==================================================
  /// CREATE LOGBOOK
  /// ==================================================
  static Future<Map<String, dynamic>> createLogbook({
    required int lecturerId,
    required String tanggal,
    required String kegiatan,
    required String lokasi,
    File? foto,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/logbooks");
      
      // Gunakan MultipartRequest untuk upload file
      var request = http.MultipartRequest('POST', uri);
      
      // Headers
      final token = Storage.getToken();
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      // Fields
      request.fields['lecturer_id'] = lecturerId.toString();
      request.fields['tanggal'] = tanggal;
      request.fields['kegiatan'] = kegiatan;
      request.fields['lokasi'] = lokasi;

      // File
      if (foto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto_bukti_praktek',
          foto.path,
        ));
      }

      // Send
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final body = jsonDecode(response.body);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          "success": true, 
          "message": body['message'] ?? "Logbook berhasil dibuat"
        };
      } else {
        return {
          "success": false, 
          "message": body['message'] ?? "Gagal membuat logbook"
        };
      }

    } catch (e) {
      return {
        "success": false, 
        "message": "Terjadi kesalahan koneksi: $e"
      };
    }
  }

  /// ==================================================
  /// GET ALL LOGBOOKS (PAGINATED)
  /// ==================================================
  static Future<Map<String, dynamic>> getLogbooks({int page = 1}) async {
    try {
      final uri = Uri.parse("$baseUrl/logbooks?page=$page");
      final token = Storage.getToken();

      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return {
          "success": true,
          "data": body['data'], // Ini array items
          "meta": body['pagination'] // Pagination info
        };
      }
      return {"success": false};
    } catch (e) {
      return {"success": false};
    }
  }
}
