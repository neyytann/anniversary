import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';

class LetterSection extends StatelessWidget {
  const LetterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isShort = size.height < 700;

    final topPad = size.height * 0.10;
    final hPad = isMobile ? 20.0 : 40.0;
    final cardPad = isMobile || isShort ? 20.0 : 44.0;
    final labelToTitle = isShort ? 8.0 : 16.0;
    final titleToCard = isShort ? 12.0 : 28.0;

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
            right: -40,
            top: -40,
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
          isMobile
              ? SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        hPad, topPad, hPad, size.height * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Label
                        Text(
                          'FROM THE HEART',
                          style: GoogleFonts.jost(
                            fontSize: 10,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 5.5,
                            color: AppColors.gold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: labelToTitle),

                        // Title
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: isShort ? 26.0 : 34.0,
                              fontWeight: FontWeight.w300,
                              color: AppColors.charcoal,
                              height: 1.15,
                            ),
                            children: const [
                              TextSpan(text: 'A '),
                              TextSpan(
                                text: 'love letter',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.rose),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: titleToCard),

                        // Mobile paper — shrink-wraps to content
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            border: Border.all(
                              color: AppColors.gold.withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          padding: EdgeInsets.all(cardPad),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Salutation
                              Text(
                                'My dearest Frenzy,',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: isShort ? 16.0 : 20.0,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.roseDeep,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: isShort ? 10 : 18),

                              // Body
                              Text(
                                'A year ago, you walked into my life and quietly rearranged everything '
                                '— in the most beautiful way. Every ordinary day became extraordinary '
                                'because of you. Your laughter is the sound I look forward to most, '
                                'your presence the calm I always come home to.\n\n'
                                'In you, I found not just love, but a home. I found someone who makes '
                                'me want to be better, feel deeper, and dream bigger. Every moment with '
                                'you has been a gift I treasure more than words can hold.\n\n'
                                'Happy first anniversary, my baby. Here\'s to every year that follows '
                                '— may they be even more wonderful than this one.',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: isShort ? 10.0 : 12.0,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.charcoal,
                                  height: isShort ? 1.55 : 1.9,
                                ),
                              ),
                              SizedBox(height: isShort ? 12 : 24),

                              // Closing
                              Text(
                                'Forever yours,',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: isShort ? 14.0 : 18.0,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.roseDeep,
                                  height: 1.4,
                                ),
                              ),
                              Text(
                                'Nathan',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: isShort ? 19.0 : 24.0,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.roseDeep,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.fromLTRB(
                      hPad, topPad, hPad, size.height * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Label
                      Text(
                        'FROM THE HEART',
                        style: GoogleFonts.jost(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3.5,
                          color: AppColors.gold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: labelToTitle),

                      // Title
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: isShort ? 34.0 : 46.0,
                            fontWeight: FontWeight.w300,
                            color: AppColors.charcoal,
                            height: 1.15,
                          ),
                          children: const [
                            TextSpan(text: 'A '),
                            TextSpan(
                              text: 'love letter',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.rose),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: titleToCard),

                      // Desktop letter card — Expanded to fill remaining space
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Stack(
                              children: [
                                // Outer decorative border
                                Positioned.fill(
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.gold.withOpacity(0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                // Inner decorative border
                                Positioned.fill(
                                  child: Container(
                                    margin: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            AppColors.gold.withOpacity(0.15),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),

                                // Letter body — scrollable ONLY inside the card
                                Positioned.fill(
                                  child: Container(
                                    color: AppColors.cream,
                                    padding: EdgeInsets.all(cardPad),
                                    child: SingleChildScrollView(
                                      physics:
                                          const ClampingScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Salutation
                                          Text(
                                            'My dearest Frenzy,',
                                            style:
                                                GoogleFonts.cormorantGaramond(
                                              fontSize:
                                                  isShort ? 19.0 : 25.0,
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.roseDeep,
                                              height: 1.3,
                                            ),
                                          ),
                                          SizedBox(
                                              height: isShort ? 10 : 18),

                                          // Body
                                          Text(
                                            'A year ago, you walked into my life and quietly rearranged everything '
                                            '— in the most beautiful way. Every ordinary day became extraordinary '
                                            'because of you. Your laughter is the sound I look forward to most, '
                                            'your presence I always wanna come home to.\n\n'
                                            'In you, I found not just love, but a home. I found someone who makes '
                                            'me want to be better, feel deeper, and dream bigger. Every moment with '
                                            'you has been a gift I treasure more than words can hold.\n\n'
                                            'Happy first anniversary, my baby. May our dreams come true, always choose '
                                            'love over hate, and stay together through lifetime. I always love you, my '
                                            'babyyy!',
                                            style:
                                                GoogleFonts.cormorantGaramond(
                                              fontSize:
                                                  isShort ? 11.0 : 13.0,
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.charcoal,
                                              height:
                                                  isShort ? 1.55 : 1.9,
                                            ),
                                          ),
                                          SizedBox(
                                              height: isShort ? 12 : 24),

                                          // Closing
                                          Text(
                                            'Forever yours,',
                                            style:
                                                GoogleFonts.cormorantGaramond(
                                              fontSize:
                                                  isShort ? 16.0 : 21.0,
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.roseDeep,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            'Nathan',
                                            style:
                                                GoogleFonts.cormorantGaramond(
                                              fontSize:
                                                  isShort ? 22.0 : 30.0,
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.roseDeep,
                                              height: 1.1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}