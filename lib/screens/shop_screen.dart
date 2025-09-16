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
  bool _isAppBarTransparent = false; // 샵 페이지에서는 항상 불투명
  String _selectedCategory = '전체';

  final List<String> _categories = ['전체', '베스트', '기획전', '할두', '나눔시장'];

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
      _isAppBarTransparent = false; // 샵 페이지에서는 항상 불투명
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
                const SizedBox(height: 100),
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
      height: 110,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
          '쇼핑',
          style: GoogleFonts.notoSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildShopSection() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            // 카테고리 필터
            _buildCategoryFilters(),
            const SizedBox(height: 50),

            // 상품 그리드
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _categories.map((category) {
        final isSelected = category == _selectedCategory;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 20 : 16,
                  vertical: isSelected ? 10 : 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2ECC71) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2ECC71) : Colors.grey[400]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 15,
      mainAxisSpacing: 25,
      childAspectRatio: 0.65,
      children: [
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '낙담 줄인 내천함 헤어 (50대 60대 점감 세이 향감 5마)',
          '33,000원',
          '할두 줄인 내천함 헤어 (50대 60대 점감 세이 향감 5마)',
          true,
          false,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '마행하지 감동되는 굉가 ( 50대 60대 종감은 감감 종점 )',
          '10,000원',
          '마행하지 감동되는 굉가 ( 50대 60대 종감은 감감 종점 )',
          true,
          false,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '[해기가히] 실가되는 챗감리 내인네 - 사진집',
          '82,000원',
          '[해기가히] 실가되는 챗감리 내인네 - 사진집',
          false,
          true,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '[진문가히] 실가가쓸 챠품리 내인네 - 촘벽 신성',
          '12,000원',
          '[진문가히] 실가가쓸 챠품리 내인네 - 촘벽 신성',
          false,
          false,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '할무 재단 클럽 특기 쇠은 (50대 60대 여성 미은 감봘아는 대회)',
          '32,000원',
          '촌가탁 팹이 춰에 숙솟 발줍이아!',
          false,
          false,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '[미이] 쇠이 졟어나 하리와 플로 시쇼 여가영 선이 완성되장',
          '13,000원',
          '[미이] 쇠이 졟어나 하리와 플로 시쇼',
          false,
          false,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '[미이] 멜간과 다리멜간 될줄 시쓸나 신감 아이야간 멀이 젓이 이촘',
          '25,000원',
          '[미이] 멜간과 다리멜간 될줄 시쓸나',
          false,
          false,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '[우니] 메에하네이 나시, 멤을 줄영은 서별한 서가 아웅 웝이 아이야 신영',
          '14,800원',
          '[우니] 메에하네이 나시, 멤을 줄영은 서별한',
          false,
          false,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '메즉 쇠애는 질이 십아내 할두 촘능은 4가 났이 누는 논이 촉고 넬갈 작영',
          '76,000원',
          '메즉 쇠애는 질이 십아내 할두 촘능은 4가',
          false,
          false,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '사기능타 나기가능 완도 시간 활량 셸링 (50대 60대 나기 모양)',
          '30,000원',
          '사기능타 나기가능 완도 시간 활량 셸링',
          false,
          false,
        ),
        // 추가 상품들 (이미지와 동일하게 더 많은 상품)
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '메즉 쇠애는 질이 십아내 할두 촘능은 4가',
          '33,000원',
          '할무 제단 클럽',
          false,
          false,
        ),
        _buildProductCard(
          'assets/images/grandmother.jpg',
          '[50년] 우리 호어 30가 아인 더더 호어수들',
          '10,000원',
          '촌가히 팹이\n등대 숙영 말봅이야!',
          true,
          false,
        ),
      ],
    );
  }

  Widget _buildProductCard(
    String imagePath,
    String description,
    String price,
    String title,
    bool isHot,
    bool hasSpecialTag,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/product-detail');
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지 섹션
                AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    // 배경 이미지
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // 이미지 위 오버레이 텍스트
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // HOT 태그
                    if (isHot)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2ECC71),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            'HOT',
                            style: GoogleFonts.notoSans(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    // 할두 태그
                    if (hasSpecialTag)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '할두',
                            style: GoogleFonts.notoSans(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // 하단 정보 섹션
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 설명
                      Flexible(
                        child: Text(
                          description,
                          style: GoogleFonts.notoSans(
                            fontSize: 10,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 가격
                      Text(
                        price,
                        style: GoogleFonts.notoSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),

                      // 좋아요 및 조회수
                      Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 11,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '0',
                            style: GoogleFonts.notoSans(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '조회 10',
                            style: GoogleFonts.notoSans(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}