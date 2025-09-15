import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isTransparent;

  const AppBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.isTransparent = false,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool _isAboutHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 80,
      decoration: BoxDecoration(
        color: widget.isTransparent ? Colors.transparent : Colors.white,
        boxShadow: widget.isTransparent
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 로고
            Text(
              '할두',
              style: GoogleFonts.notoSans(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2ECC71), // 이미지의 초록색
              ),
            ),

            // 데스크톱 네비게이션
            if (MediaQuery.of(context).size.width > 768)
              Row(
                children: [
                  _buildAboutNavItem(),
                  const SizedBox(width: 40),
                  _buildNavItem('CONTENTS', 1),
                  const SizedBox(width: 40),
                  _buildNavItem('SHOP', 2),
                ],
              ),

            // 우측 버튼들
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    // 로그인 기능
                  },
                  child: Text(
                    '로그인',
                    style: GoogleFonts.notoSans(
                      color: widget.isTransparent
                          ? Colors.white.withValues(alpha: 0.9)
                          : Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // 회원가입 기능
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    '회원가입',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isTransparent
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: widget.isTransparent ? Colors.white : Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '0',
                        style: GoogleFonts.notoSans(
                          color:
                              widget.isTransparent ? Colors.white : Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // 모바일 메뉴 버튼
                if (MediaQuery.of(context).size.width <= 768)
                  IconButton(
                    onPressed: () {
                      // 모바일 메뉴 열기
                    },
                    icon: Icon(
                      Icons.menu,
                      color: widget.isTransparent ? Colors.white : Colors.grey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ABOUT 전용 네비게이션 아이템 (호버 효과 포함)
  Widget _buildAboutNavItem() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isAboutHovered = true),
      onExit: (_) => setState(() => _isAboutHovered = false),
      child: GestureDetector(
        onTap: () => widget.onItemTapped(0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _isAboutHovered ? '할두란?' : 'ABOUT',
            style: GoogleFonts.notoSans(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: _isAboutHovered
                  ? const Color(0xFF2ECC71) // 호버 시 지정된 녹색
                  : widget.isTransparent
                      ? (widget.selectedIndex == 0
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.9))
                      : (widget.selectedIndex == 0 ? Colors.pink[600] : Colors.grey[700]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    return GestureDetector(
      onTap: () => widget.onItemTapped(index),
      child: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: widget.isTransparent
              ? (widget.selectedIndex == index
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.9))
              : (widget.selectedIndex == index ? Colors.pink[600] : Colors.grey[700]),
        ),
      ),
    );
  }
}
