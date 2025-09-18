import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product_model.dart';
import 'web_image_upload_widget.dart';

class ProductManagementDialog extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;
  final Function()? onDelete;

  const ProductManagementDialog({
    super.key,
    this.product,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<ProductManagementDialog> createState() => _ProductManagementDialogState();
}

class _ProductManagementDialogState extends State<ProductManagementDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late TextEditingController _stockController;
  
  String _selectedCategory = '전체';
  final List<String> _categories = ['전체', '베스트', '기획전', '할두', '나눔시장'];
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  String _currentImageUrl = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _imageUrlController = TextEditingController(text: widget.product?.imageUrl ?? '');
    _stockController = TextEditingController(text: widget.product?.stock?.toString() ?? '0');
    final productCategory = widget.product?.category ?? '전체';
    _selectedCategory = _categories.contains(productCategory) ? productCategory : '전체';
    _currentImageUrl = widget.product?.imageUrl ?? '';
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _stockController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    String? suffix,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.notoSans(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: suffix,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2ECC71),
              size: 20,
            ),
          ),
          labelStyle: GoogleFonts.notoSans(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          hintStyle: GoogleFonts.notoSans(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2ECC71), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: WebImageUploadWidget(
        initialImageUrl: _currentImageUrl,
        onImageSelected: (imageUrl) {
          setState(() {
            _currentImageUrl = imageUrl;
            _imageUrlController.text = imageUrl;
          });
        },
      ),
    );
  }


  Widget _buildCategoryDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        initialValue: _categories.contains(_selectedCategory) ? _selectedCategory : _categories.first,
        decoration: InputDecoration(
          labelText: '카테고리',
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.category,
              color: Color(0xFF2ECC71),
              size: 20,
            ),
          ),
          labelStyle: GoogleFonts.notoSans(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2ECC71), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: _categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category,
              style: GoogleFonts.notoSans(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value!;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '카테고리를 선택해주세요';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 700, maxHeight: 850),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 헤더
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2ECC71), Color(0xFF00C853)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isEditing ? Icons.edit : Icons.add_box,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEditing ? '상품 수정' : '새 상품 등록',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      isEditing ? '상품 정보를 수정하세요' : '새로운 상품을 추가하세요',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 14,
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // 폼 컨텐츠
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _buildTextField(
                                    controller: _nameController,
                                    label: '상품명',
                                    icon: Icons.shopping_bag,
                                    hint: '상품명을 입력하세요',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '상품명을 입력해주세요';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  _buildTextField(
                                    controller: _priceController,
                                    label: '가격',
                                    icon: Icons.attach_money,
                                    hint: '가격을 입력하세요',
                                    suffix: '원',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      TextInputFormatter.withFunction((oldValue, newValue) {
                                        if (newValue.text.isEmpty) return newValue;
                                        final number = int.tryParse(newValue.text.replaceAll(',', ''));
                                        if (number == null) return oldValue;
                                        final formatted = number.toString().replaceAllMapped(
                                          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                                          (match) => '${match[1]},',
                                        );
                                        return newValue.copyWith(text: formatted);
                                      }),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '가격을 입력해주세요';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  _buildTextField(
                                    controller: _descriptionController,
                                    label: '상품 설명',
                                    icon: Icons.description,
                                    hint: '상품에 대한 자세한 설명을 입력하세요',
                                    maxLines: 3,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '설명을 입력해주세요';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  // 이미지 업로드 섹션
                                  _buildImageUploadSection(),
                                  
                                  _buildCategoryDropdown(),
                                  
                                  _buildTextField(
                                    controller: _stockController,
                                    label: '재고 수량',
                                    icon: Icons.inventory,
                                    hint: '재고 수량을 입력하세요',
                                    suffix: '개',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // 버튼 영역
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (isEditing && widget.onDelete != null) ...[
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.warning_amber_rounded,
                                                color: Colors.orange[600],
                                                size: 28,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                '상품 삭제',
                                                style: GoogleFonts.notoSans(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Text(
                                            '정말로 이 상품을 삭제하시겠습니까?\n삭제된 상품은 복구할 수 없습니다.',
                                            style: GoogleFonts.notoSans(fontSize: 16),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text(
                                                '취소',
                                                style: GoogleFonts.notoSans(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                widget.onDelete!();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: Text(
                                                '삭제',
                                                style: GoogleFonts.notoSans(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text('삭제'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[50],
                                      foregroundColor: Colors.red[700],
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(color: Colors.red[200]!),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (_currentImageUrl.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('이미지를 업로드하거나 경로를 입력해주세요'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      
                                      final priceText = _priceController.text.replaceAll(',', '');
                                      final product = Product(
                                        id: widget.product?.id ?? '',
                                        name: _nameController.text,
                                        price: double.parse(priceText),
                                        description: _descriptionController.text,
                                        imageUrl: _currentImageUrl,
                                        category: _selectedCategory,
                                        stock: int.tryParse(_stockController.text) ?? 0,
                                        createdAt: widget.product?.createdAt,
                                        updatedAt: widget.product?.updatedAt,
                                      );
                                      widget.onSave(product);
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: Icon(isEditing ? Icons.check : Icons.add),
                                  label: Text(
                                    isEditing ? '수정 완료' : '상품 등록',
                                    style: GoogleFonts.notoSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2ECC71),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}