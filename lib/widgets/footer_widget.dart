import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: const Color(0xFF00C853), // 밝은 녹색 배경
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: MediaQuery.of(context).size.width > 768
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCompanyInfo(),
                      _buildSocialLinks(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompanyInfo(),
                      const SizedBox(height: 40),
                      _buildSocialLinks(),
                    ],
                  ),
          ),

          const SizedBox(height: 40),

          // 하단 법적 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  '이용약관',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: () {},
                child: Text(
                  '개인정보처리방침',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 저작권 정보
          Text(
            'Copyright © 2024 일두 All rights reserved.',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 할두 로고 (세로로 배치)
        Text(
          '할두',
          style: GoogleFonts.notoSans(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 0.9,
          ),
        ),
        const SizedBox(height: 20),
        _buildContactInfo(),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactItem('Corporate Name: Haldo | CEO: Seulki Park'),
        _buildContactItem('E-MAIL: team@haldo.kr'),
        _buildContactItem('TEL: 010-9199-1452'),
        _buildContactItem('Business Registration No.: 188-18-02055'),
        _buildContactItem('E-commerce Permit: 2024-창원성산-0288'),
        _buildContactItem(
            'Address: 59, Gaeumjeong-ro, Seongsan-gu, Changwon-si'),
      ],
    );
  }

  Widget _buildContactItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.notoSans(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2x2 그리드로 소셜 링크 배치
        Column(
          children: [
            Row(
              children: [
                _buildSocialButton('haldo_daily', Icons.camera_alt),
                const SizedBox(width: 15),
                _buildSocialButton('nadoc_nadoc', Icons.camera_alt),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildSocialButton('할두 블로그', Icons.eco),
                const SizedBox(width: 15),
                _buildSocialButton('할두 카페', Icons.local_cafe),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String name, IconData icon) {
    return GestureDetector(
      onTap: () async {
        // 소셜 미디어 링크 열기
        String url = '';
        if (name.contains('haldo_daily') || name.contains('nadoc_nadoc')) {
          url = 'https://instagram.com/$name';
        } else if (name.contains('블로그')) {
          url = 'https://blog.naver.com/haldo';
        } else if (name.contains('카페')) {
          url = 'https://cafe.naver.com/haldo';
        }

        if (url.isNotEmpty) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF00C853), size: 16),
            const SizedBox(width: 8),
            Text(
              name,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
