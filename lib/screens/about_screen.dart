import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isAppBarTransparent = _scrollController.offset < 50;
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // ABOUT 페이지는 현재 페이지이므로 아무것도 하지 않음
      return;
    } else if (index == 1) {
      // CONTENTS 페이지로 이동
      Navigator.pushReplacementNamed(context, '/contents');
    } else if (index == 2) {
      // SHOP 페이지로 이동
      Navigator.pushReplacementNamed(context, '/shop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 스크롤 가능한 콘텐츠
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(),
                _buildGrandmotherSection(),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 400,
                  ),
                  child: Column(
                    children: [
                      _buildHaldoStorySection(),
                      _buildHaldoHereSection(),
                      _buildCommunitySection(),
                    ],
                  ),
                ),
                const FooterWidget(),
              ],
            ),
          ),
          // 고정된 앱바
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarWidget(
              selectedIndex: 0, // ABOUT이 선택된 상태
              onItemTapped: _onItemTapped,
              isTransparent: _isAppBarTransparent,
              onLogoTapped: () {
                // 홈 화면으로 이동
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/grandmother.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 우측에 이미지 배치
            Positioned(
              top: 120,
              right: 60,
              child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/images/hero_image_2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // 좌측 하단에 텍스트 배치
            Positioned(
              bottom: 40,
              left: 700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ABOUT 할두',
                    style: GoogleFonts.notoSans(
                      fontSize: 78,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '중년 여성들을 위한 커뮤니티 할두를 소개합니다.',
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHaldoStorySection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Haldo\'s Story',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2ECC71),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '대한민국 중년 여성의 건강한 인생 2막이 시작되는 곳',
            style: GoogleFonts.notoSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Text(
            '할두는 중년 여성들의 건강한 삶을 응원하는 커뮤니티입니다. '
            '우리는 모든 여성이 나이에 상관없이 자신만의 가치를 발견하고, '
            '건강하고 행복한 삶을 살 수 있다고 믿습니다.',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '특히 치매 예방과 인지 기능 향상에 중점을 두어, '
            '두뇌 건강을 위한 다양한 활동과 프로그램을 제공합니다. '
            '할두와 함께라면 중년의 삶이 더욱 풍요롭고 의미 있게 될 것입니다.',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '엄마가 치매면 어떡하지?',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2ECC71),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '할두는 중년 여성의 건강과 삶의 질을 높이는 것을 목표로 합니다. '
            '우리와 함께 건강한 인생 2막을 시작해보세요.',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrandmotherSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 700, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '할머니가 되어서도 두근두근',
            style: GoogleFonts.notoSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActivityItem(
                      '1',
                      '할두 클럽',
                      '건강한 습관을 형성하고 소속감을 느낄 수 있는 공간입니다. '
                          '정기적인 모임을 통해 치매 예방 활동에 참여하세요.',
                    ),
                    const SizedBox(height: 30),
                    _buildActivityItem(
                      '2',
                      '자기탐구 학습지',
                      '자아를 발견하고 자존감을 향상시키는 다양한 학습 자료를 제공합니다. '
                          '두뇌를 자극하는 활동으로 인지 기능을 강화하세요.',
                    ),
                    const SizedBox(height: 30),
                    _buildActivityItem(
                      '3',
                      '건강 정보, 상품 제공',
                      '신뢰할 수 있는 건강 정보와 삶의 질을 높이는 상품을 제공합니다. '
                          '전문가가 검증한 정보로 건강한 삶을 유지하세요.',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 1,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/hero_image_2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.notoSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHaldoHereSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '할두 haldo 있다!',
                  style: GoogleFonts.notoSans(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '중년은 충분히 젊어요. 이모들의 일상이 더 활기차고, '
                  '설레는 경험으로 꾸며지길 바라요.',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 1,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/grandmother.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitySection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Row(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/images/hero_image_1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '국내 최대 중년 여성 커뮤니티',
                style: GoogleFonts.notoSans(
                  fontSize: 34,
                  color: Colors.black87,
                ),
              ),
              Text(
                '30대 조카*들이 이끌어가고 있어요',
                style: GoogleFonts.notoSans(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '''할두의 특별한 점은 30대 조카들이 이모들의 삶을 업그레이드 시켜준다는 것입니다. 
젊은 세대의 트렌드와 기술을 중년 여성들에게 전달하며, 
서로 배우고 성장하는 공간을 만들어갑니다.''',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '''이모들은 조카들에게 인생의 지혜를 전수하고, 
조카들은 이모들에게 새로운 세상의 문을 열어줍니다. 
이런 상호 보완적인 관계가 할두만의 특별함입니다.''',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
