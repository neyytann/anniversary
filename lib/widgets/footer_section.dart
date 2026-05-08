import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, 0.2),
                radius: 1.0,
                colors: [Color(0xFF3D2820), AppColors.charcoal],
                stops: [0.0, 0.65],
              ),
            ),
          ),

          // Ambient rose glow center
          Center(
            child: Container(
              width: size.width * 0.7,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.rose.withOpacity(0.06),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          // Corner ornament lines
          Positioned(left: 48, top: 48, child: _cornerBrace(false, false)),
          Positioned(right: 48, top: 48, child: _cornerBrace(true, false)),
          Positioned(left: 48, bottom: 48, child: _cornerBrace(false, true)),
          Positioned(right: 48, bottom: 48, child: _cornerBrace(true, true)),

          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Small label
                Text(
                  'WITH ALL MY HEART',
                  style: GoogleFonts.jost(
                    fontSize: 9, fontWeight: FontWeight.w200,
                    letterSpacing: 5, color: AppColors.gold.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Names — large
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: size.width < 480 ? 52 : 72,
                      fontWeight: FontWeight.w300,
                      color: AppColors.roseLight,
                      height: 1.1,
                    ),
                    children: const [
                      TextSpan(text: 'Nathan '),
                      TextSpan(
                        text: '&',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppColors.goldLight,
                        ),
                      ),
                      TextSpan(text: ' Frenzy'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Divider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 48, height: 0.5,
                        color: AppColors.muted.withOpacity(0.4)),
                    const SizedBox(width: 14),
                    Icon(Icons.favorite,
                        color: AppColors.rose.withOpacity(0.5), size: 14),
                    const SizedBox(width: 14),
                    Container(width: 48, height: 0.5,
                        color: AppColors.muted.withOpacity(0.4)),
                  ],
                ),
                const SizedBox(height: 24),

                // Date
                Text(
                  'JUNE 4, 2025  —  LIFETIME',
                  style: GoogleFonts.jost(
                    fontSize: 10, fontWeight: FontWeight.w200,
                    letterSpacing: 4.5, color: AppColors.muted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerBrace(bool flipH, bool flipV) {
    return Transform.scale(
      scaleX: flipH ? -1 : 1,
      scaleY: flipV ? -1 : 1,
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 28, height: 28,
        child: CustomPaint(painter: _CornerPainter()),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withOpacity(0.25)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }
  @override
  bool shouldRepaint(_) => false;
}
