import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class ContentsScreen extends StatefulWidget {
  const ContentsScreen({super.key});

  @override
  State<ContentsScreen> createState() => _ContentsScreenState();
}

class _ContentsScreenState extends State<ContentsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = false; // 콘텐츠 페이지에서는 항상 불투명
  String _selectedCategory = '전체';

  final List<String> _categories = ['전체', '멤버', '꿀팁', '클럽', '아이템'];

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
      _isAppBarTransparent = false; // 콘텐츠 페이지에서는 항상 불투명
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // ABOUT 페이지로 이동
      Navigator.pushReplacementNamed(context, '/about');
    } else if (index == 1) {
      // CONTENTS 페이지는 현재 페이지이므로 아무것도 하지 않음
      return;
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
                SizedBox(height: 100),
                _buildHeroSection(),
                _buildContentsSection(),
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
              selectedIndex: 1, // CONTENTS가 선택된 상태
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
          '콘텐츠',
          style: GoogleFonts.notoSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildContentsSection() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            // 카테고리 필터
            _buildCategoryFilters(),
            const SizedBox(height: 50),

            // 콘텐츠 그리드
            _buildContentGrid(),
            const SizedBox(height: 50),

            // 검색바
            Center(child: _buildSearchBar()),
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
                  color:
                      isSelected ? const Color(0xFF2ECC71) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2ECC71)
                        : Colors.grey[400]!,
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

  Widget _buildContentGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.of(context).size.width > 1200
          ? 4
          : MediaQuery.of(context).size.width > 768
              ? 3
              : 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 30,
      childAspectRatio: 0.75,
      children: [
        _buildContentCard(
          'assets/images/hero_image_1.jpg',
          '클럽',
          '할두 이모작 캠프 in 경주',
          '할두\n이모작 캠프\nin 경주',
          '332',
          '0',
        ),
        _buildContentCard(
          'assets/images/hero_image_2.jpg',
          '꿀팁',
          '더운 여름 준비템 편한 속옷 추천 5가지',
          '더운 여름 준비템\n편한 속옷 추천\n5가지',
          '189',
          '0',
        ),
        _buildContentCard(
          'assets/images/grandmother.jpg',
          '멤버',
          '암과 희귀병을 극복한 54세',
          '암과 희귀병을\n이기는 감사\n할생각',
          '213',
          '0',
        ),
        _buildContentCard(
          'assets/images/hero_image_1.jpg',
          '아이템',
          '할두 여름 바지 컬렉션',
          '이모는 3컬러 중에\n뭐가 1위예요~?',
          '145',
          '0',
          hasSpecialTag: true,
        ),
      ],
    );
  }

  Widget _buildContentCard(
    String imagePath,
    String category,
    String title,
    String overlayText,
    String views,
    String likes, {
    bool hasSpecialTag = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
                aspectRatio: 1.3,
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

                    // 어두운 오버레이 (텍스트용)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),

                    // 오버레이 텍스트
                    Positioned(
                      bottom: 15,
                      left: 15,
                      right: 15,
                      child: Text(
                        overlayText,
                        style: GoogleFonts.notoSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        maxLines: 3,
                      ),
                    ),

                    // 특별 태그 (아이템 카드용)
                    if (hasSpecialTag)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2ECC71),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '할두컬렉션',
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
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
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 카테고리와 제목
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: category == '클럽'
                              ? const Color(0xFF2ECC71).withValues(alpha: 0.15)
                              : category == '꿀팁'
                                  ? Colors.orange.withValues(alpha: 0.15)
                                  : category == '멤버'
                                      ? Colors.blue.withValues(alpha: 0.15)
                                      : Colors.purple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.notoSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: category == '클럽'
                                ? const Color(0xFF2ECC71)
                                : category == '꿀팁'
                                    ? Colors.orange[700]
                                    : category == '멤버'
                                        ? Colors.blue[700]
                                        : Colors.purple[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 제목
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),

                      // 좋아요 및 조회수
                      Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 3),
                          Text(
                            likes,
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '조회 $views',
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
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
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width > 768 ? 600 : double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.notoSans(
                  color: Colors.grey[400],
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              style: GoogleFonts.notoSans(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                // 검색 기능
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.grey[700],
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
