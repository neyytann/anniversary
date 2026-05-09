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
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  Timer? _snapTimer;
  bool _isSnapping = false;

  static const _sectionCount = 7;
  static const _sectionLabels = [
    'Home', 'Countdown', 'Gallery', 'Videos', 'Timeline', 'Letter', 'Forever',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  double get _pageHeight => MediaQuery.of(context).size.height;

  void _onScroll() {
    if (_isSnapping) return;

    // Update current page indicator while scrolling
    final page = (_scrollController.offset / _pageHeight).round().clamp(0, _sectionCount - 1);
    if (page != _currentPage) {
      setState(() => _currentPage = page);
    }

    // Debounce: snap after user stops scrolling for 120ms
    _snapTimer?.cancel();
    _snapTimer = Timer(const Duration(milliseconds: 120), _snapToNearest);
  }

  void _snapToNearest() {
    if (!_scrollController.hasClients || _isSnapping) return;

    final offset = _scrollController.offset;
    final page = (offset / _pageHeight).round().clamp(0, _sectionCount - 1);
    final target = page * _pageHeight;

    if ((offset - target).abs() < 1.0) return; // already snapped

    _isSnapping = true;
    _scrollController
        .animateTo(
          target,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        )
        .then((_) => _isSnapping = false);

    setState(() => _currentPage = page);
  }

  void _goToPage(int page) {
    _snapTimer?.cancel();
    _isSnapping = true;
    final target = page * _pageHeight;
    _scrollController
        .animateTo(
          target,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        )
        .then((_) => _isSnapping = false);
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: Stack(
        children: [
          // Scrollable sections
          Listener(
            // Smooth mouse-wheel scrolling — don't block, just let it flow
            onPointerSignal: (event) {
              if (event is PointerScrollEvent && !_isSnapping) {
                final newOffset = (_scrollController.offset + event.scrollDelta.dy)
                    .clamp(0.0, _pageHeight * (_sectionCount - 1));
                _scrollController.jumpTo(newOffset);
              }
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Builder(
                builder: (context) {
                  final h = MediaQuery.of(context).size.height;
                  return Column(
                    children: [
                      SizedBox(height: h, child: const HeroSection()),
                      SizedBox(height: h, child: const CountdownSection()),
                      SizedBox(height: h, child: const GallerySection()),
                      SizedBox(height: h, child: const VideoGallerySection()),
                      SizedBox(height: h, child: const TimelineSection()),
                      SizedBox(height: h, child: const LetterSection()),
                      SizedBox(height: h, child: const FooterSection()),
                    ],
                  );
                },
              ),
            ),
          ),

          // Navigation bar
          NavBar(
            isScrolled: _currentPage > 0,
            currentPage: _currentPage,
            onCountdown: () => _goToPage(1),
            onGallery:   () => _goToPage(2),
            onVideos:    () => _goToPage(3),
            onTimeline:  () => _goToPage(4),
            onLetter:    () => _goToPage(5),
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