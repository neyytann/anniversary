import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class LetterSection extends StatelessWidget {
  const LetterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.3, 0.4),
                radius: 1.2,
                colors: [Color(0xFFF5EDE0), AppColors.parchment],
                stops: [0.0, 0.7],
              ),
            ),
          ),

          // Warm glow top-right
          Positioned(
            right: -40, top: -40,
            child: Container(
              width: size.width * 0.5,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.goldLight.withOpacity(0.22),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          // Content
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: 80,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Label
                  Text(
                    'FROM THE HEART',
                    style: GoogleFonts.jost(
                      fontSize: 10, fontWeight: FontWeight.w200,
                      letterSpacing: 5.5, color: AppColors.gold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),

                  // Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: isMobile ? 36 : 48,
                        fontWeight: FontWeight.w300,
                        color: AppColors.charcoal,
                        height: 1.15,
                      ),
                      children: const [
                        TextSpan(text: 'A '),
                        TextSpan(
                          text: 'love letter',
                          style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.rose),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Letter card
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Stack(
                      children: [
                        // Outer decorative borders
                        Positioned.fill(
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.gold.withOpacity(0.3), width: 0.5),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            margin: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.gold.withOpacity(0.15), width: 0.5),
                            ),
                          ),
                        ),

                        // Letter body
                        Container(
                          color: AppColors.cream,
                          padding: EdgeInsets.all(isMobile ? 36 : 56),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ornament
                              Center(
                                child: Text('❧',
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: AppColors.gold.withOpacity(0.35),
                                      height: 1,
                                    )),
                              ),
                              const SizedBox(height: 24),

                              // Salutation
                              Text('My dearest Frenzy,',
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: isMobile ? 22 : 27,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.roseDeep,
                                    height: 1.3,
                                  )),
                              const SizedBox(height: 26),

                              // Body
                              Text(
                                'A year ago, you walked into my life and quietly rearranged everything '
                                '— in the most beautiful way. Every ordinary day became extraordinary '
                                'because of you. Your laughter is the sound I look forward to most, '
                                'your presence the calm I always come home to.\n\n'
                                'In you, I found not just love, but a home. I found someone who makes '
                                'me want to be better, feel deeper, and dream bigger. Every moment with '
                                'you has been a gift I treasure more than words can hold.\n\n'
                                'Happy first anniversary, my love. Here\'s to every year that follows '
                                '— may they be even more wonderful than this one.',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: isMobile ? 15 : 17,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.charcoal,
                                  height: 2.0,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Closing
                              Text('Forever yours,',
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: isMobile ? 19 : 23,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.roseDeep,
                                    height: 1.5,
                                  )),
                              Text('Nathan',
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: isMobile ? 26 : 32,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.roseDeep,
                                    height: 1.3,
                                  )),
                            ],
                          ),
                        ),
                      ],
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
