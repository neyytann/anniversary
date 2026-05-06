import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class GallerySection extends StatelessWidget {
  const GallerySection({super.key});

  static const _captions = [
    'Our first photo',
    'A quiet moment',
    'Adventures together',
    'Laughing all day',
    'Just us two',
    'Forever favorite',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 480;
    final crossCount = isMobile ? 2 : 3;

    // Calculate grid dimensions to fill screen nicely
    final hPad = isMobile ? 24.0 : 48.0;
    final vPad = isMobile ? 24.0 : 40.0;
    final spacing = 10.0;
    final availableWidth = size.width - hPad * 2;
    final cellWidth = (availableWidth - spacing * (crossCount - 1)) / crossCount;
    final rows = (_captions.length / crossCount).ceil();
    // Header area height estimate
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
          // Background
          Container(color: AppColors.cream),

          // Decorative diagonal texture lines (top-right)
          Positioned(
            right: 0, top: 0,
            child: CustomPaint(
              size: Size(size.width * 0.25, size.height * 0.3),
              painter: _DiagonalLinePainter(),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isMobile ? 60 : 70),

                // Label
                Text(
                  'OUR MOMENTS',
                  style: GoogleFonts.jost(
                    fontSize: 10, fontWeight: FontWeight.w200,
                    letterSpacing: 5.5, color: AppColors.gold,
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
                        text: 'gallery',
                        style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.rose),
                      ),
                      TextSpan(text: ' of us'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Grid — fills remaining space
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: cellWidth / clampedCellH,
                    ),
                    itemCount: _captions.length,
                    itemBuilder: (context, i) =>
                        _GalleryPlaceholder(caption: _captions[i]),
                  ),
                ),

                const SizedBox(height: 14),
                Text(
                  '✦  Photos coming soon  ✦',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.muted,
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
    for (double i = -size.height; i < size.width + size.height; i += 18) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class _GalleryPlaceholder extends StatefulWidget {
  final String caption;
  const _GalleryPlaceholder({required this.caption});

  @override
  State<_GalleryPlaceholder> createState() => _GalleryPlaceholderState();
}

class _GalleryPlaceholderState extends State<_GalleryPlaceholder> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFEDE4D6) : AppColors.parchment,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 0.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_camera_outlined,
                color: AppColors.gold.withOpacity(0.38), size: 28),
            const SizedBox(height: 10),
            Text(
              widget.caption,
              style: GoogleFonts.jost(
                fontSize: 9.5, fontWeight: FontWeight.w300,
                letterSpacing: 1.2, color: AppColors.muted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
