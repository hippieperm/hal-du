import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;

    return Column(
      children: [
        // Hero Section
        _buildHeroSection(context, isMobile),

        // Brand Story Section
        _buildBrandStorySection(context, isMobile),

        // Team Introduction Section
        _buildTeamSection(context, isMobile),

        // Company Values Section
        _buildValuesSection(context, isMobile),

        // Community Section
        _buildCommunitySection(context, isMobile),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      height: isMobile ? 300 : 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1564564321837-a57b7070ac4f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2076&q=80'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ABOUT 할두',
              style: GoogleFonts.notoSans(
                fontSize: isMobile ? 32 : 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '건강한 인생 2막을 위한 특별한 시작',
              style: GoogleFonts.notoSans(
                fontSize: isMobile ? 14 : 18,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandStorySection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: 20,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'haldo\'s story',
                  style: GoogleFonts.notoSans(
                    fontSize: isMobile ? 12 : 14,
                    color: const Color(0xFF00C853),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '대한민국 중년 여성의\n',
                        style: GoogleFonts.notoSans(
                          fontSize: isMobile ? 26 : 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: '건강한 인생 2막이 시작되는 곳',
                        style: GoogleFonts.notoSans(
                          fontSize: isMobile ? 26 : 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: Text(
                  '20대는 취업을 위해 공부를 하고, 30대는 결혼을\n40대는 육아에만 몰두합니다.',
                  style: GoogleFonts.notoSans(
                    fontSize: isMobile ? 15 : 17,
                    color: Colors.grey[600],
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  '그런데 50대는 뭘까요?',
                  style: GoogleFonts.notoSans(
                    fontSize: isMobile ? 15 : 17,
                    color: Colors.grey[600],
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '우리 할머니들은 여전히 자기만의 꿈을 꾸고 있고\n나답게 살고 싶어 하며, 두 번째의 인생도 행복하기를\n원합니다.',
                  style: GoogleFonts.notoSans(
                    fontSize: isMobile ? 15 : 17,
                    color: Colors.grey[600],
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  '할머니는 정말로 설레는 마음으로\n두번째의 인생을 새롭게\n살려고 마음을 단단히 쓰셨더군요.',
                  style: GoogleFonts.notoSans(
                    fontSize: isMobile ? 15 : 17,
                    color: Colors.grey[600],
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  '그런 할머니들을 볼 때마다 정말 어떻게 도움을 줄 수 있을까 많은 고민이 든다.',
                  style: GoogleFonts.notoSans(
                    fontSize: isMobile ? 15 : 17,
                    color: Colors.grey[600],
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: 20,
      ),
      color: Colors.grey[50],
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Column(
                children: [
                  _buildTeamContent(isMobile),
                  const SizedBox(height: 40),
                  _buildTeamImage(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamImage() {
    return Center(
      child: Container(
        height: 400,
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamContent(bool isMobile) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '할마니가 되어서도',
                style: GoogleFonts.notoSans(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00C853),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                '할두는 중년 여성들의 새로운 시작을 도와드립니다. 건강한 라이프스타일부터 취미, 경제적 독립까지 전방위적으로 지원하는 플랫폼입니다.',
                style: GoogleFonts.notoSans(
                  fontSize: isMobile ? 15 : 17,
                  color: Colors.grey[600],
                  height: 1.7,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 36),
            Center(child: _buildInfoBox('1. 건강 관리 ♡', '체계적인 건강 관리와 운동 프로그램을 통해 활기찬 일상을 만들어갑니다. 의료진과 함께하는 건강 상담도 제공합니다.')),
            const SizedBox(height: 16),
            Center(child: _buildInfoBox('2. 취미생활 홈스틸', '새로운 취미와 관심사를 발견하고 동호회 활동을 통해 새로운 인맥을 만나보세요.')),
            const SizedBox(height: 16),
            Center(child: _buildInfoBox('3. 창업, 부업 도전', '경험과 전문성을 바탕으로 한 창업이나 부업 기회를 제공하여 경제적 독립을 지원합니다.')),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String content) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                content,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValuesSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: 20,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Column(
                children: [
                  _buildValuesContent(isMobile),
                  const SizedBox(height: 40),
                  _buildValuesImage(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValuesContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.eco,
          size: 60,
          color: const Color(0xFF00C853),
        ),
        const SizedBox(height: 24),
        Text(
          '할두 haldo 있다!',
          style: GoogleFonts.notoSans(
            fontSize: isMobile ? 22 : 26,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '할두란 할머니들이 가지고 있는\n인생의 지혜와 경험을 바탕으로\n두번째 인생을 적극적으로 시작하다',
          style: GoogleFonts.notoSans(
            fontSize: isMobile ? 15 : 17,
            color: Colors.grey[600],
            height: 1.7,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildValuesImage() {
    return Center(
      child: Container(
        height: 300,
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCommunitySection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: 20,
      ),
      color: Colors.grey[50],
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Container(
                height: isMobile ? 200 : 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                '국내 최대 중년 여성 커뮤니티',
                style: GoogleFonts.notoSans(
                  fontSize: isMobile ? 22 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '30년 경력들이 이야기하고 있어요.🥰',
                style: GoogleFonts.notoSans(
                  fontSize: isMobile ? 19 : 23,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00C853),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                '전국의 중년 여성들이 할두에서 만나\n새로운 도전을 시작하고 서로의 경험을 나누며\n함께 성장하고 있습니다.',
                style: GoogleFonts.notoSans(
                  fontSize: isMobile ? 15 : 17,
                  color: Colors.grey[600],
                  height: 1.7,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                '할두와 함께 새로운 인생을 시작해보세요.\n여러분의 두 번째 젊음을 응원합니다.',
                style: GoogleFonts.notoSans(
                  fontSize: isMobile ? 15 : 17,
                  color: Colors.grey[600],
                  height: 1.7,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
