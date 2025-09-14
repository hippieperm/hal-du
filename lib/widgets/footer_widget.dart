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
      color: Colors.grey[900],
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
                      _buildQuickLinks(),
                      _buildSocialLinks(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompanyInfo(),
                      const SizedBox(height: 40),
                      _buildQuickLinks(),
                      const SizedBox(height: 40),
                      _buildSocialLinks(),
                    ],
                  ),
          ),

          const SizedBox(height: 40),

          // 구분선
          Container(width: double.infinity, height: 1, color: Colors.grey[700]),

          const SizedBox(height: 30),

          // 저작권 정보
          Text(
            'Copyright © 2024 할두 All rights reserved.',
            style: GoogleFonts.notoSans(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'haldo',
          style: GoogleFonts.notoSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.pink[400],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '건강한 인생 2막, 할두와 함께해요!',
          style: GoogleFonts.notoSans(fontSize: 16, color: Colors.grey[300]),
        ),
        const SizedBox(height: 5),
        Text(
          '할머니가 되어서도 두근두근 할두 haldo 있다!',
          style: GoogleFonts.notoSans(fontSize: 14, color: Colors.grey[400]),
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
        _buildContactItem('Corporate Name:', 'Haldo'),
        _buildContactItem('CEO:', 'Seulki Park'),
        _buildContactItem('E-MAIL:', 'team@haldo.kr'),
        _buildContactItem('TEL:', '010-9199-1452'),
        _buildContactItem('Business Registration No.:', '188-18-02055'),
        _buildContactItem('E-commerce Permit:', '2024-창원성산-0288'),
        _buildContactItem(
          'Address:',
          '59, Gaeumjeong-ro, Seongsan-gu, Changwon-si',
        ),
      ],
    );
  }

  Widget _buildContactItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        _buildLinkItem('이용약관'),
        _buildLinkItem('개인정보처리방침'),
        _buildLinkItem('할두 블로그'),
        _buildLinkItem('할두 카페'),
      ],
    );
  }

  Widget _buildLinkItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          // 링크 액션
        },
        child: Text(
          text,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: Colors.grey[300],
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow Us',
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildSocialIcon('haldo_daily', Icons.article),
            const SizedBox(width: 15),
            _buildSocialIcon('nadoc_nadoc', Icons.chat),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String name, IconData icon) {
    return GestureDetector(
      onTap: () async {
        // 소셜 미디어 링크 열기
        final url = Uri.parse('https://instagram.com/$name');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.pink[600],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
