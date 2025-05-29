import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:eight_news/routes/route_name.dart';
import 'utils/helper.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  List<Map<String, dynamic>> pageList = [
    {
      'imageUrl': 'assets/images/intro1.png',
      'heading': 'The World at Your Fingertips',
      'body':
          'Get 24/7 updates on global news – from breaking politics to cultural trends, all in one place',
    },
    {
      'imageUrl': 'assets/images/intro2.png',
      'heading': 'Tailored to Your Curiosity',
      'body':
          'Select your interests and receive handpicked stories. Technology, sports, or entertainment – we’ve got you covered',
    },
    {
      'imageUrl': 'assets/images/intro3.png',
      'heading': 'Trusted Updates in Real-Time',
      'body':
          'Instant alerts for breaking news, rigorously fact-checked by our editors before they reach you',
    },
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      body: Column(
        children: [
          // Image Section
          Expanded(
            flex: 6,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageList.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  pageList[index]['imageUrl'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),

          // Bottom Panel
          Expanded(
            flex: 4,
            child: Container(
              color: cBg,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pageList[_currentPage]['heading'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cWhite,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    pageList[_currentPage]['body'],
                    style: TextStyle(fontSize: 14, color: cTextGrey),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: pageList.length,
                        effect: WormEffect(
                          activeDotColor: cPrimary,
                          dotColor: Colors.grey,
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 8,
                        ),
                      ),
                      Spacer(),
                      if (_currentPage != 0)
                        TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: Text(
                            'Back',
                            style: TextStyle(color: cTextGrey),
                          ),
                        ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == pageList.length - 1) {
                            context.goNamed(RouteNames.login);
                          } else {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cPrimary,
                          foregroundColor: cWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _currentPage == pageList.length - 1
                              ? 'Get Started'
                              : 'Next',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
