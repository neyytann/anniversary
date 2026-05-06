import 'dart:async';
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
    if (mounted) setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
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

          // Main content centered
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Label
                  Text(
                    'MARK YOUR CALENDAR',
                    style: GoogleFonts.jost(
                      fontSize: 10,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 5.5,
                      color: AppColors.gold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),

                  // Title
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
                          style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.rose),
                        ),
                        TextSpan(text: '\nis coming'),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 48 : 68),

                  // Countdown units row
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

                  // Date pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 0.5),
                    ),
                    child: Text(
                      'JUNE  4,  2026',
                      style: GoogleFonts.jost(
                        fontSize: 11,
                        fontWeight: FontWeight.w200,
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

class _CountUnit extends StatelessWidget {
  final String value;
  final String label;
  final bool isMobile;
  const _CountUnit({required this.value, required this.label, required this.isMobile});

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
              fontWeight: FontWeight.w200,
              letterSpacing: 3,
              color: AppColors.muted,
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
