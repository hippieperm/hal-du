import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late List<String> _imagePaths;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Drag functionality
  bool _isDragging = false;
  bool _isHorizontalDrag = false;
  double _dragStartX = 0.0;
  double _dragStartY = 0.0;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _imagePaths = [
      'assets/images/grandmother.jpg',
      'assets/images/grandmother.jpg',
      'assets/images/grandmother.jpg',
    ];

    // Initialize fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start with first image visible
    _fadeController.forward();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _nextImage();
        _startAutoSlide();
      }
    });
  }

  void _nextImage() async {
    if (_isDragging) return;

    // Fade out current image
    await _fadeController.reverse();

    // Change to next image
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      _dragOffset = 0.0; // Reset drag offset
    });

    // Fade in new image
    _fadeController.forward();
  }

  void _previousImage() async {
    if (_isDragging) return;

    // Fade out current image
    await _fadeController.reverse();

    // Change to previous image
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _imagePaths.length) % _imagePaths.length;
      _dragOffset = 0.0; // Reset drag offset
    });

    // Fade in new image
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Continuous sliding images with drag support
          GestureDetector(
            onPanStart: (details) {
              _dragStartX = details.localPosition.dx;
              _dragStartY = details.localPosition.dy;
              _dragOffset = 0.0;
              _isHorizontalDrag = false;
              // Pause fade animation during drag
              _fadeController.stop();
            },
            onPanUpdate: (details) {
              final deltaX = details.localPosition.dx - _dragStartX;
              final deltaY = details.localPosition.dy - _dragStartY;

              // Determine if this is a horizontal drag (30° threshold)
              if (!_isHorizontalDrag && !_isDragging) {
                final angle =
                    math.atan2(deltaY.abs(), deltaX.abs()) * 180 / math.pi;
                if (angle < 30) {
                  setState(() {
                    _isHorizontalDrag = true;
                    _isDragging = true;
                  });
                } else if (deltaY.abs() > 10) {
                  return; // Allow vertical scrolling
                }
              }

              // Update drag offset for continuous sliding
              if (_isHorizontalDrag && _isDragging) {
                setState(() {
                  _dragOffset = deltaX;
                });
              }
            },
            onPanEnd: (details) {
              if (!_isHorizontalDrag) return;

              final velocity = details.velocity.pixelsPerSecond.dx;
              final screenWidth = MediaQuery.of(context).size.width;

              setState(() {
                _isDragging = false;
                _isHorizontalDrag = false;
              });

              // Determine if we should change pages
              if (velocity.abs() > 500 ||
                  _dragOffset.abs() > screenWidth * 0.3) {
                if (velocity < 0 || _dragOffset < 0) {
                  // Swipe left - next image
                  _nextImage();
                } else {
                  // Swipe right - previous image
                  _previousImage();
                }
              } else {
                // Snap back to current image
                setState(() {
                  _dragOffset = 0.0;
                });
                // Resume fade animation if not at full opacity
                if (_fadeAnimation.value < 1.0) {
                  _fadeController.forward();
                }
              }

              // Resume auto-slide
              _startAutoSlide();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Current image with fade animation
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_dragOffset, 0),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Image.asset(
                          _imagePaths[_currentIndex],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white54,
                                  size: 50,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                // Next image (right side)
                if (_dragOffset < 0)
                  Transform.translate(
                    offset: Offset(
                        MediaQuery.of(context).size.width + _dragOffset, 0),
                    child: Image.asset(
                      _imagePaths[(_currentIndex + 1) % _imagePaths.length],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Previous image (left side)
                if (_dragOffset > 0)
                  Transform.translate(
                    offset: Offset(
                        -MediaQuery.of(context).size.width + _dragOffset, 0),
                    child: Image.asset(
                      _imagePaths[(_currentIndex - 1 + _imagePaths.length) %
                          _imagePaths.length],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Light overlay for better text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 콘텐츠 오버레이 - 슬라이드별 다른 텍스트
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentIndex == 2) ...[
                  // 3번째 슬라이드 - 특별한 텍스트
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // 첫 번째 줄: "할머니가 되어서도 두근두근"
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '할',
                                style: GoogleFonts.notoSans(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 768
                                          ? 48
                                          : 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00C853), // 밝은 녹색
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: '머니가 되어서도 ',
                                style: GoogleFonts.notoSans(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 768
                                          ? 48
                                          : 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 두 번째 줄: "할두 haldo 있다!"
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '두',
                                style: GoogleFonts.notoSans(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 768
                                          ? 48
                                          : 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00C853), // 밝은 녹색
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: '근두근 할두 ',
                                style: GoogleFonts.notoSans(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 768
                                          ? 48
                                          : 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: 'haldo ',
                                style: GoogleFonts.notoSans(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 768
                                          ? 48
                                          : 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00C853), // 밝은 녹색
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: '있다!',
                                style: GoogleFonts.notoSans(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 768
                                          ? 48
                                          : 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (_currentIndex != 1) ...[
                  // 1번째 슬라이드 - 기본 텍스트
                  Text(
                    'haldo',
                    style: GoogleFonts.inter(
                      fontSize:
                          MediaQuery.of(context).size.width > 768 ? 120 : 80,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF00C853), // 밝은 녹색
                      letterSpacing: -2,
                      height: 0.8,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // 메인 슬로건
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '건강한 인생 2막, 할두와 함께해요!',
                      style: GoogleFonts.notoSans(
                        fontSize:
                            MediaQuery.of(context).size.width > 768 ? 36 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 페이지 인디케이터
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _imagePaths.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: _currentIndex == index ? 50 : 12,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
