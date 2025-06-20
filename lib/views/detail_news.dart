import 'dart:convert';
import 'package:eight_news/model/news_article.dart';
import 'package:eight_news/views/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsArticle article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarkState();
  }

  // Memuat status bookmark dari SharedPreferences
  Future<void> _loadBookmarkState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('bookmarks') ?? [];
    final ids = saved.map((e) => json.decode(e)['id']).toList();
    setState(() {
      isBookmarked = ids.contains(widget.article.id);
    });
  }

  // Toggle bookmark state and save to SharedPreferences
  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('bookmarks') ?? [];
    final articleMap = widget.article.toJson();
    articleMap['id'] = widget.article.id;

    if (isBookmarked) {
      saved.removeWhere((item) => json.decode(item)['id'] == widget.article.id);
    } else {
      saved.add(json.encode(articleMap));
    }

    await prefs.setStringList('bookmarks', saved);
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy • HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(backgroundColor: cBg, elevation: 0),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: cBg, // Sesuaikan dengan tema dark kamu
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Kembali
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: cTextGreyLight),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cBg,
                foregroundColor: cTextGreyLight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Tombol Bookmark
            ElevatedButton.icon(
              onPressed: _toggleBookmark,
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: cPrimary,
              ),
              label: Text(isBookmarked ? 'Bookmarks' : 'Bookmarks'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cBg,
                foregroundColor: cTextGreyLight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            // Author & waktu
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage('assets/images/image 1.png'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.article.author ?? 'Unknown',
                      style: TextStyle(
                        color: cTextGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDate(widget.article.createdAt),
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  widget.article.featuredImageUrl != null &&
                          widget.article.featuredImageUrl!.isNotEmpty
                      ? Image.network(
                        widget.article.featuredImageUrl!,
                        height: 300.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Image.asset('assets/images/logo.png'),
                      )
                      : Container(
                        height: 250.h,
                        width: double.infinity,
                        color: Colors.grey[700],
                        child: Image.asset('assets/images/logo.png'),
                      ),
            ),
            SizedBox(height: 20.h),

            // Kategori
            Text(
              widget.article.category ?? 'General',
              style: TextStyle(color: cTextGrey, fontSize: 15),
            ),
            SizedBox(height: 16.h),

            // Judul
            Text(
              widget.article.title,
              style: TextStyle(
                color: cTextGreyLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),

            // Konten
            Text(
              widget.article.content,
              style: TextStyle(color: cTextGrey, fontSize: 14),
            ),
            SizedBox(height: 80.h), // Extra padding bottom
          ],
        ),
      ),
    );
  }
}
