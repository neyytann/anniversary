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

  // Timeline boundary state — tracks whether the boundary was ALREADY hit
  // before the current swipe began. Navigation only happens when this is true,
  // i.e. the user is swiping *again* after having already reached the edge.
  bool _timelineBoundaryWasAlreadyHit = false;
  // Which direction the boundary was hit (true = bottom, false = top)
  bool _timelineBoundaryAtBottom = false;

  static const _sectionCount = 7;
  static const _sectionLabels = [
    'Home', 'Countdown', 'Gallery', 'Videos', 'Timeline', 'Letter', 'Forever',
  ];

  static const double _swipeThreshold = 50.0;
  static const double _velocityThreshold = 0.5;

  // Wheel
  double _wheelAccumulated = 0;
  bool _wheelFired = false;

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
    if (page != _currentPage) setState(() => _currentPage = page);
  }

  void _goToPage(int page) {
    if (_isSnapping) return;
    final clamped = page.clamp(0, _sectionCount - 1);
    if (clamped == _currentPage) return;
    _isSnapping = true;
    // Reset timeline boundary tracking whenever we leave the timeline page
    if (_currentPage == 4) {
      _timelineBoundaryWasAlreadyHit = false;
    }
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
    if (event.kind != PointerDeviceKind.touch) return;
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (!isMobile) return;

    _dragStartY = event.position.dy;
    _lastDragY = event.position.dy;
    _dragStartOffset = _scrollController.offset;
    _dragVelocity = 0;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.kind != PointerDeviceKind.touch) return;
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (!isMobile || _dragStartY == null || _isSnapping) return;

    if (_lastDragY != null) {
      _dragVelocity = _lastDragY! - event.position.dy;
    }
    _lastDragY = event.position.dy;

    // On timeline page: do NOT move the parent — let inner scroll handle it
    if (_currentPage == 4) return;

    final delta = _dragStartY! - event.position.dy;
    final newOffset = (_dragStartOffset + delta)
        .clamp(0.0, _pageHeight * (_sectionCount - 1));
    _scrollController.jumpTo(newOffset);
  }

  void _onPointerUp(PointerUpEvent event) {
    if (event.kind != PointerDeviceKind.touch) return;
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (!isMobile || _dragStartY == null) return;

    final totalDrag = _dragStartY! - event.position.dy;
    final absVelocity = _dragVelocity.abs();
    _dragStartY = null;
    _lastDragY = null;

    final hasMomentum =
        absVelocity > _velocityThreshold || totalDrag.abs() > _swipeThreshold;

    if (!hasMomentum) {
      if (_currentPage != 4) _goToPage(_currentPage);
      return;
    }

    final swipingUp = totalDrag > 0; // finger moved up → want next page

    if (_currentPage == 4) {
      // Check where the inner scroll currently is
      final atBoundary = _timelineKey.currentState
              ?.checkBoundaryAndShouldNavigate(swipingUp) ??
          true;

      if (atBoundary) {
        // The inner scroll has reached (or was already at) the edge.
        // Only navigate if this boundary was ALREADY hit before this swipe —
        // i.e. this is the user's second swipe past the edge.
        final boundaryMatchesDirection =
            _timelineBoundaryWasAlreadyHit &&
            (swipingUp == _timelineBoundaryAtBottom);

        if (boundaryMatchesDirection) {
          // Second swipe at the same boundary → go to next/prev page
          _timelineBoundaryWasAlreadyHit = false;
          _goToPage(swipingUp ? _currentPage + 1 : _currentPage - 1);
        } else {
          // First time hitting this boundary — record it, stay on this page
          _timelineBoundaryWasAlreadyHit = true;
          _timelineBoundaryAtBottom = swipingUp; // true = hit bottom going up
        }
      } else {
        // Not at boundary yet — inner scroll is still running, reset tracking
        _timelineBoundaryWasAlreadyHit = false;
      }
      return;
    }

    // All other pages: standard one-page snap
    _goToPage(swipingUp ? _currentPage + 1 : _currentPage - 1);
  }

  // ── Mouse wheel ─────────────────────────────────────────────────────────────

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || _isSnapping) return;

    _wheelAccumulated += event.scrollDelta.dy;
    const threshold = 80.0;

    if (_wheelFired) {
      if (event.scrollDelta.dy.abs() < 5) {
        _wheelFired = false;
        _wheelAccumulated = 0;
      }
      return;
    }

    if (_wheelAccumulated.abs() < threshold) return;

    _goToPage(_wheelAccumulated > 0 ? _currentPage + 1 : _currentPage - 1);
    _wheelFired = true;
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
                            // If the user scrolls back away from the boundary,
                            // reset the "already hit" flag so they have to
                            // reach the edge again before navigating.
                            if (!atTop && !atBottom) {
                              _timelineBoundaryWasAlreadyHit = false;
                            }
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

          NavBar(
            isScrolled: _currentPage > 0,
            currentPage: _currentPage,
            onCountdown: () => _goToPage(1),
            onGallery: () => _goToPage(2),
            onVideos: () => _goToPage(3),
            onTimeline: () => _goToPage(4),
            onLetter: () => _goToPage(5),
          ),

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