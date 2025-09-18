import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert' show base64Decode;
import '../widgets/app_bar_widget.dart';
import '../widgets/footer_widget.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../widgets/admin/product_management_dialog.dart';
import '../models/product_model.dart';

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
    final authService = Provider.of<AuthService>(context);
    final isAdmin = authService.isAdmin;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            // 관리자인 경우 상품 추가 버튼 표시
            if (isAdmin) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (!mounted) return;
                      final productService = Provider.of<ProductService>(context, listen: false);
                      await productService.addSampleProducts();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('샘플 상품이 추가되었습니다'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.data_array),
                    label: const Text('샘플 추가'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ProductManagementDialog(
                          onSave: (product) async {
                            final productService = Provider.of<ProductService>(context, listen: false);
                            final success = await productService.addProduct(product);
                            if (success) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('상품이 등록되었습니다'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(productService.errorMessage ?? '상품 등록에 실패했습니다'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('상품 추가'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            
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
    return Consumer<ProductService>(
      builder: (context, productService, child) {
        final products = productService.getProductsByCategory(_selectedCategory);
        
        if (productService.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00C853),
            ),
          );
        }
        
        if (products.isEmpty) {
          return Center(
            child: Text(
              '상품이 없습니다',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          );
        }
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 30,
            childAspectRatio: 0.72,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(product);
          },
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    final authService = Provider.of<AuthService>(context);
    final isAdmin = authService.isAdmin;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product-detail',
            arguments: {'productId': product.id},
          );
        },
        onLongPress: isAdmin ? () {
          showDialog(
            context: context,
            builder: (context) => ProductManagementDialog(
              product: product,
              onSave: (updatedProduct) async {
                final productService = Provider.of<ProductService>(context, listen: false);
                final success = await productService.updateProduct(updatedProduct);
                if (success) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('상품이 수정되었습니다'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(productService.errorMessage ?? '상품 수정에 실패했습니다'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              onDelete: () async {
                final productService = Provider.of<ProductService>(context, listen: false);
                final success = await productService.deleteProduct(product.id);
                if (success) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('상품이 삭제되었습니다'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(productService.errorMessage ?? '상품 삭제에 실패했습니다'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          );
        } : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
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
                          color: Colors.grey[100],
                        ),
                        child: _buildProductImage(product.imageUrl),
                      ),

                      // 관리자 편집 아이콘
                      if (isAdmin)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () {
                              // 상품 상세 페이지로의 이동을 막고 편집 다이얼로그만 열기
                              showDialog(
                                context: context,
                                builder: (context) => ProductManagementDialog(
                                  product: product,
                                  onSave: (updatedProduct) async {
                                    final productService = Provider.of<ProductService>(context, listen: false);
                                    final success = await productService.updateProduct(updatedProduct);
                                    if (success) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('상품이 수정되었습니다'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(productService.errorMessage ?? '상품 수정에 실패했습니다'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  onDelete: () async {
                                    final productService = Provider.of<ProductService>(context, listen: false);
                                    final success = await productService.deleteProduct(product.id);
                                    if (success) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('상품이 삭제되었습니다'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(productService.errorMessage ?? '상품 삭제에 실패했습니다'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Color(0xFF2ECC71),
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
                      children: [
                        // 상품명
                        Expanded(
                          flex: 2,
                          child: Text(
                            product.name,
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
                        
                        // 설명
                        Expanded(
                          flex: 2,
                          child: Text(
                            product.description,
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // 가격
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                              style: GoogleFonts.notoSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2ECC71),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey[400],
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

  Widget _buildProductImage(String imageUrl) {
    // 에러 표시용 위젯
    Widget errorWidget = Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      ),
    );

    if (imageUrl.isEmpty) {
      return errorWidget;
    }

    // Base64 data URL인 경우
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64Data = imageUrl.split(',')[1];
        return Image.memory(
          base64Decode(base64Data),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => errorWidget,
        );
      } catch (e) {
        return errorWidget;
      }
    }

    // 웹 URL인 경우 (http 또는 https로 시작)
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => errorWidget,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[100],
            child: Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF2ECC71),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    }

    // Assets 경로인 경우
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => errorWidget,
    );
  }
}