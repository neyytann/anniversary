import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class CountdownSection extends StatefulWidget {
  const CountdownSection({super.key});

  @override
  State<CountdownSection> createState() => _CountdownSectionState();
}

class _CountdownSectionState extends State<CountdownSection> {
  late Timer _timer;
  Duration _remaining = Duration.zero;
  bool _ended = false;
  static final _anniversary = DateTime(2026, 6, 4);

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  void _update() {
    final now = DateTime.now();
    final diff = _anniversary.difference(now);
    if (mounted) {
      setState(() {
        if (diff.isNegative) {
          _ended = true;
          _timer.cancel();
        } else {
          _remaining = diff;
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 480;
    final days  = _remaining.inDays;
    final hours = _remaining.inHours.remainder(24);
    final mins  = _remaining.inMinutes.remainder(60);
    final secs  = _remaining.inSeconds.remainder(60);

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.5, -0.3),
                radius: 1.3,
                colors: [Color(0xFFEDE4D6), AppColors.parchment],
                stops: [0.0, 0.75],
              ),
            ),
          ),

          // Ambient rose glow bottom-left
          Positioned(
            left: -80, bottom: -80,
            child: Container(
              width: size.width * 0.55,
              height: size.height * 0.45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.roseLight.withOpacity(0.2),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          // Corner frame lines
          Positioned(left: 48, top: 0, bottom: 0,
              child: Container(width: 0.5, color: AppColors.gold.withOpacity(0.13))),
          Positioned(right: 48, top: 0, bottom: 0,
              child: Container(width: 0.5, color: AppColors.gold.withOpacity(0.13))),
          Positioned(top: 48, left: 0, right: 0,
              child: Container(height: 0.5, color: AppColors.gold.withOpacity(0.13))),
          Positioned(bottom: 48, left: 0, right: 0,
              child: Container(height: 0.5, color: AppColors.gold.withOpacity(0.13))),

          // Floating hearts (only when ended)
          if (_ended) const _FloatingHeartsLayer(),

          // Main content centered
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Label + Title (hidden when ended)
                  if (!_ended) ...[
                    Text(
                      'MARK YOUR CALENDAR',
                      style: GoogleFonts.jost(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 5.5,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 36 : 50,
                          fontWeight: FontWeight.w300,
                          color: AppColors.charcoal,
                          height: 1.15,
                        ),
                        children: const [
                          TextSpan(text: 'Our '),
                          TextSpan(
                            text: 'first anniversary',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: AppColors.rose),
                          ),
                          TextSpan(text: '\nis coming'),
                        ],
                      ),
                    ),
                  ],

                  // Countdown or Celebration
                  if (_ended)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 48 : 68),
                      child: Column(
                        children: [
                          Text(
                            '♡',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: isMobile ? 48 : 64,
                              color: AppColors.rose,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Happy Anniversary!',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: isMobile ? 32 : 46,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                              color: AppColors.roseDeep,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'I love you so much, my baby!',
                            style: GoogleFonts.jost(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                              letterSpacing: 4,
                              color: AppColors.gold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else ...[
                    SizedBox(height: isMobile ? 48 : 68),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _CountUnit(value: _pad(days),  label: 'Days',    isMobile: isMobile),
                        _Dot(isMobile: isMobile),
                        _CountUnit(value: _pad(hours), label: 'Hours',   isMobile: isMobile),
                        _Dot(isMobile: isMobile),
                        _CountUnit(value: _pad(mins),  label: 'Minutes', isMobile: isMobile),
                        _Dot(isMobile: isMobile),
                        _CountUnit(value: _pad(secs),  label: 'Seconds', isMobile: isMobile),
                      ],
                    ),
                    SizedBox(height: isMobile ? 48 : 68),
                  ],

                  // Date pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.gold.withOpacity(0.7), width: 0.5),
                    ),
                    child: Text(
                      'JUNE  4,  2026',
                      style: GoogleFonts.jost(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 6,
                        color: AppColors.roseDeep,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Floating Hearts Layer ───────────────────────────────────────────────────

class _FloatingHeartsLayer extends StatefulWidget {
  const _FloatingHeartsLayer();

  @override
  State<_FloatingHeartsLayer> createState() => _FloatingHeartsLayerState();
}

class _FloatingHeartsLayerState extends State<_FloatingHeartsLayer> {
  final List<_HeartParticle> _hearts = [];
  Timer? _spawnTimer;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      if (mounted) {
        setState(() {
          _hearts.add(_HeartParticle(
            id: DateTime.now().microsecondsSinceEpoch,
            x: _rng.nextDouble(),
            size: 12 + _rng.nextDouble() * 18,
            duration: Duration(milliseconds: 3000 + _rng.nextInt(2000)),
            opacity: 0.4 + _rng.nextDouble() * 0.5,
            drift: (_rng.nextDouble() - 0.5) * 60,
          ));
          // Remove old hearts to avoid memory buildup
          if (_hearts.length > 20) _hearts.removeAt(0);
        });
      }
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _hearts.map((h) => _AnimatedHeart(particle: h)).toList(),
    );
  }
}

class _HeartParticle {
  final int id;
  final double x;
  final double size;
  final Duration duration;
  final double opacity;
  final double drift;

  const _HeartParticle({
    required this.id,
    required this.x,
    required this.size,
    required this.duration,
    required this.opacity,
    required this.drift,
  });
}

class _AnimatedHeart extends StatefulWidget {
  final _HeartParticle particle;
  const _AnimatedHeart({required this.particle});

  @override
  State<_AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<_AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rise;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.particle.duration);

    _rise = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _fade = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: widget.particle.opacity), weight: 15),
      TweenSequenceItem(tween: Tween(begin: widget.particle.opacity, end: widget.particle.opacity), weight: 65),
      TweenSequenceItem(tween: Tween(begin: widget.particle.opacity, end: 0.0), weight: 20),
    ]).animate(_ctrl);

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final bottom = _rise.value * (size.height + 60);
        final xPos = widget.particle.x * size.width +
            widget.particle.drift * _rise.value;

        return Positioned(
          left: xPos,
          bottom: bottom,
          child: Opacity(
            opacity: _fade.value.clamp(0.0, 1.0),
            child: Text(
              '♡',
              style: TextStyle(
                fontSize: widget.particle.size,
                color: AppColors.rose,
                height: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Count Unit ──────────────────────────────────────────────────────────────

class _CountUnit extends StatelessWidget {
  final String value;
  final String label;
  final bool isMobile;
  const _CountUnit(
      {required this.value, required this.label, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMobile ? 60 : 88,
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: isMobile ? 52 : 76,
              fontWeight: FontWeight.w300,
              color: AppColors.roseDeep,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.jost(
              fontSize: 8.5,
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
              color: const Color.fromARGB(255, 66, 62, 62),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isMobile;
  const _Dot({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 24 : 32),
      child: Text(
        '·',
        style: GoogleFonts.cormorantGaramond(
          fontSize: isMobile ? 36 : 52,
          fontWeight: FontWeight.w200,
          color: AppColors.gold,
          height: 1,
        ),
      ),
    );
  }
}