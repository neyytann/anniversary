import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _petalController;
  final List<_PetalData> _petals = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _petalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    for (int i = 0; i < 20; i++) {
      _petals.add(_PetalData(
        x: _rng.nextDouble(),
        delay: _rng.nextDouble() * 12,
        duration: 8 + _rng.nextDouble() * 8,
        rotation: _rng.nextDouble() * 360,
        dx: (_rng.nextDouble() - 0.5) * 120,
        size: 4 + _rng.nextDouble() * 6,
      ));
    }
  }

  @override
  void dispose() {
    _petalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.4, 0.2),
          radius: 1.2,
          colors: [Color(0xFF4A2518), AppColors.charcoal],
          stops: [0.0, 0.65],
        ),
      ),
      child: Stack(
        children: [
          // Subtle secondary glow
          Positioned(
            right: 0, top: 0,
            child: Container(
              width: size.width * 0.6,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3A2810).withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Falling petals
          ..._petals.map((p) => _FallingPetal(
                data: p,
                screenHeight: size.height,
                screenWidth: size.width,
                controller: _petalController,
              )),

          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Eyebrow
                _FadeUp(
                  delay: 300,
                  child: Text(
                    'ONE BEAUTIFUL YEAR TOGETHER',
                    style: GoogleFonts.jost(
                      fontSize: 11,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 5.5,
                      color: AppColors.gold,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Names
                _FadeUp(
                  delay: 500,
                  child: Text(
                    'Nathan',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: size.width < 600 ? 72 : 110,
                      fontWeight: FontWeight.w300,
                      color: AppColors.cream,
                      height: 0.95,
                      letterSpacing: -1,
                    ),
                  ),
                ),

                _FadeUp(
                  delay: 620,
                  child: Text(
                    '& Frenzy',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: size.width < 600 ? 48 : 72,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      color: AppColors.roseLight,
                      height: 1.1,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Divider with heart
                _FadeUp(
                  delay: 750,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 80, height: 0.5, color: AppColors.gold.withOpacity(0.5)),
                      const SizedBox(width: 16),
                      Icon(Icons.favorite, color: AppColors.rose.withOpacity(0.7), size: 18),
                      const SizedBox(width: 16),
                      Container(width: 80, height: 0.5, color: AppColors.gold.withOpacity(0.5)),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Date
                _FadeUp(
                  delay: 900,
                  child: Text(
                    'JUNE 4, 2025  —  JUNE 4, 2026',
                    style: GoogleFonts.jost(
                      fontSize: 11,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4,
                      color: AppColors.goldLight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scroll indicator
          Positioned(
            bottom: 32, left: 0, right: 0,
            child: _FadeUp(
              delay: 1400,
              child: Column(
                children: [
                  Text(
                    'SCROLL',
                    style: GoogleFonts.jost(
                      fontSize: 9,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ScrollLine(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetalData {
  final double x, delay, duration, rotation, dx, size;
  _PetalData({
    required this.x,
    required this.delay,
    required this.duration,
    required this.rotation,
    required this.dx,
    required this.size,
  });
}

class _FallingPetal extends StatefulWidget {
  final _PetalData data;
  final double screenHeight, screenWidth;
  final AnimationController controller;

  const _FallingPetal({
    required this.data,
    required this.screenHeight,
    required this.screenWidth,
    required this.controller,
  });

  @override
  State<_FallingPetal> createState() => _FallingPetalState();
}

class _FallingPetalState extends State<_FallingPetal>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fall;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.data.duration * 1000).toInt()),
    );
    _fall = CurvedAnimation(parent: _ctrl, curve: Curves.linear);

    Future.delayed(
      Duration(milliseconds: (widget.data.delay * 1000).toInt()),
      () {
        if (mounted) _ctrl.repeat();
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fall,
      builder: (context, child) {
        final t = _fall.value;
        final y = -20 + (widget.screenHeight + 40) * t;
        final x = widget.data.x * widget.screenWidth +
            widget.data.dx * t;
        final rot = (widget.data.rotation + 180 * t) * pi / 180;
        final opacity = t < 0.05
            ? t / 0.05 * 0.5
            : t > 0.9
                ? (1 - t) / 0.1 * 0.3
                : 0.35;

        return Positioned(
          left: x,
          top: y,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: rot,
              child: Container(
                width: widget.data.size,
                height: widget.data.size * 2.2,
                decoration: BoxDecoration(
                  color: AppColors.roseLight.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FadeUp extends StatefulWidget {
  final Widget child;
  final int delay;
  const _FadeUp({required this.child, required this.delay});

  @override
  State<_FadeUp> createState() => _FadeUpState();
}

class _FadeUpState extends State<_FadeUp> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _offset = Tween(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
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
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

class _ScrollLine extends StatefulWidget {
  @override
  State<_ScrollLine> createState() => _ScrollLineState();
}

class _ScrollLineState extends State<_ScrollLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scale = Tween(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, _) => Container(
        width: 1,
        height: 40 * _scale.value,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.muted, Colors.transparent],
          ),
        ),
      ),
    );
  }
}
