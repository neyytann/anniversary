import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class _Milestone {
  final String date, title, description;
  const _Milestone(this.date, this.title, this.description);
}

const _milestones = [
  _Milestone('June 5, 2025', 'The beginning',
      'The day everything changed — when two hearts decided to write a story together. The moment you said yes and we become official.'),
  _Milestone('December 2025', '1st meet-up and be together',
      'A very special date together — where every detour became a favorite memory and every laugh echoed a little longer.'),
  _Milestone('January 2026', '2nd time we met in your hometown.',
      'Since the first time feels short, I came back to see and bond with you again.'),
  _Milestone('April 2026', '3rd meet-up together',
      'We\'ve made a lot of happy memories together. So much fun and love.'),
  _Milestone('June 4, 2026', 'One whole year ♡',
      'Three hundred sixty-five days of choosing each other. Here\'s to forever feeling just like this.'),
];

class TimelineSection extends StatefulWidget {
  final void Function(bool atTop, bool atBottom)? onBoundaryChanged;
  const TimelineSection({super.key, this.onBoundaryChanged});

  @override
  State<TimelineSection> createState() => TimelineSectionState();
}

class TimelineSectionState extends State<TimelineSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _opacities;
  late List<Animation<Offset>> _offsets;

  final ScrollController _timelineScroll = ScrollController();

  // Track inner scroll boundaries
  bool _atTop = true;
  bool _atBottom = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    _opacities = List.generate(_milestones.length, (i) {
      final start = i * 0.18;
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, (start + 0.35).clamp(0, 1),
              curve: Curves.easeOut),
        ),
      );
    });

    _offsets = List.generate(_milestones.length, (i) {
      final start = i * 0.18;
      return Tween(begin: const Offset(0, 0.12), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, (start + 0.35).clamp(0, 1),
              curve: Curves.easeOut),
        ),
      );
    });

    _timelineScroll.addListener(_onInnerScroll);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  void _onInnerScroll() {
    if (!_timelineScroll.hasClients) return;
    final pos = _timelineScroll.position;
    final atTop = pos.pixels <= pos.minScrollExtent + 1;
    final atBottom = pos.pixels >= pos.maxScrollExtent - 1;

    if (atTop != _atTop || atBottom != _atBottom) {
      _atTop = atTop;
      _atBottom = atBottom;
      widget.onBoundaryChanged?.call(_atTop, _atBottom);
    }
  }

  @override
  void dispose() {
    _timelineScroll.removeListener(_onInnerScroll);
    _timelineScroll.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  /// Called by HomeScreen to decide if the parent should navigate to next/prev page.
  /// [swipingUp] = true means finger went up (→ trying to go to next page).
  ///
  /// Returns true (allow parent navigation) only when the inner list has
  /// already reached the relevant boundary:
  ///   • swiping up   → allow only if inner scroll is at the BOTTOM
  ///   • swiping down → allow only if inner scroll is at the TOP
  bool checkBoundaryAndShouldNavigate(bool swipingUp) {
    if (!_timelineScroll.hasClients) return true;
    final pos = _timelineScroll.position;

    // If content doesn't overflow (no scrolling needed), always allow navigation
    if (pos.maxScrollExtent <= 0) return true;

    if (swipingUp) {
      // Going to next page: only if we're already scrolled to the very bottom
      return pos.pixels >= pos.maxScrollExtent - 2;
    } else {
      // Going to previous page: only if we're already at the very top
      return pos.pixels <= pos.minScrollExtent + 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF332620),
                    AppColors.charcoal,
                    Color(0xFF251C18),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Decorative vertical line (desktop only)
          if (!isMobile)
            Positioned(
              left: size.width / 2,
              top: 160,
              bottom: 80,
              child: Container(
                width: 0.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.gold.withOpacity(0.35),
                      AppColors.gold.withOpacity(0.35),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.08, 0.92, 1.0],
                  ),
                ),
              ),
            ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 60,
                vertical: isMobile ? 20 : 40,
              ),
              child: Column(
                children: [
                  Text(
                    'HOW IT ALL BEGAN',
                    style: GoogleFonts.jost(
                      fontSize: 10,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 5.5,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: isMobile ? 36 : 54,
                        fontWeight: FontWeight.w300,
                        color: AppColors.cream,
                        height: 1.1,
                      ),
                      children: const [
                        TextSpan(text: 'Our '),
                        TextSpan(
                          text: 'story',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: AppColors.rose),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Timeline list
                  Expanded(
                    child: isMobile
                        ? _mobileTimeline()
                        : _desktopStaticTimeline(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mobile: scrollable list that hands off to parent at boundaries ──────────

  Widget _mobileTimeline() {
    return ScrollConfiguration(
      // Keep default bounce/glow but let our Listener in HomeScreen see events
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: SingleChildScrollView(
        controller: _timelineScroll,
        physics: const ClampingScrollPhysics(), // no bounce so boundary is clear
        child: Column(
          children: List.generate(_milestones.length, (i) {
            final m = _milestones[i];
            return AnimatedBuilder(
              animation: _ctrl,
              builder: (context, child) => FadeTransition(
                opacity: _opacities[i],
                child: SlideTransition(position: _offsets[i], child: child),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [const SizedBox(height: 6), _dot()]),
                    const SizedBox(width: 20),
                    Expanded(child: _itemContent(m, TextAlign.left)),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Desktop: static, no inner scroll needed ─────────────────────────────────

  Widget _desktopStaticTimeline() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_milestones.length, (i) {
        final m = _milestones[i];
        final isLeft = i.isEven;

        return AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) => FadeTransition(
            opacity: _opacities[i],
            child: SlideTransition(position: _offsets[i], child: child),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: isLeft
                ? [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 52),
                          child: _itemContent(m, TextAlign.right),
                        ),
                      ),
                    ),
                    _dot(),
                    const Expanded(child: SizedBox()),
                  ]
                : [
                    const Expanded(child: SizedBox()),
                    _dot(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 52),
                          child: _itemContent(m, TextAlign.left),
                        ),
                      ),
                    ),
                  ],
          ),
        );
      }),
    );
  }

  Widget _dot() {
    return Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(
        color: AppColors.rose,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.roseLight, width: 2.5),
      ),
    );
  }

  Widget _itemContent(_Milestone m, TextAlign align) {
    return Column(
      crossAxisAlignment: align == TextAlign.right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          m.date.toUpperCase(),
          textAlign: align,
          style: GoogleFonts.jost(
            fontSize: 10,
            fontWeight: FontWeight.w300,
            letterSpacing: 3.2,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          m.title,
          textAlign: align,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.cream,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          m.description,
          textAlign: align,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: AppColors.cream.withOpacity(0.8),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}