import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';
import 'dart:math' as math;

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = false;

  late AnimationController _fadeController1;
  late AnimationController _fadeController2;
  late AnimationController _fadeController3;
  late AnimationController _fadeController4;
  late AnimationController _fadeController5;

  late Animation<double> _fadeAnimation1;
  late Animation<double> _fadeAnimation2;
  late Animation<double> _fadeAnimation3;
  late Animation<double> _fadeAnimation4;
  late Animation<double> _fadeAnimation5;

  final GlobalKey _section1Key = GlobalKey();
  final GlobalKey _section2Key = GlobalKey();
  final GlobalKey _section3Key = GlobalKey();
  final GlobalKey _section4Key = GlobalKey();
  final GlobalKey _section5Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // 애니메이션 컨트롤러 초기화
    _fadeController1 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController2 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController3 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController4 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController5 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // 애니메이션 생성
    _fadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController1, curve: Curves.easeOut));
    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController2, curve: Curves.easeOut));
    _fadeAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController3, curve: Curves.easeOut));
    _fadeAnimation4 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController4, curve: Curves.easeOut));
    _fadeAnimation5 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController5, curve: Curves.easeOut));

    // 초기 애니메이션 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fadeController1.dispose();
    _fadeController2.dispose();
    _fadeController3.dispose();
    _fadeController4.dispose();
    _fadeController5.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isAppBarTransparent = _scrollController.offset < 50;
    });
    _checkVisibility();
  }

  void _checkVisibility() {
    final keys = [
      _section1Key,
      _section2Key,
      _section3Key,
      _section4Key,
      _section5Key
    ];
    final controllers = [
      _fadeController1,
      _fadeController2,
      _fadeController3,
      _fadeController4,
      _fadeController5
    ];

    for (int i = 0; i < keys.length; i++) {
      final keyContext = keys[i].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          final size = box.size;
          final screenHeight = MediaQuery.of(context).size.height;

          // 요소가 화면에 보이는지 확인 (10% 이상 보일 때 애니메이션 시작)
          final elementTop = position.dy;
          final elementBottom = position.dy + size.height;
          final visibleTop = math.max(0, -elementTop);
          final visibleBottom =
              math.min(size.height, screenHeight - elementTop);
          final visibleHeight = visibleBottom - visibleTop;
          final visibilityRatio = visibleHeight / size.height;

          if (visibilityRatio > 0.1 && !controllers[i].isCompleted) {
            controllers[i].forward();
          } else if (visibilityRatio <= 0.05 && controllers[i].isCompleted) {
            controllers[i].reverse();
          }
        }
      }
    }
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
                AnimatedBuilder(
                  animation: _fadeAnimation1,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - _fadeAnimation1.value)),
                      child: Opacity(
                        opacity: _fadeAnimation1.value,
                        key: _section1Key,
                        child: _buildGrandmotherSection(),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 400,
                    vertical: 100,
                  ),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _fadeAnimation2,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - _fadeAnimation2.value)),
                            child: Opacity(
                              opacity: _fadeAnimation2.value,
                              key: _section2Key,
                              child: _buildHaldoStorySection(),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _fadeAnimation3,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - _fadeAnimation3.value)),
                            child: Opacity(
                              opacity: _fadeAnimation3.value,
                              key: _section3Key,
                              child: _buildHaldoHereSection(),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _fadeAnimation4,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - _fadeAnimation4.value)),
                            child: Opacity(
                              opacity: _fadeAnimation4.value,
                              key: _section4Key,
                              child: _buildCommunitySection(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _fadeAnimation5,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - _fadeAnimation5.value)),
                      child: Opacity(
                        opacity: _fadeAnimation5.value,
                        key: _section5Key,
                        child: const FooterWidget(),
                      ),
                    );
                  },
                ),
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
              left: 200,
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
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
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
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 170),
                Center(
                  child: Text(
                    '할머니가 되어서도 두근두근',
                    style: GoogleFonts.notoSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Column(
                      children: [
                        Center(
                          child: _buildActivityItem(
                            '1',
                            '할두 클럽',
                            '건강한 습관을 형성하고 소속감을 느낄 수 있는 공간입니다. '
                                '정기적인 모임을 통해 치매 예방 활동에 참여하세요.',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: _buildActivityItem(
                            '2',
                            '자기탐구 학습지',
                            '자아를 발견하고 자존감을 향상시키는 다양한 학습 자료를 제공합니다. '
                                '두뇌를 자극하는 활동으로 인지 기능을 강화하세요.',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: _buildActivityItem(
                            '3',
                            '건강 정보, 상품 제공',
                            '신뢰할 수 있는 건강 정보와 삶의 질을 높이는 상품을 제공합니다. '
                                '전문가가 검증한 정보로 건강한 삶을 유지하세요.',
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 30),
                    Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/grandmother.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String number, String title, String description) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: GoogleFonts.notoSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        description,
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
        mainAxisAlignment: MainAxisAlignment.center,
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
                '''할두의 특별한 점은 30대 조카들이 이모들의 삶을 
업그레이드 시켜준다는 것입니다. 
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
