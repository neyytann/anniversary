import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class VideoGallerySection extends StatelessWidget {
  const VideoGallerySection({super.key});

  static const _captions = [
    'Our first video',
    'A stolen moment',
    'Dancing together',
    'Road trip laughs',
    'Just being us',
    'Forever on film',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 480;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
          // Dark moody background — slightly cooler tint vs gallery
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFD4C4B0),
                  Color(0xFFC8B69E),
                  Color(0xFFDDCDB8),
                ],
              ),
            ),
          ),

          // Grain overlay
          Positioned.fill(
            child: CustomPaint(painter: _GrainPainter()),
          ),

          // Rose vignette glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.1,
                  colors: [
                    AppColors.rose.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          Column(
            children: [
              SizedBox(height: isMobile ? 80 : 90),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 60),
                child: Column(
                  children: [
                    Text(
                      'OUR MEMORIES IN MOTION',
                      style: GoogleFonts.jost(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 6,
                        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 30 : 42,
                          fontWeight: FontWeight.w300,
                          color: AppColors.cream,
                          height: 1.15,
                        ),
                        children: const [
                          TextSpan(text: 'A '),
                          TextSpan(
                            text: 'film',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color.fromARGB(255, 187, 73, 12)),
                          ),
                          TextSpan(text: ' of us'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 40,
                      height: 0.5,
                      color: AppColors.rose.withOpacity(0.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Filmstrip (desktop) or Grid (mobile)
              Expanded(
                child: isMobile
                    ? _MobileGrid(captions: _captions, size: size)
                    : _FilmstripRow(captions: _captions, size: size, isVideo: true),
              ),

              // Footer label
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 12),
                child: Text(
                  '✦  videos coming soon  ✦',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: AppColors.muted.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Filmstrip layout for desktop ───────────────────────────────────────────

class _FilmstripRow extends StatelessWidget {
  final List<String> captions;
  final Size size;
  final bool isVideo;

  const _FilmstripRow({
    required this.captions,
    required this.size,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    final cardH = size.height * 0.52;
    final cardW = cardH * 0.72;
    final spacing = 16.0;
    final totalW = cardW * captions.length + spacing * (captions.length - 1);
    final sidePad = ((size.width - totalW) / 2).clamp(40.0, double.infinity);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: sidePad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(captions.length, (i) {
          final isMiddle = i == captions.length ~/ 2 || i == captions.length ~/ 2 - 1;
          return Padding(
            padding: EdgeInsets.only(right: i < captions.length - 1 ? spacing : 0),
            child: _FilmCard(
              caption: captions[i],
              width: cardW,
              height: isMiddle ? cardH * 1.06 : cardH,
              index: i,
              isVideo: isVideo,
            ),
          );
        }),
      ),
    );
  }
}

class _FilmCard extends StatefulWidget {
  final String caption;
  final double width;
  final double height;
  final int index;
  final bool isVideo;

  const _FilmCard({
    required this.caption,
    required this.width,
    required this.height,
    required this.index,
    required this.isVideo,
  });

  @override
  State<_FilmCard> createState() => _FilmCardState();
}

class _FilmCardState extends State<_FilmCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: widget.width,
        height: _hovered ? widget.height * 1.04 : widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF161214),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: _hovered
                ? AppColors.rose.withOpacity(0.55)
                : AppColors.rose.withOpacity(0.12),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.65 : 0.4),
              blurRadius: _hovered ? 28 : 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Stack(
            children: [
              // Film perforations top
              Positioned(
                top: 0, left: 0, right: 0,
                child: _FilmPerforations(),
              ),
              // Film perforations bottom
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _FilmPerforations(),
              ),

              // Main placeholder area
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Container(
                    color: const Color(0xFF1E1820),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _hovered ? 1.0 : 0.4,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.rose.withOpacity(0.8),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: AppColors.rose.withOpacity(0.9),
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _hovered ? 1.0 : 0.35,
                          child: Text(
                            widget.caption,
                            style: GoogleFonts.jost(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.8,
                              color: AppColors.cream,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '0${widget.index + 1}',
                          style: GoogleFonts.jost(
                            fontSize: 7,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1,
                            color: AppColors.rose.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilmPerforations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (_) => Container(
          width: 10,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFF0A080C),
            borderRadius: BorderRadius.circular(1.5),
          ),
        )),
      ),
    );
  }
}

// ─── Mobile grid layout ──────────────────────────────────────────────────────

class _MobileGrid extends StatelessWidget {
  final List<String> captions;
  final Size size;

  const _MobileGrid({required this.captions, required this.size});

  @override
  Widget build(BuildContext context) {
    final spacing = 8.0;
    final hPad = 24.0;
    final cellW = (size.width - hPad * 2 - spacing) / 2;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: cellW / ((size.height - 320) / 3),
        ),
        itemCount: captions.length,
        itemBuilder: (context, i) => _MobileCard(caption: captions[i]),
      ),
    );
  }
}

class _MobileCard extends StatefulWidget {
  final String caption;
  const _MobileCard({required this.caption});

  @override
  State<_MobileCard> createState() => _MobileCardState();
}

class _MobileCardState extends State<_MobileCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _pressed ? const Color(0xFF2A1F24) : const Color(0xFF1E1820),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: AppColors.rose.withOpacity(_pressed ? 0.5 : 0.18),
            width: 0.8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.rose.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Icon(Icons.play_arrow_rounded,
                  color: AppColors.rose.withOpacity(0.6), size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              widget.caption,
              style: GoogleFonts.jost(
                fontSize: 8,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.2,
                color: AppColors.muted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grain texture painter ───────────────────────────────────────────────────

class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.rose.withOpacity(0.02)
      ..strokeWidth = 0.3;
    for (double i = -size.height; i < size.width + size.height; i += 22) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}