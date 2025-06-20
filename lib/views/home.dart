import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'utils/helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();
  int currentCarouselIndex = 0;
  bool _showTrending = false;
  int selectedCategoryIndex = 0;

  List<Map<String, dynamic>> carouselItems = [
    {
      'image': 'assets/images/moskva.png',
      'title': 'Russian warship: Moskva sinks in Black Sea',
      'subtitle': 'Europe',
      'source': 'BBC News',
      'time': '1h ago',
    },
  ];

  final List<String> categories = [
    'All',
    'Sports',
    'Politics',
    'Business',
    'Health',
    'Travel',
    'Science',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: cBg,
        body:
            _showTrending
                ? _buildTrendingPage()
                : Padding(
                  padding: REdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Image.asset(
                              'assets/images/image 1.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      //Search
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 77, 77, 77),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: TextField(
                                controller: searchController,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.search, color: Colors.white),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          // Notification Icon
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 77, 77, 77),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Trending',
                            style: TextStyle(
                              color: Color.fromARGB(255, 228, 228, 228),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showTrending = true;
                              });
                            },
                            child: const Text(
                              'See all',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Trending
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              carouselItems[0]['image'],
                              height: 200.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Kategori
                          Text(
                            carouselItems[0]['subtitle'],
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4.h),

                          // Judul
                          Text(
                            carouselItems[0]['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),

                          // Sumber dan Waktu
                          Row(
                            children: [
                              Text(
                                carouselItems[0]['source'],
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                carouselItems[0]['time'],
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Latest',
                            style: TextStyle(
                              color: Color.fromARGB(255, 243, 243, 243),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('See all', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final isSelected = selectedCategoryIndex == index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategoryIndex = index;
                                  });
                                },
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color:
                                        isSelected ? Colors.white : Colors.grey,
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
                      SizedBox(height: 16.h),

                      //latest news
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar Thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    index == 0
                                        ? 'assets/images/zelenskuy.png'
                                        : 'assets/images/moskva.png', // ganti sesuai gambar lain
                                    width: 100,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12),

                                // Konten Teks (kategori, judul, source)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Kategori
                                      Text(
                                        index == 0 ? 'Europe' : 'Travel',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      // Judul
                                      Text(
                                        index == 0
                                            ? "Ukraine's President Zelensky to BBC: Blood money being paid..."
                                            : "Her train broke down. Her phone died. Then she met her...",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            202,
                                            202,
                                            202,
                                          ),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 6),
                                      // Sumber dan waktu
                                      Row(
                                        children: [
                                          SizedBox(width: 6),
                                          Text(
                                            index == 0
                                                ? 'BBC News • 14m ago'
                                                : 'CNN • 1h ago',
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
                              ],
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

  Widget _buildTrendingPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _showTrending = false),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                'Trending',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/moskva.png',
                        width: double.infinity,
                        height: 180.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Europe', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text(
                      'Russian warship: Moskva sinks in Black Sea',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'BBC News • 4h ago',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
