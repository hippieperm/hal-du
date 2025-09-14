import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 로고
            Text(
              '할두',
              style: GoogleFonts.notoSans(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2ECC71), // 이미지의 초록색
              ),
            ),

            // 데스크톱 네비게이션
            if (MediaQuery.of(context).size.width > 768)
              Row(
                children: [
                  _buildNavItem('ABOUT', 0),
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
                      color: Colors.grey[700],
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
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '0',
                        style: GoogleFonts.notoSans(
                          color: Colors.grey[700],
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
                    icon: const Icon(Icons.menu, color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: selectedIndex == index
              ? FontWeight.bold
              : FontWeight.normal,
          color: selectedIndex == index ? Colors.pink[600] : Colors.grey[700],
        ),
      ),
    );
  }
}
