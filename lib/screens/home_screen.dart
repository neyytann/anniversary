import 'dart:async';
import 'package:flutter/gestures.dart';
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
  late PageController _pageController;

  int _currentPage = 0;

  // Mouse wheel scroll accumulator (desktop only)
  double _wheelAccum = 0;
  Timer? _wheelTimer;

  static const _sectionCount = 7;
  static const _sectionLabels = [
    'Home', 'Countdown', 'Gallery', 'Videos', 'Timeline', 'Letter', 'Forever',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _wheelTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    final target = page.clamp(0, _sectionCount - 1);
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage = target);
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  // Desktop mouse wheel: accumulate delta, flip page when threshold crossed
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;

    _wheelAccum += event.scrollDelta.dy;
    _wheelTimer?.cancel();
    _wheelTimer = Timer(const Duration(milliseconds: 80), () {
      if (_wheelAccum > 40) {
        _goToPage(_currentPage + 1);
      } else if (_wheelAccum < -40) {
        _goToPage(_currentPage - 1);
      }
      _wheelAccum = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: Stack(
        children: [
          // ── Page view — one section at a time, swipeable on mobile ─────────
          Listener(
            onPointerSignal: _onPointerSignal,
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              // PageScrollPhysics gives the "one page at a time" snap on touch
              physics: const PageScrollPhysics(),
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
          ),

          // ── Navigation bar ─────────────────────────────────────────────────
          NavBar(
            isScrolled: _currentPage > 0,
            currentPage: _currentPage,
            onCountdown: () => _goToPage(1),
            onGallery:   () => _goToPage(2),
            onVideos:    () => _goToPage(3),
            onTimeline:  () => _goToPage(4),
            onLetter:    () => _goToPage(5),
          ),

          // ── Dot indicators (right side) ────────────────────────────────────
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
                        margin: const EdgeInsets.symmetric(vertical: 5),
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