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
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

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

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));

    _animationController!.forward();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _animationController?.dispose();
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

    _animationController?.reverse().then((_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imagePaths.length;
        _dragOffset = 0.0; // Reset drag offset
      });
      _animationController?.forward();
    });
  }

  void _previousImage() async {
    if (_isDragging) return;

    _animationController?.reverse().then((_) {
      setState(() {
        _currentIndex = (_currentIndex - 1 + _imagePaths.length) % _imagePaths.length;
        _dragOffset = 0.0; // Reset drag offset
      });
      _animationController?.forward();
    });
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
              _animationController?.stop();
            },
            onPanUpdate: (details) {
              final deltaX = details.localPosition.dx - _dragStartX;
              final deltaY = details.localPosition.dy - _dragStartY;

              // Determine if this is a horizontal drag (30° threshold)
              if (!_isHorizontalDrag && !_isDragging) {
                final angle = math.atan2(deltaY.abs(), deltaX.abs()) * 180 / math.pi;
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
              if (velocity.abs() > 500 || _dragOffset.abs() > screenWidth * 0.3) {
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
                _animationController?.forward();
              }

              // Resume auto-slide
              _startAutoSlide();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Current image
                Transform.translate(
                  offset: Offset(_dragOffset, 0),
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

                // Next image (right side)
                if (_dragOffset < 0)
                  Transform.translate(
                    offset: Offset(MediaQuery.of(context).size.width + _dragOffset, 0),
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
                    offset: Offset(-MediaQuery.of(context).size.width + _dragOffset, 0),
                    child: Image.asset(
                      _imagePaths[(_currentIndex - 1 + _imagePaths.length) % _imagePaths.length],
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

                // Overlay gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 콘텐츠 오버레이
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 메인 타이틀
                Text(
                  '건강한 인생 2막, 할두와 함께 해요!',
                  style: GoogleFonts.notoSans(
                    fontSize: MediaQuery.of(context).size.width > 768 ? 48 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // 서브 타이틀
                Text(
                  '할머니가 되어서도 두근두근',
                  style: GoogleFonts.notoSans(
                    fontSize: MediaQuery.of(context).size.width > 768 ? 24 : 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.pink[200],
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 브랜드명
                Text(
                  '할두 haldo 있다!',
                  style: GoogleFonts.notoSans(
                    fontSize: MediaQuery.of(context).size.width > 768 ? 28 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[100],
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // CTA 버튼
                ElevatedButton(
                  onPressed: () {
                    // 액션 추가
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    '지금 시작하기',
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
