import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class VideoGallerySection extends StatelessWidget {
  const VideoGallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 480;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
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
          Positioned.fill(
            child: CustomPaint(painter: _GrainPainter()),
          ),
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
          Column(
            children: [
              SizedBox(height: isMobile ? 80 : 90),
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
              Expanded(
                child: Center(
                  child: _SingleFilmCard(
                    caption: 'Video of memories',

                    width: isMobile
                        ? size.width * 0.85        // mobile: stable width
                        : size.width * 0.60,       // desktop: wider card

                    height: isMobile
                        ? size.height * 0.65       // mobile: taller only
                        : size.height * 0.65,      // desktop: taller + more presence
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 12),
                child: Text(
                  '✦  our memories ✦',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
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

// ─── Single centered film card ───────────────────────────────────────────────

class _SingleFilmCard extends StatefulWidget {
  final String caption;
  final double width;
  final double height;

  const _SingleFilmCard({
    required this.caption,
    required this.width,
    required this.height,
  });

  @override
  State<_SingleFilmCard> createState() => _SingleFilmCardState();
}

class _SingleFilmCardState extends State<_SingleFilmCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _hovered = true),
        onTapUp: (_) => setState(() => _hovered = false),
        onTapCancel: () => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: widget.width,
            height: widget.height,
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
                  Positioned(
                    top: 0, left: 0, right: 0,
                    child: _FilmPerforations(),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: _FilmPerforations(),
                  ),
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
                                width: 48,
                                height: 48,
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
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _hovered ? 1.0 : 0.35,
                              child: Text(
                                widget.caption,
                                style: GoogleFonts.jost(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 2.2,
                                  color: AppColors.cream,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '01',
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