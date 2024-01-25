import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey;
  final String baseUrl = 'https://newsapi.org/v2/everything';
  ApiService(this.apiKey);

  Future<List<Map<String, dynamic>>> getNews(String query, String sortBy) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$query&sortBy=$sortBy&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['articles']);
    } else {
      throw Exception('Failed to load news');
    }
  }
}
