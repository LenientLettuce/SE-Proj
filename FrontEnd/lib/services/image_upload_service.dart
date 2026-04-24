import 'dart:convert';
import 'dart:developer'; // For logging
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ImageUploadService {
  ImageUploadService({required this.baseUrl, required this.token});

  final String baseUrl;
  final String? token;

  Future<String> uploadProductImage(XFile file) async {
    final uri = Uri.parse('$baseUrl/api/v1/uploads/image');

    // 1. Log the attempt for transparency
    log('Attempting POST to: $uri');

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        if (token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
        'Accept': 'application/json', // Explicitly ask for JSON
      });

    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
    final parts = mimeType.split('/');

    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // Ensure this matches your FastAPI argument name
        file.path,
        filename: file.name,
        contentType: MediaType(parts.first, parts.length > 1 ? parts[1] : 'jpeg'),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    // 2. Comprehensive Error Handling
    if (response.statusCode >= 400) {
      log('Upload failed with status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 405) {
        throw Exception(
            'Method Not Allowed (405): Check if your URL is correct and lacks a trailing slash. '
                'Attempted URL: $uri'
        );
      }

      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        // This will now capture your FastAPI detail: "Only JPG, PNG..." etc.
        final detail = decoded['detail'];

        if (detail is String) {
          throw Exception('Server Error: $detail');
        } else if (detail is List) {
          // FastAPI validation errors (pydantic) are often lists
          throw Exception('Validation Error: ${jsonEncode(detail)}');
        }

        throw Exception('Image upload failed (${response.statusCode})');
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Upload failed: ${response.body}');
      }
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return (decoded['url'] ?? '').toString();
  }
}
