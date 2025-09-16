import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class ContentDetailScreen extends StatefulWidget {
  final String contentId;
  
  const ContentDetailScreen({
    super.key,
    required this.contentId,
  });

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
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
      Navigator.pushReplacementNamed(context, '/about');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/contents');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/shop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 100), // 앱바 공간
                _buildContentHeader(),
                _buildContentBody(),
                _buildRelatedContent(),
                const FooterWidget(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarWidget(
              selectedIndex: 1, // CONTENTS가 선택된 상태
              onItemTapped: _onItemTapped,
              isTransparent: _isAppBarTransparent,
              onLogoTapped: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카테고리 태그
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2ECC71),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '건강 정보',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // 제목
              Text(
                '중년 여성을 위한 건강한 식단 관리법',
                style: GoogleFonts.notoSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              
              // 메타 정보
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '2024.03.15',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    Icons.visibility,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '조회 1,234',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '좋아요 89',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // 구분선
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentBody() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 메인 이미지
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // 콘텐츠 내용
              _buildContentText(),
              
              const SizedBox(height: 40),
              
              // 추가 이미지
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              _buildMoreContentText(),
              
              const SizedBox(height: 60),
              
              // 좋아요 및 공유 버튼
              _buildActionButtons(),
              
              const SizedBox(height: 40),
              
              // 구분선
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '건강한 중년을 위한 식단 관리의 중요성',
          style: GoogleFonts.notoSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '중년 여성들에게 있어 건강한 식단 관리는 단순히 체중 조절을 위한 것이 아닙니다. '
          '호르몬 변화, 신진대사 저하, 근육량 감소 등 다양한 신체 변화에 대응하기 위한 필수적인 건강 관리법입니다.',
          style: GoogleFonts.notoSans(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.7,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          '1. 균형잡힌 영양소 섭취',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          '• 단백질: 근육량 유지를 위해 하루 체중 1kg당 1.2~1.6g 섭취\n'
          '• 칼슘: 골다공증 예방을 위해 하루 1,200mg 섭취 권장\n'
          '• 오메가-3: 심혈관 건강과 뇌 기능 향상을 위해 주 2-3회 생선 섭취\n'
          '• 식이섬유: 장 건강과 혈당 조절을 위해 하루 25g 이상 섭취',
          style: GoogleFonts.notoSans(
            fontSize: 15,
            color: Colors.grey[700],
            height: 1.8,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          '2. 규칙적인 식사 패턴',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          '불규칙한 식사는 혈당 변동을 크게 만들고, 신진대사를 떨어뜨립니다. '
          '하루 3끼를 규칙적으로 섭취하되, 저녁 식사는 가볍게 하는 것이 좋습니다. '
          '간식이 필요할 때는 견과류나 요거트 등 건강한 선택을 하세요.',
          style: GoogleFonts.notoSans(
            fontSize: 15,
            color: Colors.grey[700],
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreContentText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. 수분 섭취의 중요성',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          '중년이 되면서 갈증을 느끼는 능력이 감소하기 때문에 의식적으로 물을 마셔야 합니다. '
          '하루 8잔(약 2리터) 정도의 물을 나누어 마시며, 카페인이 든 음료는 제한하는 것이 좋습니다.',
          style: GoogleFonts.notoSans(
            fontSize: 15,
            color: Colors.grey[700],
            height: 1.7,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71).withValues(alpha: 0.026),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF2ECC71).withValues(alpha: 0.077),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: const Color(0xFF2ECC71),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '할두 팁',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2ECC71),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '식단 관리를 시작할 때는 급격한 변화보다는 점진적인 개선이 중요합니다. '
                '한 번에 모든 것을 바꾸려 하지 말고, 주 단위로 하나씩 개선해 나가세요. '
                '할두 클럽에서는 동료들과 함께 건강한 식단 도전을 진행하고 있어요!',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: Icons.favorite_border,
          label: '좋아요',
          count: '89',
          onTap: () {},
        ),
        const SizedBox(width: 30),
        _buildActionButton(
          icon: Icons.share,
          label: '공유하기',
          count: '',
          onTap: () {},
        ),
        const SizedBox(width: 30),
        _buildActionButton(
          icon: Icons.bookmark_border,
          label: '저장',
          count: '',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              count.isNotEmpty ? '$label $count' : label,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      color: Colors.grey[50],
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '관련 콘텐츠',
                style: GoogleFonts.notoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _buildRelatedItem(
                      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                      title: '중년 여성을 위한 운동법',
                      category: '건강 관리',
                      date: '2024.03.10',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildRelatedItem(
                      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                      title: '스트레스 관리와 명상',
                      category: '마음건강',
                      date: '2024.03.08',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildRelatedItem(
                      imageUrl: 'https://images.unsplash.com/photo-1559595464-f3d3f2c095bf?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                      title: '건강한 수면 습관',
                      category: '생활습관',
                      date: '2024.03.05',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedItem({
    required String imageUrl,
    required String title,
    required String category,
    required String date,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.013),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71).withValues(alpha: 0.026),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2ECC71),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}