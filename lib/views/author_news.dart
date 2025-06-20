import 'package:eight_news/model/news_article.dart';
import 'package:eight_news/views/add_edit.dart';
import 'package:eight_news/views/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AuthorNews extends StatefulWidget {
  @override
  _AuthorNewsPage createState() => _AuthorNewsPage();
}

class _AuthorNewsPage extends State<AuthorNews> {
  late Future<List<NewsArticle>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  //load berita
  void _loadNews() {
    final token = Provider.of<AuthService>(context, listen: false).token;
    _newsFuture = ApiService(token).getNews();
    setState(() {});
  }

  //mengarahkan ke halaman tambah/edit berita
  void _navigateToAddEditScreen([NewsArticle? article]) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (ctx) => AddEditNewsScreen(article: article),
          ),
        )
        .then((_) => _loadNews());
  }

  //menghapus berita
  Future<void> _deleteNews(String id) async {
    try {
      final token = Provider.of<AuthService>(context, listen: false).token;
      await ApiService(token).deleteNews(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berita berhasil dihapus!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadNews();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus berita: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(
        title: const Text('Author Page'),
        backgroundColor: cBg,
        foregroundColor: cTextGreyLight,
        elevation: 0,
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada berita.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final newsList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _loadNews(),
            color: Colors.white,
            backgroundColor: cPrimary,
            child: ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (ctx, index) {
                final article = newsList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: cBox,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              article.title,
                              style: TextStyle(
                                color: cTextGreyLight,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _navigateToAddEditScreen(article),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNews(article.id!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Oleh: ${article.author ?? 'Unknown'} • ${article.createdAt != null ? DateFormat('d MMM yyyy').format(article.createdAt!) : ''}',
                        style: TextStyle(color: cTextGrey, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: cPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToAddEditScreen(),
      ),
    );
  }
}
