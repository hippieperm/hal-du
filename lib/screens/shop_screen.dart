import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = true;

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
      // ABOUT 페이지로 이동
      Navigator.pushReplacementNamed(context, '/about');
    } else if (index == 1) {
      // CONTENTS 페이지로 이동
      Navigator.pushReplacementNamed(context, '/contents');
    } else if (index == 2) {
      // SHOP 페이지는 현재 페이지이므로 아무것도 하지 않음
      return;
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
                _buildShopSection(),
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
              selectedIndex: 2, // SHOP이 선택된 상태
              onItemTapped: _onItemTapped,
              isTransparent: _isAppBarTransparent,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SHOP',
                style: GoogleFonts.notoSans(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '건강한 삶을 위한 특별한 상품들',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          Text(
            '할두 쇼핑몰',
            style: GoogleFonts.notoSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildProductCard(
                '치매 예방 도구',
                '두뇌 건강을 위한 퍼즐과 게임',
                '₩29,000',
                Icons.extension,
              ),
              _buildProductCard(
                '건강 보조제',
                '전문가가 추천하는 건강 보조제',
                '₩45,000',
                Icons.medication,
              ),
              _buildProductCard(
                '자기계발 도서',
                '성장과 학습을 위한 도서',
                '₩18,000',
                Icons.menu_book,
              ),
              _buildProductCard(
                '운동 용품',
                '건강한 신체를 위한 운동 도구',
                '₩35,000',
                Icons.fitness_center,
              ),
              _buildProductCard(
                '라이프스타일',
                '일상의 질을 높이는 생활용품',
                '₩25,000',
                Icons.home,
              ),
              _buildProductCard(
                '특별 패키지',
                '할두만의 특별한 상품 패키지',
                '₩89,000',
                Icons.card_giftcard,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
      String title, String description, String price, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 48,
            color: const Color(0xFF2ECC71),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 18,
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
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: GoogleFonts.notoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2ECC71),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // 장바구니 추가 기능
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('장바구니'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
