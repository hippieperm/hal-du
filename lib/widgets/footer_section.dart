import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      width: double.infinity,
      color: const Color(0xFF00C853), // 녹색 배경
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: isDesktop ? 60 : 40,
      ),
      child: Column(
        children: [
          // 메인 푸터 컨텐츠
          if (isDesktop)
            _buildDesktopFooter(context)
          else
            _buildMobileFooter(context),

          const SizedBox(height: 32),

          // 하단 링크 및 저작권
          _buildBottomSection(context, isDesktop),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 로고 섹션
        Expanded(
          flex: 2,
          child: _buildLogo(),
        ),

        const SizedBox(width: 80),

        // 회사 정보 섹션
        Expanded(
          flex: 3,
          child: _buildCompanyInfo(),
        ),

        const SizedBox(width: 80),

        // 소셜 미디어 섹션
        Expanded(
          flex: 2,
          child: _buildSocialMedia(),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 로고
        _buildLogo(),
        const SizedBox(height: 32),

        // 회사 정보
        _buildCompanyInfo(),
        const SizedBox(height: 32),

        // 소셜 미디어
        _buildSocialMedia(),
      ],
    );
  }

  Widget _buildLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 할두 로고
        Text(
          '할두',
          style: GoogleFonts.notoSans(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoText('Corporate Name: (주)PJY Seoul Park'),
        _buildInfoText('E-Mail: team@haldo.kr'),
        _buildInfoText('TEL: 010-9195-1452'),
        _buildInfoText('Business Registration No.: 168-18-02965'),
        _buildInfoText('E-commerce Permit: 2024-경기안산-0288'),
        _buildInfoText('Address: 59, Gaeumjeong-ro, Seongsan-gu, Changwon-si'),
      ],
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.notoSans(
          fontSize: 14,
          color: Colors.white.withValues(alpha: 0.9),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildSocialMedia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 소셜 미디어 버튼들
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildSocialButton(
              '인스타 팔로우',
              Icons.camera_alt,
              () => _launchUrl('https://instagram.com/haldo_official'),
            ),
            _buildSocialButton(
              '카카오톡 채널',
              Icons.chat_bubble,
              () => _launchUrl('https://pf.kakao.com/_dxfxnG'),
            ),
            _buildSocialButton(
              '할두 블로그',
              Icons.article,
              () => _launchUrl('https://blog.naver.com/haldo_official'),
            ),
            _buildSocialButton(
              '할두 카페',
              Icons.coffee,
              () => _launchUrl('https://cafe.naver.com/haldo'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, bool isDesktop) {
    return Column(
      children: [
        // 구분선
        Container(
          height: 1,
          color: Colors.white.withValues(alpha: 0.2),
        ),

        const SizedBox(height: 24),

        // 하단 링크 및 저작권
        if (isDesktop)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBottomLinks(),
              _buildCopyright(),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBottomLinks(),
              const SizedBox(height: 16),
              _buildCopyright(),
            ],
          ),
      ],
    );
  }

  Widget _buildBottomLinks() {
    return Row(
      children: [
        _buildBottomLink('이용약관'),
        const SizedBox(width: 24),
        _buildBottomLink('개인정보처리방침'),
      ],
    );
  }

  Widget _buildBottomLink(String text) {
    return GestureDetector(
      onTap: () {
        // 약관 페이지로 이동
      },
      child: Text(
        text,
        style: GoogleFonts.notoSans(
          fontSize: 12,
          color: Colors.white.withValues(alpha: 0.8),
          decoration: TextDecoration.underline,
          decorationColor: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildCopyright() {
    return Text(
      'Copyright © 2024 할두 All rights reserved.',
      style: GoogleFonts.notoSans(
        fontSize: 12,
        color: Colors.white.withValues(alpha: 0.7),
      ),
    );
  }
}