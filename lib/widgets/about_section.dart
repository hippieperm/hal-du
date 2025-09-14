import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          // 섹션 타이틀
          Text(
            'ABOUT',
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

          // 콘텐츠
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Text(
                  '할두는 50대 이상의 여성들을 위한 건강한 라이프스타일 플랫폼입니다.',
                  style: GoogleFonts.notoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                Text(
                  '건강한 인생 2막을 위한 다양한 콘텐츠와 상품을 제공하여, 할머니가 되어서도 두근두근한 삶을 응원합니다.',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                // 특징 카드들
                if (MediaQuery.of(context).size.width > 768)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFeatureCard(
                        icon: Icons.favorite,
                        title: '건강한 라이프',
                        description: '건강한 생활 습관을 위한\n다양한 콘텐츠 제공',
                      ),
                      _buildFeatureCard(
                        icon: Icons.people,
                        title: '커뮤니티',
                        description: '같은 관심사를 가진\n사람들과 소통',
                      ),
                      _buildFeatureCard(
                        icon: Icons.shopping_bag,
                        title: '맞춤 상품',
                        description: '50대 이상을 위한\n특별한 상품들',
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildFeatureCard(
                        icon: Icons.favorite,
                        title: '건강한 라이프',
                        description: '건강한 생활 습관을 위한\n다양한 콘텐츠 제공',
                      ),
                      const SizedBox(height: 20),
                      _buildFeatureCard(
                        icon: Icons.people,
                        title: '커뮤니티',
                        description: '같은 관심사를 가진\n사람들과 소통',
                      ),
                      const SizedBox(height: 20),
                      _buildFeatureCard(
                        icon: Icons.shopping_bag,
                        title: '맞춤 상품',
                        description: '50대 이상을 위한\n특별한 상품들',
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.pink[600]),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
