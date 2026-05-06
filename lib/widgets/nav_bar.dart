import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class NavBar extends StatelessWidget {
  final bool isScrolled;
  final VoidCallback onCountdown;
  final VoidCallback onGallery;
  final VoidCallback onVideos;
  final VoidCallback onTimeline;
  final VoidCallback onLetter;

  const NavBar({
    super.key,
    required this.isScrolled,
    required this.onCountdown,
    required this.onGallery,
    required this.onVideos,
    required this.onTimeline,
    required this.onLetter,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      color: isScrolled
          ? AppColors.charcoal.withOpacity(0.92)
          : Colors.transparent,
      padding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NavLink('Countdown', onCountdown),
            const SizedBox(width: 28),
            _NavLink('Gallery', onGallery),
            const SizedBox(width: 28),
            _NavLink('Videos', onVideos),
            const SizedBox(width: 28),
            _NavLink('Timeline', onTimeline),
            const SizedBox(width: 28),
            _NavLink('Letter', onLetter),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink(this.label, this.onTap);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.jost(
            fontSize: 11,
            fontWeight: FontWeight.w200,
            letterSpacing: 3.0,
            color: _hovered
                ? AppColors.gold
                : AppColors.cream.withOpacity(0.55),
          ),
          child: Text(widget.label.toUpperCase()),
        ),
      ),
    );
  }
}