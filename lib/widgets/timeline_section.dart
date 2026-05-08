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
  _Milestone('April 2026', '3rd meet-up together ',
      'We\'ve made a lot of happy memories together. So much fun and love.'),
  _Milestone('June 4, 2026', 'One whole year ♡',
      'Three hundred sixty-five days of choosing each other. Here\'s to forever feeling just like this.'),
];

class TimelineSection extends StatefulWidget {
  const TimelineSection({super.key});

  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _opacities;
  late List<Animation<Offset>> _offsets;

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

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height),
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
                    Color(0xFF251C18)
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Decorative vertical line
          if (!isMobile)
            Positioned(
              left: size.width / 2,
              top: 160,
              bottom: 40,
              child: Container(
                width: 0.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.gold.withOpacity(0.3),
                      AppColors.gold.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.1, 0.9, 1.0],
                  ),
                ),
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isMobile ? 72 : 80),

                // Label
                Text(
                  'HOW IT ALL BEGAN',
                  style: GoogleFonts.jost(
                    fontSize: 10,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 5.5,
                    color: AppColors.gold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Title
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: isMobile ? 36 : 48,
                      fontWeight: FontWeight.w300,
                      color: AppColors.cream,
                      height: 1.15,
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
                SizedBox(height: isMobile ? 36 : 44),

                // Timeline
                if (isMobile)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: size.height * 0.75,
                  ),
                  child: _mobileTimeline(),
                )
                else
                  Expanded(child: _desktopTimeline(size)),

                SizedBox(height: isMobile ? 40 : 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileTimeline() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      _dot(),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(child: _itemContent(m, TextAlign.left)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _desktopTimeline(Size size) {
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
          child: SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: isLeft
                  ? [
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 36),
                          child: _itemContent(m, TextAlign.right),
                        ),
                      )),
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
                          padding: const EdgeInsets.only(left: 36),
                          child: _itemContent(m, TextAlign.left),
                        ),
                      )),
                    ],
            ),
          ),
        );
      }),
    );
  }

  Widget _dot() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.rose,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.roseLight, width: 2),
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
            fontSize: 9.5,
            fontWeight: FontWeight.w200,
            letterSpacing: 3,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          m.title,
          textAlign: align,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: AppColors.cream,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          m.description,
          textAlign: align,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            color: AppColors.muted,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}