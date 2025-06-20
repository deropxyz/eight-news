import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eight_news/views/utils/helper.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final List<String> categories = [
    'All',
    'Politics',
    'Sports',
    'Business',
    'Tech',
    'Health',
    'Travel',
  ];

  int selectedCategoryIndex = 0;

  final List<Map<String, String>> trendingTopics = [
    {
      'title': 'Pemilu 2025 semakin dekat, siapa yang unggul?',
      'image': 'assets/images/zelenskuy.png',
      'source': 'Kompas',
      'time': '1h ago',
    },
    {
      'title': 'Bitcoin kembali sentuh harga \$70K',
      'image': 'assets/images/moskva.png',
      'source': 'CNN',
      'time': '2h ago',
    },
    {
      'title': 'Startup AI lokal raih pendanaan besar',
      'image': 'assets/images/zelenskuy.png',
      'source': 'Tech in Asia',
      'time': '3h ago',
    },
    {
      'title': 'Eksplorasi Mars: NASA rilis temuan baru',
      'image': 'assets/images/moskva.png',
      'source': 'NASA',
      'time': '4h ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: cBg,
        body: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Explore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Kategori horizontal
              SizedBox(
                height: 30.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedCategoryIndex == index;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = index;
                          });
                        },
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
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
              SizedBox(height: 20.h),

              // Trending grid 2 kolom
              Expanded(
                child: GridView.builder(
                  itemCount: trendingTopics.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final item = trendingTopics[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              item['image']!,
                              width: double.infinity,
                              height: 120.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${item['source']} • ${item['time']}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
