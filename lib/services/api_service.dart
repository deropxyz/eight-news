import 'dart:convert';
import 'package:eight_news/model/news_article.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = 'http://45.149.187.204:3000';
  final String? _token;

  ApiService(this._token);

  Map<String, String> get _headers {
    if (_token != null && _token!.isNotEmpty) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };
    }
    return {'Content-Type': 'application/json'};
  }

  //fungsi get untuk mengambil daftar berita dari server
  Future<List<NewsArticle>> getNews() async {
    final url = Uri.parse('$_baseUrl/api/news');
    print("Meminta daftar berita dari: $url");

    try {
      final response = await http.get(url, headers: _headers);
      print("Status Code dari GET /api/news: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> newsList = responseData['body']['data'];
        return newsList.map((json) => NewsArticle.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal memuat berita. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error saat getNews: $e");
      throw Exception('Failed to load News');
    }
  }

  //buat berita (post)
  Future<NewsArticle> createNews(NewsArticle article) async {
    final url = Uri.parse('$_baseUrl/api/author/news');
    print("Membuat berita baru ke: $url");
    print("Dengan Body: ${article.toJson()}");

    final response = await http.post(
      url,
      headers: _headers,
      body: json.encode(article.toJson()),
    );

    print("Status Code dari POST /api/author/news: ${response.statusCode}");
    print("Response Body dari POST /api/author/news: ${response.body}");
    if (response.statusCode == 200) {
      return article;
    } else {
      throw Exception('Failed to create news. Status: ${response.statusCode}');
    }
  }

  //update berita (put)
  Future<void> updateNews(String id, NewsArticle article) async {
    final url = Uri.parse('$_baseUrl/api/author/news/$id');
    print("Memperbarui berita ke: $url");

    final response = await http.put(
      url,
      headers: _headers,
      body: json.encode(article.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update news. Status: ${response.statusCode}');
    }
  }

  //hapus berita (delete)
  Future<void> deleteNews(String id) async {
    final url = Uri.parse('$_baseUrl/api/author/news/$id');

    final response = await http.delete(url, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus berita. [${response.statusCode}]');
    }

    // Setelah berhasil menghapus di server, hapus dari bookmarks lokal
    final prefs = await SharedPreferences.getInstance();
    final savedBookmarks = prefs.getStringList('bookmarks') ?? [];

    final updatedBookmarks =
        savedBookmarks.where((item) {
          final itemId = (json.decode(item)['id'] ?? '').toString();
          return itemId != id;
        }).toList();

    await prefs.setStringList('bookmarks', updatedBookmarks);
  }
}
