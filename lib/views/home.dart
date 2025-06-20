import 'package:eight_news/model/news_article.dart';
import 'package:eight_news/views/detail_news.dart';
import 'package:eight_news/views/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ApiService _apiService;
  List<NewsArticle> _news = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTokenAndNews();
  }

  //load auth token
  Future<void> _loadTokenAndNews() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    _apiService = ApiService(token);
    await _loadNews();
  }

  //load news from API
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
    return DateFormat('h a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final latestNews = _news.take(5).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: cBg,
        appBar: AppBar(
          backgroundColor: cBg,
          elevation: 0,
          centerTitle: true,
          title: Image.asset('assets/images/image 1.png', height: 40.h),
        ),
        body: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              SizedBox(height: 12.h),

              // Trending Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trending',
                    style: TextStyle(
                      color: cTextGreyLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              if (_news.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(article: _news[0]),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _news[0].featuredImageUrl ?? '',
                              height: 200.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    height: 200.h,
                                    width: double.infinity,
                                    color: Colors.grey[700],
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                    ),
                                  ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            _news[0].category ?? 'General',
                            style: TextStyle(color: cTextGrey, fontSize: 14),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            _news[0].title,
                            style: TextStyle(
                              color: cTextGreyLight,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Text(
                                _news[0].author ?? 'Unknown',
                                style: TextStyle(
                                  color: cTextGrey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _formatTime(_news[0].createdAt),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 24.h),

              // Latest Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest',
                    style: TextStyle(
                      color: cTextGreyLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Latest News List
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: latestNews.length,
                    itemBuilder: (context, index) {
                      final article = latestNews[index];
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
                                    //img handler
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
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.category ?? 'General',
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
            ],
          ),
        ),
      ),
    );
  }
}
