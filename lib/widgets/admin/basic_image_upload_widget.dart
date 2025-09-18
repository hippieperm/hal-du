import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicImageUploadWidget extends StatefulWidget {
  final Function(String imageUrl) onImageSelected;
  final String? initialImageUrl;
  
  const BasicImageUploadWidget({
    super.key,
    required this.onImageSelected,
    this.initialImageUrl,
  });

  @override
  State<BasicImageUploadWidget> createState() => _BasicImageUploadWidgetState();
}

class _BasicImageUploadWidgetState extends State<BasicImageUploadWidget> {
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _imageUrlController = TextEditingController(text: widget.initialImageUrl ?? '');
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _showImageUrlDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final tempController = TextEditingController(text: _imageUrlController.text);
        return AlertDialog(
          title: Text(
            '이미지 URL 입력',
            style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tempController,
                decoration: InputDecoration(
                  labelText: '이미지 URL',
                  hintText: 'https://example.com/image.jpg 또는 assets/images/product.jpg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Text(
                '예시:\n• assets/images/product1.jpg\n• https://example.com/image.jpg\n• data:image/jpeg;base64,/9j/4AAQ...',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '취소',
                style: GoogleFonts.notoSans(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _imageUrlController.text = tempController.text;
                });
                widget.onImageSelected(tempController.text);
                Navigator.pop(context);
                
                if (tempController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('이미지 URL이 설정되었습니다'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                foregroundColor: Colors.white,
              ),
              child: Text(
                '확인',
                style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이미지 설정',
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        
        // 이미지 프리뷰 및 업로드 영역
        GestureDetector(
          onTap: _showImageUrlDialog,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: _imageUrlController.text.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '클릭하여 이미지 URL 입력',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'assets 경로 또는 웹 URL',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      // 이미지 표시 영역
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 48,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '이미지 설정됨',
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 편집 버튼
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2ECC71),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 직접 입력 필드
        TextFormField(
          controller: _imageUrlController,
          onChanged: (value) {
            widget.onImageSelected(value);
          },
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: '이미지 경로',
            hintText: 'assets/images/product.jpg',
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.link,
                color: Color(0xFF2ECC71),
                size: 18,
              ),
            ),
            suffixIcon: _imageUrlController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _imageUrlController.clear();
                      });
                      widget.onImageSelected('');
                    },
                    icon: const Icon(Icons.clear, size: 18),
                  )
                : null,
            labelStyle: GoogleFonts.notoSans(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            hintStyle: GoogleFonts.notoSans(
              color: Colors.grey[400],
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2ECC71), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            isDense: true,
          ),
          maxLines: 1,
        ),
        
        const SizedBox(height: 8),
        
        // 도움말 텍스트
        Text(
          '• assets/images/ 폴더의 이미지 파일명을 입력하세요\n• 또는 웹 URL을 입력할 수 있습니다',
          style: GoogleFonts.notoSans(
            fontSize: 11,
            color: Colors.grey[500],
            height: 1.3,
          ),
        ),
      ],
    );
  }
}