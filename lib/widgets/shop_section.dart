import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopSection extends StatelessWidget {
  const ShopSection({super.key});

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
            'SHOP',
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

          // 상품 그리드
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: MediaQuery.of(context).size.width > 768
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProductCard(
                        name: '건강 보조제',
                        price: '29,000원',
                        image: '💊',
                        description: '50대 이상을 위한 맞춤 영양제',
                      ),
                      _buildProductCard(
                        name: '헬스케어 키트',
                        price: '59,000원',
                        image: '🏥',
                        description: '건강 관리를 위한 필수 아이템',
                      ),
                      _buildProductCard(
                        name: '웰니스 패키지',
                        price: '89,000원',
                        image: '🧘',
                        description: '마음과 몸의 건강을 위한 세트',
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildProductCard(
                        name: '건강 보조제',
                        price: '29,000원',
                        image: '💊',
                        description: '50대 이상을 위한 맞춤 영양제',
                      ),
                      const SizedBox(height: 30),
                      _buildProductCard(
                        name: '헬스케어 키트',
                        price: '59,000원',
                        image: '🏥',
                        description: '건강 관리를 위한 필수 아이템',
                      ),
                      const SizedBox(height: 30),
                      _buildProductCard(
                        name: '웰니스 패키지',
                        price: '89,000원',
                        image: '🧘',
                        description: '마음과 몸의 건강을 위한 세트',
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 60),

          // CTA 버튼
          ElevatedButton(
            onPressed: () {
              // 쇼핑몰로 이동 액션
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
              '쇼핑몰 바로가기',
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

  Widget _buildProductCard({
    required String name,
    required String price,
    required String image,
    required String description,
  }) {
    return Container(
      width: 280,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상품 이미지
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(image, style: const TextStyle(fontSize: 80)),
            ),
          ),

          // 상품 정보
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.notoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[600],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // 장바구니 추가 액션
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[600],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        '담기',
                        style: GoogleFonts.notoSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}
