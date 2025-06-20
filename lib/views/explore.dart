import 'package:eight_news/model/news_article.dart';
import 'package:eight_news/services/api_service.dart';
import 'package:eight_news/views/detail_news.dart';
import 'package:eight_news/views/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late ApiService _apiService;
  List<NewsArticle> _news = [];
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Sports',
    'Politics',
    'Business',
    'Health',
    'War',
    'Science',
    'Other',
  ];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadTokenAndNews();
  }

  //load token
  Future<void> _loadTokenAndNews() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    _apiService = ApiService(token);
    await _loadNews();
  }

  //load news
  Future<void> _loadNews() async {
    try {
      final news = await _apiService.getNews();
      setState(() {
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      print('Gagal memuat berita: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy • HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final lowerCaseCategories =
        _categories.map((e) => e.toLowerCase()).toList();

    //filter berita berdasarkan kategori
    final filteredNews =
        _selectedCategory == 'All'
            ? _news
            : _selectedCategory == 'Other'
            ? _news.where((n) {
              final cat = n.category?.toLowerCase() ?? '';
              return !lowerCaseCategories.contains(cat);
            }).toList()
            : _news.where((n) {
              final cat = n.category?.toLowerCase() ?? '';
              return cat == _selectedCategory.toLowerCase();
            }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: cBg,
        appBar: AppBar(
          backgroundColor: cBg,
          elevation: 0,
          title: Text(
            'Explore',
            style: TextStyle(
              color: cTextGreyLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategory == _categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = _categories[index];
                          });
                        },
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isSelected ? cTextGreyLight : cTextGrey,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredNews.isEmpty
                  ? const Center(
                    child: Text(
                      'Tidak ada berita ditemukan.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                  : ListView.builder(
                    itemCount: filteredNews.length,
                    itemBuilder: (context, index) {
                      final article = filteredNews[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => NewsDetailScreen(article: article),
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
                                    //image handler
                                    article.featuredImageUrl != null &&
                                            article.featuredImageUrl!.isNotEmpty
                                        ? Image.network(
                                          article.featuredImageUrl!,
                                          width: 100,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                    'assets/images/logo.png',
                                                    color: Colors.grey,
                                                  ),
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

                              //list news
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
      ),
    );
  }
}
