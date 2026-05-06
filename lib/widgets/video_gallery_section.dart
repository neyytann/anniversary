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
    final crossCount = isMobile ? 2 : 3;

    final hPad = isMobile ? 24.0 : 48.0;
    final vPad = isMobile ? 24.0 : 40.0;
    final spacing = 10.0;
    final availableWidth = size.width - hPad * 2;
    final cellWidth =
        (availableWidth - spacing * (crossCount - 1)) / crossCount;
    final rows = (_captions.length / crossCount).ceil();
    final headerH = isMobile ? 140.0 : 160.0;
    final footerH = 48.0;
    final availGridH = size.height - headerH - footerH - vPad * 2;
    final cellHeight = (availGridH - spacing * (rows - 1)) / rows;
    final clampedCellH = cellHeight.clamp(cellWidth * 0.75, cellWidth * 1.4);

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
          // Background — slightly deeper than gallery to differentiate
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.4, 0.3),
                radius: 1.2,
                colors: [Color(0xFFEDE3D5), AppColors.parchment],
                stops: [0.0, 0.8],
              ),
            ),
          ),

          // Decorative diagonal texture lines (top-left mirror of gallery)
          Positioned(
            left: 0,
            top: 0,
            child: CustomPaint(
              size: Size(size.width * 0.25, size.height * 0.3),
              painter: _DiagonalLinePainter(),
            ),
          ),

          // Content
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isMobile ? 60 : 70),

                // Label
                Text(
                  'OUR MEMORIES IN MOTION',
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
                      fontSize: isMobile ? 34 : 46,
                      fontWeight: FontWeight.w300,
                      color: AppColors.charcoal,
                      height: 1.15,
                    ),
                    children: const [
                      TextSpan(text: 'A '),
                      TextSpan(
                        text: 'film',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: AppColors.rose),
                      ),
                      TextSpan(text: ' of us'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Grid
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: cellWidth / clampedCellH,
                    ),
                    itemCount: _captions.length,
                    itemBuilder: (context, i) =>
                        _VideoPlaceholder(caption: _captions[i]),
                  ),
                ),

                const SizedBox(height: 14),
                Text(
                  '✦  Videos coming soon  ✦',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.muted,
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
}

class _DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withOpacity(0.07)
      ..strokeWidth = 0.5;
    for (double i = -size.height;
        i < size.width + size.height;
        i += 18) {
      canvas.drawLine(
          Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _VideoPlaceholder extends StatefulWidget {
  final String caption;
  const _VideoPlaceholder({required this.caption});

  @override
  State<_VideoPlaceholder> createState() => _VideoPlaceholderState();
}

class _VideoPlaceholderState extends State<_VideoPlaceholder> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        decoration: BoxDecoration(
          color: _hovered
              ? const Color(0xFFEDE4D6)
              : AppColors.parchment,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
              color: AppColors.gold.withOpacity(0.4), width: 0.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play button circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.rose
                      .withOpacity(_hovered ? 0.7 : 0.35),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color:
                    AppColors.rose.withOpacity(_hovered ? 0.8 : 0.38),
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.caption,
              style: GoogleFonts.jost(
                fontSize: 9.5,
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