import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleTextImageWidget extends StatefulWidget {
  final Function(String imageUrl) onImageSelected;
  final String? initialImageUrl;
  
  const SimpleTextImageWidget({
    super.key,
    required this.onImageSelected,
    this.initialImageUrl,
  });

  @override
  State<SimpleTextImageWidget> createState() => _SimpleTextImageWidgetState();
}

class _SimpleTextImageWidgetState extends State<SimpleTextImageWidget> {
  late TextEditingController _imageUrlController;
  String? _previewImageType;

  @override
  void initState() {
    super.initState();
    _imageUrlController = TextEditingController(text: widget.initialImageUrl ?? '');
    _checkImageType(_imageUrlController.text);
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _checkImageType(String url) {
    if (url.isEmpty) {
      _previewImageType = null;
    } else if (url.startsWith('data:image')) {
      _previewImageType = 'base64';
    } else if (url.startsWith('assets/')) {
      _previewImageType = 'asset';
    } else if (url.startsWith('http')) {
      _previewImageType = 'url';
    } else {
      _previewImageType = 'path';
    }
  }

  void _showSampleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '이미지 경로 예시',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSampleItem(
                '로컬 assets 파일:',
                'assets/images/product1.jpg',
                () => _setSample('assets/images/product1.jpg'),
              ),
              const SizedBox(height: 16),
              _buildSampleItem(
                '웹 URL:',
                'https://example.com/image.jpg',
                () => _setSample('https://example.com/image.jpg'),
              ),
              const SizedBox(height: 16),
              _buildSampleItem(
                'Base64 데이터:',
                'data:image/jpeg;base64,/9j/4AAQ...',
                () => _setSample('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCdABmX/9k='),
              ),
              const SizedBox(height: 16),
              Text(
                '참고:\n• assets 파일은 프로젝트에 미리 포함되어야 합니다\n• 웹 URL은 CORS를 허용해야 합니다\n• Base64는 파일을 직접 인코딩한 데이터입니다',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '닫기',
              style: GoogleFonts.notoSans(color: const Color(0xFF2ECC71)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleItem(String title, String sample, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              sample,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: Colors.blue[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  void _setSample(String sample) {
    setState(() {
      _imageUrlController.text = sample;
      _checkImageType(sample);
    });
    widget.onImageSelected(sample);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('예시 경로가 설정되었습니다: $sample'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPreviewArea() {
    if (_imageUrlController.text.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              '이미지 경로를 입력하세요',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _showSampleDialog,
              child: Text(
                '예시 보기',
                style: GoogleFonts.notoSans(
                  color: const Color(0xFF2ECC71),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconForType(),
            size: 48,
            color: const Color(0xFF2ECC71),
          ),
          const SizedBox(height: 12),
          Text(
            _getDescriptionForType(),
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              _imageUrlController.text,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType() {
    switch (_previewImageType) {
      case 'base64':
        return Icons.data_object;
      case 'asset':
        return Icons.folder;
      case 'url':
        return Icons.language;
      default:
        return Icons.image;
    }
  }

  String _getDescriptionForType() {
    switch (_previewImageType) {
      case 'base64':
        return 'Base64 인코딩된 이미지 데이터';
      case 'asset':
        return '프로젝트 assets 이미지 파일';
      case 'url':
        return '웹 URL 이미지';
      default:
        return '이미지 경로 설정됨';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '이미지 설정',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _showSampleDialog,
              icon: const Icon(Icons.help_outline, size: 16),
              label: Text(
                '예시',
                style: GoogleFonts.notoSans(fontSize: 12),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2ECC71),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // 미리보기 영역
        _buildPreviewArea(),
        
        const SizedBox(height: 16),
        
        // 입력 필드
        TextFormField(
          controller: _imageUrlController,
          onChanged: (value) {
            setState(() {
              _checkImageType(value);
            });
            widget.onImageSelected(value);
          },
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: '이미지 경로',
            hintText: 'assets/images/product.jpg 또는 URL',
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _getIconForType(),
                color: const Color(0xFF2ECC71),
                size: 18,
              ),
            ),
            suffixIcon: _imageUrlController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _imageUrlController.clear();
                        _previewImageType = null;
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
        ),
      ],
    );
  }
}