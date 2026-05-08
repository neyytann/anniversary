import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class NavBar extends StatelessWidget {
  final bool isScrolled;
  final int currentPage;
  final VoidCallback onCountdown;
  final VoidCallback onGallery;
  final VoidCallback onVideos;
  final VoidCallback onTimeline;
  final VoidCallback onLetter;

  const NavBar({
    super.key,
    required this.isScrolled,
    required this.currentPage,
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
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: MediaQuery.of(context).size.width < 600 ? 8 : 32,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavLink('Countdown', onCountdown, isActive: currentPage == 1),
                  _NavLink('Gallery', onGallery, isActive: currentPage == 2),
                  _NavLink('Videos', onVideos, isActive: currentPage == 3),
                  _NavLink('Timeline', onTimeline, isActive: currentPage == 4),
                  _NavLink('Letter', onLetter, isActive: currentPage == 5),
                ],
              ),
            ),
          ],
        ),
      ), 
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  const _NavLink(this.label, this.onTap, {this.isActive = false});

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
            fontSize: 10,
            fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w300,
            letterSpacing: 2.5,
            color: widget.isActive
                ? AppColors.gold
                : _hovered
                    ? AppColors.cream
                    : AppColors.cream.withOpacity(0.65),
            decoration: widget.isActive
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: AppColors.rose,
            decorationThickness: 2.0,
          ),
          child: Text(widget.label.toUpperCase()),
        ),
      ),
    );
  }
}