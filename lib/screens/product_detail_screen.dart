import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productId;

  const ProductDetailScreen({super.key, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = false;
  int _selectedImageIndex = 0;
  Product? _product;
  List<String> _productImages = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadProduct();
  }

  void _loadProduct() {
    if (widget.productId == null) {
      // 라우트에서 productId 가져오기
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'] as String?;
        if (productId != null) {
          final productService = Provider.of<ProductService>(context, listen: false);
          final product = productService.getProductById(productId);
          if (product != null) {
            setState(() {
              _product = product;
              _productImages = [product.imageUrl];
              if (product.additionalImages != null) {
                _productImages.addAll(product.additionalImages!);
              }
            });
          }
        }
      });
    } else {
      // 직접 전달된 productId 사용
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final productService = Provider.of<ProductService>(context, listen: false);
        final product = productService.getProductById(widget.productId!);
        if (product != null) {
          setState(() {
            _product = product;
            _productImages = [product.imageUrl];
            if (product.additionalImages != null) {
              _productImages.addAll(product.additionalImages!);
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isAppBarTransparent = false;
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
    if (_product == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Center(
              child: CircularProgressIndicator(),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBarWidget(
                selectedIndex: 2,
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 350),
                  child: Column(
                    children: [
                      _buildProductDetailSection(),
                      _buildEnglishLearningSection(),
                      _buildProductInfoSection(),
                    ],
                  ),
                ),
                const FooterWidget(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarWidget(
              selectedIndex: 2,
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

  Widget _buildProductDetailSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 좌측 이미지 섹션
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // 메인 이미지
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(_productImages[_selectedImageIndex]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 썸네일 이미지들
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _productImages.asMap().entries.map((entry) {
                    int index = entry.key;
                    String imagePath = entry.value;
                    bool isSelected = index == _selectedImageIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2ECC71)
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(width: 60),

          // 우측 상품 정보 섹션
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상품명
                Text(
                  _product!.name,
                  style: GoogleFonts.notoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // NEW 태그와 가격, 공유 버튼
                Row(
                  children: [
                    if (_product!.isNew == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ECC71),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.share_outlined,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 가격
                Text(
                  '${_product!.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                  style: GoogleFonts.notoSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2ECC71),
                  ),
                ),
                const SizedBox(height: 40),

                // 구분선
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 80),

                // 클럽명 옵션
                Text(
                  '클럽명 *',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),

                // 드롭다운
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '클럽명 (필수)',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                // 구매 버튼들
                _buildNewPurchaseButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*
  Widget _buildProductOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 배송비
        Row(
          children: [
            Text(
              '배송비',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 20),
            Text(
              '무료',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 수량
        Row(
          children: [
            Text(
              '수량',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 20),
            Text(
              '할두에서만 구매 가능한 도서입니다.',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // 선택 사항
        Row(
          children: [
            Text(
              '구매 선택 사항 *',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 옵션 선택
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '상품: [해기가히] 실가능은 (+82,000원)',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
  */

  Widget _buildNewPurchaseButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2ECC71),
              side: const BorderSide(color: Color(0xFF2ECC71), width: 2),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.white,
            ),
            child: Text(
              '구매하기',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2ECC71),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.white,
            ),
            child: Text(
              '장바구니',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          width: 160,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 2),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: IconButton(
            onPressed: () {},
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  color: Colors.grey[600],
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_product!.likes ?? 0}',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /*
  Widget _buildPurchaseButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2ECC71),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              '구매하기',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[400]!),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              '장바구니',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey[700],
            side: BorderSide(color: Colors.grey[400]!),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Icon(
            Icons.favorite_border,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  */

  Widget _buildEnglishLearningSection() {
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Text(
              '영어 배우기',
              style: GoogleFonts.notoSans(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            // 영어 학습 콘텐츠 placeholder
            Container(
              width: 600,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text('영어 학습 콘텐츠 영역'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '상품정보',
            style: GoogleFonts.notoSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          _buildInfoTable(),
        ],
      ),
    );
  }

  Widget _buildInfoTable() {
    final infoItems = [
      ['상품명', _product!.name],
      ['판매가격', '${_product!.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원'],
      ['상품 택배비용', _product!.shippingInfo ?? '무료배송'],
      ['상품 설명', _product!.description],
      if (_product!.detailDescription != null) [
        '상품에 대한 상세 정보',
        _product!.detailDescription!
      ],
      if (_product!.refundPolicy != null) [
        '상품의 취급 상세 내용',
        _product!.refundPolicy!
      ],
    ];

    return Column(
      children: infoItems.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  item[0],
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  item[1],
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
