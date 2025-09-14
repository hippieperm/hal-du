import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentsSection extends StatelessWidget {
  const ContentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.grey[50],
      child: Column(
        children: [
          // 섹션 타이틀
          Text(
            'CONTENTS',
            style: GoogleFonts.notoSans(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          const SizedBox(height: 20),

          // 구분선
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.pink[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 60),

          // 콘텐츠 그리드
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: MediaQuery.of(context).size.width > 768
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContentCard(
                        title: '건강 정보',
                        description: '50대 이상을 위한 건강 관리 팁과 정보를 제공합니다.',
                        icon: Icons.health_and_safety,
                        color: Colors.blue[100]!,
                        iconColor: Colors.blue[600]!,
                      ),
                      _buildContentCard(
                        title: '라이프스타일',
                        description: '활기찬 일상을 위한 다양한 라이프스타일 콘텐츠입니다.',
                        icon: Icons.spa,
                        color: Colors.green[100]!,
                        iconColor: Colors.green[600]!,
                      ),
                      _buildContentCard(
                        title: '커뮤니티',
                        description: '같은 관심사를 가진 사람들과 소통하고 정보를 공유하세요.',
                        icon: Icons.chat_bubble,
                        color: Colors.orange[100]!,
                        iconColor: Colors.orange[600]!,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildContentCard(
                        title: '건강 정보',
                        description: '50대 이상을 위한 건강 관리 팁과 정보를 제공합니다.',
                        icon: Icons.health_and_safety,
                        color: Colors.blue[100]!,
                        iconColor: Colors.blue[600]!,
                      ),
                      const SizedBox(height: 30),
                      _buildContentCard(
                        title: '라이프스타일',
                        description: '활기찬 일상을 위한 다양한 라이프스타일 콘텐츠입니다.',
                        icon: Icons.spa,
                        color: Colors.green[100]!,
                        iconColor: Colors.green[600]!,
                      ),
                      const SizedBox(height: 30),
                      _buildContentCard(
                        title: '커뮤니티',
                        description: '같은 관심사를 가진 사람들과 소통하고 정보를 공유하세요.',
                        icon: Icons.chat_bubble,
                        color: Colors.orange[100]!,
                        iconColor: Colors.orange[600]!,
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 60),

          // CTA 버튼
          ElevatedButton(
            onPressed: () {
              // 콘텐츠 보기 액션
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
            child: Text(
              '모든 콘텐츠 보기',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(icon, size: 40, color: iconColor),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
