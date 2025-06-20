import 'dart:convert';
import 'package:eight_news/model/news_article.dart';
import 'package:eight_news/views/detail_news.dart';
import 'package:eight_news/views/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List<NewsArticle> _bookmarked = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  //load bookmarks from shared preferences
  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('bookmarks') ?? [];

    setState(() {
      _bookmarked =
          saved
              .map((jsonStr) => NewsArticle.fromJson(json.decode(jsonStr)))
              .toList();
    });
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy • HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(
        backgroundColor: cBg,
        elevation: 0,
        title: Text(
          'Bookmarks',
          style: TextStyle(color: cTextGreyLight, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child:
            _bookmarked.isEmpty
                ? const Center(
                  child: Text(
                    "Belum ada berita yang disimpan.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : ListView.builder(
                  itemCount: _bookmarked.length,
                  itemBuilder: (context, index) {
                    final article = _bookmarked[index];

                    //mengarahkan ke halaman detail berita
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailScreen(article: article),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  article.featuredImageUrl != null &&
                                          article.featuredImageUrl!.isNotEmpty
                                      ? Image.network(
                                        article.featuredImageUrl!,
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                      : Container(
                                        width: 100,
                                        height: 80,
                                        color: Colors.grey[700],
                                        child: Image.asset(
                                          'assets/images/logo.png',
                                        ),
                                      ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.category ?? 'Uncategorized',
                                    style: TextStyle(
                                      color: cTextGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    article.title,
                                    style: TextStyle(
                                      color: cTextGreyLight,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${article.author ?? 'Unknown'} • ${_formatTime(article.createdAt)}',
                                    style: TextStyle(
                                      color: cTextGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
