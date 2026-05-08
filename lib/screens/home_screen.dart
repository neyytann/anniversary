import 'package:flutter/material.dart';
import '../app.dart';
import '../widgets/hero_section.dart';
import '../widgets/countdown_section.dart';
import '../widgets/gallery_section.dart';
import '../widgets/video_gallery_section.dart';
import '../widgets/timeline_section.dart';
import '../widgets/letter_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _sectionCount = 7;

  static const _sectionLabels = [
    'Home',
    'Countdown',
    'Gallery',
    'Videos',
    'Timeline',
    'Letter',
    'Forever',
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: Stack(
        children: [
          // Full-screen page view (vertical snap)
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: const [
              HeroSection(),
              CountdownSection(),
              GallerySection(),
              VideoGallerySection(),
              TimelineSection(),
              LetterSection(),
              FooterSection(),
            ],
          ),

          // Navigation bar
          NavBar(
            isScrolled: _currentPage > 0,
            currentPage: _currentPage,
            onCountdown:    () => _goToPage(1),
            onGallery:      () => _goToPage(2),
            onVideos:       () => _goToPage(3),
            onTimeline:     () => _goToPage(4),
            onLetter:       () => _goToPage(5),
          ),

          // Dot indicators (right side)
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_sectionCount, (i) {
                  final active = _currentPage == i;
                  return GestureDetector(
                    onTap: () => _goToPage(i),
                    child: Tooltip(
                      message: _sectionLabels[i],
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin:
                            const EdgeInsets.symmetric(vertical: 5),
                        width: active ? 6 : 4,
                        height: active ? 18 : 4,
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.rose
                              : AppColors.muted.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}