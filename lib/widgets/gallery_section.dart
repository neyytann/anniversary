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

  static const _photos = [
    'assets/images/bebe.jpg',
    'assets/images/bebe1.jpg',
    'assets/images/bebe2.jpg',
    'assets/images/bebe3.jpg',
    'assets/images/bebe4.jpg',
    'assets/images/bebe5.jpeg'
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
          Container(color: AppColors.cream),
          Positioned(
            right: 0,
            top: 0,
            child: CustomPaint(
              size: Size(size.width * 0.25, size.height * 0.3),
              painter: _GrainPainter(),
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
                      'OUR MOMENTS',
                      style: GoogleFonts.jost(
                        fontSize: 9,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 6,
                        color: AppColors.gold,
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
                          color: AppColors.charcoal,
                          height: 1.15,
                        ),
                        children: const [
                          TextSpan(text: 'A '),
                          TextSpan(
                            text: 'gallery',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: AppColors.rose),
                          ),
                          TextSpan(text: ' of us'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 40,
                      height: 0.5,
                      color: AppColors.gold.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: isMobile
                    ? _MobileGrid(
                        captions: _captions,
                        photos: _photos,
                        size: size,
                      )
                    : _AutoScrollFilmstrip(
                        captions: _captions,
                        photos: _photos,
                        size: size,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 12),
                child: Text(
                  '✦  our moments  ✦',
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

// ─── Auto-scrolling filmstrip ────────────────────────────────────────────────

class _AutoScrollFilmstrip extends StatefulWidget {
  final List<String> captions;
  final List<String> photos;
  final Size size;

  const _AutoScrollFilmstrip({
    required this.captions,
    required this.photos,
    required this.size,
  });

  @override
  State<_AutoScrollFilmstrip> createState() =>
      _AutoScrollFilmstripState();
}

class _AutoScrollFilmstripState
    extends State<_AutoScrollFilmstrip> {
  late final ScrollController _scrollController;

  bool _hovered = false;
  bool _scrolling = false;

  static const double _spacing = 16.0;
  static const int _repeat = 20;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      if (!_scrollController.hasClients) return;

      final max =
          _scrollController.position.maxScrollExtent;

      // Start in middle for seamless loop
      _scrollController.jumpTo(max / 2);

      _autoScroll();
    });
  }

  void _autoScroll() async {
    if (_scrolling || !mounted) return;

    _scrolling = true;

    while (mounted) {
      // Pause only when hovering a card
      if (_hovered) {
        await Future.delayed(
          const Duration(milliseconds: 80),
        );
        continue;
      }

      if (!_scrollController.hasClients) break;

      final position = _scrollController.position;
      final current = _scrollController.offset;
      final max = position.maxScrollExtent;

      // Seamless reset
      if (current >= max - 200) {
        _scrollController.jumpTo(max / 2);
      } else {
        _scrollController.jumpTo(current + 1.2);
      }

      await Future.delayed(
        const Duration(milliseconds: 16),
      );
    }

    _scrolling = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardH = widget.size.height * 0.52;
    final cardW = cardH * 0.72;

    final count = widget.captions.length;

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(
          count * _repeat,
          (i) {
            final index = i % count;

            return Padding(
              padding: EdgeInsets.only(
                right: _spacing,
              ),
              child: _FilmCard(
                caption: widget.captions[index],
                photo: AssetImage(
                  widget.photos[index],
                ),
                width: cardW,
                height: cardH,
                index: index,
                isVideo: false,

                // Pause only on image hover
                onHoverStart: () {
                  _hovered = true;
                },

                onHoverEnd: () {
                  _hovered = false;
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Film Card ───────────────────────────────────────────────────────────────

class _FilmCard extends StatefulWidget {
  final String caption;
  final ImageProvider? photo;
  final double width;
  final double height;
  final int index;
  final bool isVideo;

  final VoidCallback? onHoverStart;
  final VoidCallback? onHoverEnd;

  const _FilmCard({
    required this.caption,
    required this.width,
    required this.height,
    required this.index,
    required this.isVideo,
    this.photo,
    this.onHoverStart,
    this.onHoverEnd,
  });

  @override
  State<_FilmCard> createState() => _FilmCardState();
}

class _FilmCardState extends State<_FilmCard> {
  bool _hovered = false;

  void _openPreview(BuildContext context) {
    if (widget.photo == null) return;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => _PhotoPreviewDialog(
        photo: widget.photo!,
        caption: widget.caption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPreview(context),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _hovered = true);
          widget.onHoverStart?.call();
        },
        onExit: (_) {
          setState(() => _hovered = false);
          widget.onHoverEnd?.call();
        },
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
              color: const Color(0xFF1A1210),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: _hovered
                    ? AppColors.gold.withOpacity(0.55)
                    : AppColors.gold.withOpacity(0.15),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    _hovered ? 0.6 : 0.35,
                  ),
                  blurRadius: _hovered ? 24 : 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _FilmPerforations(),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _FilmPerforations(),
                  ),

                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 22,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          widget.photo != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.gold
                                          .withOpacity(0.4),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Image(
                                    image: widget.photo!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  color: const Color(0xFF231B18),
                                  child: Icon(
                                    Icons.photo_camera_outlined,
                                    color: AppColors.gold
                                        .withOpacity(0.4),
                                    size: 26,
                                  ),
                                ),

                          AnimatedOpacity(
                            duration:
                                const Duration(milliseconds: 300),
                            opacity: _hovered ? 1.0 : 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.72),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.all(10),
                                    child: Text(
                                      widget.caption,
                                      style: GoogleFonts.jost(
                                        fontSize: 8.5,
                                        fontWeight:
                                            FontWeight.w300,
                                        letterSpacing: 1.8,
                                        color: AppColors.cream,
                                      ),
                                      textAlign:
                                          TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            top: 6,
                            right: 8,
                            child: Text(
                              '0${widget.index + 1}',
                              style: GoogleFonts.jost(
                                fontSize: 7,
                                fontWeight: FontWeight.w200,
                                letterSpacing: 1,
                                color: AppColors.gold
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
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

// ─── Photo Preview Dialog ────────────────────────────────────────────────────

class _PhotoPreviewDialog extends StatelessWidget {
  final ImageProvider photo;
  final String caption;

  const _PhotoPreviewDialog({required this.photo, required this.caption});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.88),
        body: GestureDetector(
          onTap: () {},
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.88,
                    maxHeight: MediaQuery.of(context).size.height * 0.72,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Image(image: photo, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  caption,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.4,
                    color: AppColors.cream.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 30,
                  height: 0.5,
                  color: AppColors.gold.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Film Card ───────────────────────────────────────────────────────────────

class _FilmPerforations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          6,
          (_) => Container(
            width: 10,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFF0E0A08),
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Mobile grid layout ──────────────────────────────────────────────────────

class _MobileGrid extends StatelessWidget {
  final List<String> captions;
  final List<String> photos;
  final Size size;

  const _MobileGrid({
    required this.captions,
    required this.photos,
    required this.size,
  });

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
        itemBuilder: (context, i) => _MobileCard(
          caption: captions[i],
          photo: AssetImage(photos[i]),
          isVideo: false,
        ),
      ),
    );
  }
}

class _MobileCard extends StatefulWidget {
  final String caption;
  final ImageProvider? photo;
  final bool isVideo;

  const _MobileCard({
    required this.caption,
    required this.isVideo,
    this.photo,
  });

  @override
  State<_MobileCard> createState() => _MobileCardState();
}

class _MobileCardState extends State<_MobileCard> {
  bool _pressed = false;

  void _openPreview(BuildContext context) {
    if (widget.photo == null) return;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => _PhotoPreviewDialog(
        photo: widget.photo!,
        caption: widget.caption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPreview(context),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: const Color(0xFF231B18),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: AppColors.gold.withOpacity(
                _pressed ? 0.5 : 0.18,
              ),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  _pressed ? 0.35 : 0.18,
                ),
                blurRadius: _pressed ? 14 : 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                widget.photo != null
                    ? Image(
                        image: widget.photo!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: const Color(0xFF231B18),
                        child: Icon(
                          widget.isVideo
                              ? Icons.play_arrow_rounded
                              : Icons.photo_camera_outlined,
                          color: AppColors.gold.withOpacity(0.4),
                          size: 24,
                        ),
                      ),

                // Dark gradient overlay
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _pressed ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.72),
                        ],
                      ),
                    ),
                  ),
                ),

                // Caption
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _pressed ? 1.0 : 0.0,
                    child: Text(
                      widget.caption,
                      style: GoogleFonts.jost(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.3,
                        color: AppColors.cream,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      ..color = AppColors.gold.withOpacity(0.025)
      ..strokeWidth = 0.3;
    for (double i = -size.height; i < size.width + size.height; i += 22) {
      canvas.drawLine(
          Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}