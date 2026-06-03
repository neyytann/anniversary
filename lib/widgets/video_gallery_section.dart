import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';
import 'package:video_player/video_player.dart';

class VideoGallerySection extends StatefulWidget {
  const VideoGallerySection({super.key});

  @override
  State<VideoGallerySection> createState() => _VideoGallerySectionState();
}

class _VideoGallerySectionState extends State<VideoGallerySection> {
  bool _isFullscreen = false;
  VideoPlayerController? _sharedController;

  void _onFullscreenOpen(VideoPlayerController controller) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (mounted) {
      setState(() {
        _isFullscreen = true;
        _sharedController = controller;
      });
    }
  }

  void _onFullscreenClose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (mounted) {
      setState(() {
        _isFullscreen = false;
        _sharedController = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 480;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
          // ── Background ─────────────────────────────────────────────────────
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
          Positioned.fill(child: CustomPaint(painter: _GrainPainter())),
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

          // ── Main content ───────────────────────────────────────────────────
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
                              color: Color.fromARGB(255, 187, 73, 12),
                            ),
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
                    width: isMobile ? size.width * 0.85 : size.width * 0.60,
                    height: isMobile ? size.height * 0.65 : size.height * 0.65,
                    onFullscreenOpen: _onFullscreenOpen,
                    // Tell the card to hide its VideoPlayer while overlay is up
                    isFullscreenActive: _isFullscreen,
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

          // ── Dim backdrop behind overlay ────────────────────────────────────
          if (_isFullscreen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _onFullscreenClose,
                child: Container(color: Colors.black.withOpacity(0.55)),
              ),
            ),

          // ── Fullscreen overlay — 85% of screen, centered ──────────────────
          if (_isFullscreen && _sharedController != null)
            Positioned(
              left: size.width * 0.075,
              right: size.width * 0.075,
              top: size.height * 0.075,
              bottom: size.height * 0.075,
              child: _FullscreenOverlay(
                controller: _sharedController!,
                onClose: _onFullscreenClose,
              ),
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
  final bool isFullscreenActive;
  final void Function(VideoPlayerController) onFullscreenOpen;

  const _SingleFilmCard({
    required this.caption,
    required this.width,
    required this.height,
    required this.onFullscreenOpen,
    required this.isFullscreenActive,
  });

  @override
  State<_SingleFilmCard> createState() => _SingleFilmCardState();
}

class _SingleFilmCardState extends State<_SingleFilmCard> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/anniversary.mp4')
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
      });

    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    // Sync playing state (e.g. changed while fullscreen was open)
    final isPlaying = _controller.value.isPlaying;
    if (_playing != isPlaying) {
      setState(() => _playing = isPlaying);
    }
    // Auto-reset at end
    if (_controller.value.position >= _controller.value.duration &&
        _controller.value.duration > Duration.zero) {
      setState(() => _playing = false);
      _controller.seekTo(Duration.zero);
    }
  }

  @override
  void didUpdateWidget(_SingleFilmCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fullscreen just closed — sync playing state from controller
    if (oldWidget.isFullscreenActive && !widget.isFullscreenActive) {
      setState(() => _playing = _controller.value.isPlaying);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_playing) {
        _controller.pause();
        _playing = false;
      } else {
        _controller.play();
        _playing = true;
      }
    });
  }

  void _openFullscreen() {
    widget.onFullscreenOpen(_controller);
  }

  @override
  Widget build(BuildContext context) {
    // When fullscreen overlay is active, hide the VideoPlayer widget in the
    // card so the texture is exclusively owned by the overlay. Replace it with
    // a solid black placeholder that looks identical to the video frame.
    final bool hideVideo = widget.isFullscreenActive;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161214),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: AppColors.rose.withOpacity(0.12),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Stack(
            children: [
              Positioned(top: 0, left: 0, right: 0, child: _FilmPerforations()),
              Positioned(bottom: 0, left: 0, right: 0, child: _FilmPerforations()),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: _initialized
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            // ── Video or black placeholder ──────────────────
                            if (!hideVideo)
                              GestureDetector(
                                onTap: _togglePlay,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _controller.value.size.width,
                                    height: _controller.value.size.height,
                                    child: VideoPlayer(_controller),
                                  ),
                                ),
                              )
                            else
                              // Placeholder shown while overlay owns the texture
                              Container(color: Colors.black),

                            // ── Play overlay ────────────────────────────────
                            if (!hideVideo)
                              GestureDetector(
                                onTap: _togglePlay,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 250),
                                  opacity: !_playing ? 1.0 : 0.0,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.35),
                                    child: Center(
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.rose.withOpacity(0.85),
                                            width: 1,
                                          ),
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: AppColors.rose.withOpacity(0.95),
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // ── Caption ─────────────────────────────────────
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    widget.caption,
                                    style: GoogleFonts.jost(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 2.2,
                                      color: AppColors.cream.withOpacity(0.8),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '01',
                                    style: GoogleFonts.jost(
                                      fontSize: 7,
                                      fontWeight: FontWeight.w200,
                                      letterSpacing: 1,
                                      color: AppColors.rose.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ── Fullscreen button ───────────────────────────
                            Positioned(
                              bottom: 6,
                              right: 8,
                              child: GestureDetector(
                                onTap: _openFullscreen,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.45),
                                    border: Border.all(
                                      color: AppColors.rose.withOpacity(0.4),
                                      width: 0.6,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.fullscreen_rounded,
                                    color: AppColors.rose.withOpacity(0.85),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),

                            // ── Progress bar ────────────────────────────────
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: false,
                                colors: VideoProgressColors(
                                  playedColor: AppColors.rose.withOpacity(0.8),
                                  bufferedColor: AppColors.rose.withOpacity(0.2),
                                  backgroundColor: Colors.white.withOpacity(0.1),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white38,
                            strokeWidth: 1,
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

// ─── Fullscreen Overlay ───────────────────────────────────────────────────────

class _FullscreenOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onClose;

  const _FullscreenOverlay({
    required this.controller,
    required this.onClose,
  });

  @override
  State<_FullscreenOverlay> createState() => _FullscreenOverlayState();
}

class _FullscreenOverlayState extends State<_FullscreenOverlay> {
  bool _playing = true;

  @override
  void initState() {
    super.initState();
    _playing = widget.controller.value.isPlaying;
    widget.controller.addListener(_syncState);
  }

  void _syncState() {
    if (!mounted) return;
    final isPlaying = widget.controller.value.isPlaying;
    if (_playing != isPlaying) {
      setState(() => _playing = isPlaying);
    }
    final c = widget.controller.value;
    if (c.duration > Duration.zero && c.position >= c.duration) {
      widget.controller.seekTo(Duration.zero);
      widget.controller.pause();
      if (mounted) setState(() => _playing = false);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncState);
    super.dispose();
  }

  void _togglePlay() {
    if (_playing) {
      widget.controller.pause();
    } else {
      widget.controller.play();
    }
    setState(() => _playing = !_playing);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video
            GestureDetector(
              onTap: _togglePlay,
              child: Center(
                child: AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  child: VideoPlayer(widget.controller),
                ),
              ),
            ),

            // Play icon when paused
            if (!_playing)
              Center(
                child: GestureDetector(
                  onTap: _togglePlay,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.45),
                      border: Border.all(
                        color: AppColors.rose.withOpacity(0.8),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.rose.withOpacity(0.95),
                      size: 38,
                    ),
                  ),
                ),
              ),

            // Exit fullscreen — top left
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.45),
                    border: Border.all(
                      color: AppColors.rose.withOpacity(0.3),
                      width: 0.6,
                    ),
                  ),
                  child: const Icon(
                    Icons.fullscreen_exit_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Scrubbable progress bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                widget.controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: AppColors.rose.withOpacity(0.8),
                  bufferedColor: AppColors.rose.withOpacity(0.2),
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Film perforations ────────────────────────────────────────────────────────

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
              color: const Color(0xFF0A080C),
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Grain texture painter ────────────────────────────────────────────────────

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