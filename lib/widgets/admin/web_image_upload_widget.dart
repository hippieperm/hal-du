import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'dart:convert';

class WebImageUploadWidget extends StatefulWidget {
  final Function(String imageUrl) onImageSelected;
  final String? initialImageUrl;
  
  const WebImageUploadWidget({
    super.key,
    required this.onImageSelected,
    this.initialImageUrl,
  });

  @override
  State<WebImageUploadWidget> createState() => _WebImageUploadWidgetState();
}

class _WebImageUploadWidgetState extends State<WebImageUploadWidget> {
  late TextEditingController _imageUrlController;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '이미지 업로드',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                '파일 업로드는 현재 지원되지 않습니다',
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: Colors.blue[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // 이미지 프리뷰 영역
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: _imageUrlController.text.isNotEmpty && _imageUrlController.text.startsWith('http')
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    _imageUrlController.text,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '이미지를 불러올 수 없습니다',
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : _imageUrlController.text.isNotEmpty && _imageUrlController.text.startsWith('assets/')
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        _imageUrlController.text,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '에셋 이미지를 찾을 수 없습니다',
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '이미지 URL을 입력하세요',
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '웹 URL 또는 assets 경로',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
        ),
        
        const SizedBox(height: 16),
        
        // 이미지 URL 입력 필드
        TextFormField(
          controller: _imageUrlController,
          onChanged: (value) {
            setState(() {}); // 프리뷰 업데이트를 위해
            widget.onImageSelected(value);
          },
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: '이미지 URL 또는 Assets 경로',
            hintText: 'https://example.com/image.jpg 또는 assets/images/product.jpg',
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
          maxLines: 2,
          minLines: 1,
        ),
        
        const SizedBox(height: 12),
        
        // 예시 버튼들
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildExampleButton(
              '할두 샘플',
              'assets/images/grandmother.jpg',
              Colors.green,
            ),
            _buildExampleButton(
              '히어로 이미지 1',
              'assets/images/hero_image_1.jpg',
              Colors.blue,
            ),
            _buildExampleButton(
              '히어로 이미지 2',
              'assets/images/hero_image_2.jpg',
              Colors.purple,
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // 도움말 텍스트
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: Text(
            '💡 사용 가능한 이미지 소스:\n'
            '• 웹 URL: https://example.com/image.jpg\n'
            '• Assets: assets/images/filename.jpg\n'
            '• 파일 업로드는 현재 Flutter Web의 제한으로 지원되지 않습니다',
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: Colors.blue[700],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExampleButton(String label, String url, Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          _imageUrlController.text = url;
        });
        widget.onImageSelected(url);
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}