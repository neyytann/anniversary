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
  final GlobalKey<TimelineSectionState> _timelineKey = GlobalKey();

  int _currentPage = 0;
  bool _isSnapping = false;

  // Touch tracking
  double? _dragStartY;
  double? _lastDragY;
  double _dragStartOffset = 0;
  double _dragVelocity = 0;
  bool _timelineConsumedDrag = false;

  static const _sectionCount = 7;
  static const _sectionLabels = [
    'Home', 'Countdown', 'Gallery', 'Videos', 'Timeline', 'Letter', 'Forever',
  ];

  static const double _swipeThreshold = 40.0;
  static const double _velocityThreshold = 0.3;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double get _pageHeight => MediaQuery.of(context).size.height;

  void _onScroll() {
    if (_isSnapping) return;
    final page = (_scrollController.offset / _pageHeight)
        .round()
        .clamp(0, _sectionCount - 1);
    if (page != _currentPage) {
      setState(() => _currentPage = page);
    }
  }

  void _goToPage(int page) {
    if (_isSnapping) return;
    final clamped = page.clamp(0, _sectionCount - 1);
    _isSnapping = true;
    _scrollController
        .animateTo(
          clamped * _pageHeight,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        )
        .then((_) {
      _isSnapping = false;
      setState(() => _currentPage = clamped);
    });
    setState(() => _currentPage = clamped);
  }

  // ── Touch handlers ──────────────────────────────────────────────────────────

  
  void _onPointerDown(PointerDownEvent event) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (!isMobile) return;

    if (event.kind != PointerDeviceKind.touch) return;

    _dragStartY = event.position.dy;
    _lastDragY = event.position.dy;
    _dragStartOffset = _scrollController.offset;
    _dragVelocity = 0;
    _isSnapping = false;
    _timelineConsumedDrag = false;
  }

  void _onPointerMove(PointerMoveEvent event) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (!isMobile) return;

    if (event.kind != PointerDeviceKind.touch) return;
    if (_dragStartY == null) return;

    if (_lastDragY != null) {
      _dragVelocity = (_lastDragY! - event.position.dy);
    }
    _lastDragY = event.position.dy;

    if (_currentPage == 4) {
      _timelineConsumedDrag = true;
      return;
    }

    final delta = _dragStartY! - event.position.dy;
    final newOffset = (_dragStartOffset + delta)
        .clamp(0.0, _pageHeight * (_sectionCount - 1));
    _scrollController.jumpTo(newOffset);
  }

  void _onPointerUp(PointerUpEvent event) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (!isMobile) return;
    
    if (event.kind != PointerDeviceKind.touch) return;
    if (_dragStartY == null) return;

    final totalDrag = _dragStartY! - event.position.dy;
    final absVelocity = _dragVelocity.abs();

    _dragStartY = null;
    _lastDragY = null;

    if (_timelineConsumedDrag) {
      _timelineConsumedDrag = false;

      final swipingUp = totalDrag > 0;   // finger up → next page
      final hasMomentum = absVelocity > _velocityThreshold ||
          totalDrag.abs() > _swipeThreshold;

      if (hasMomentum) {
        final shouldNavigate = _timelineKey.currentState
            ?.checkBoundaryAndShouldNavigate(swipingUp) ?? false;

        if (shouldNavigate) {
          _goToPage(swipingUp ? _currentPage + 1 : _currentPage - 1);
          return;
        }
      }

      _goToPage(_currentPage);
      return;
    }

    if (absVelocity > _velocityThreshold || totalDrag.abs() > _swipeThreshold) {
      if (totalDrag > 0) {
        _goToPage(_currentPage + 1);
      } else {
        _goToPage(_currentPage - 1);
      }
    } else {
      _goToPage(_currentPage);
    }
  }

  // ── Mouse wheel ─────────────────────────────────────────────────────────────

  double _wheelAccumulated = 0;

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || _isSnapping) return;

    // accumulate scroll instead of immediate page change
    _wheelAccumulated += event.scrollDelta.dy;

    const threshold = 80.0;

    if (_wheelAccumulated.abs() < threshold) return;

    if (_wheelAccumulated > 0) {
      _goToPage(_currentPage + 1);
    } else {
      _goToPage(_currentPage - 1);
    }

    _wheelAccumulated = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: Stack(
        children: [
          Listener(
            onPointerSignal: _onPointerSignal,
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              child: Builder(
                builder: (context) {
                  final h = MediaQuery.of(context).size.height;
                  return Column(
                    children: [
                      SizedBox(height: h, child: const HeroSection()),
                      SizedBox(height: h, child: const CountdownSection()),
                      SizedBox(height: h, child: const GallerySection()),
                      SizedBox(height: h, child: const VideoGallerySection()),
                      SizedBox(
                        height: h,
                        child: TimelineSection(
                          key: _timelineKey,
                          onBoundaryChanged: (atTop, atBottom) {
                          },
                        ),
                      ),
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

          // Dot indicators
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