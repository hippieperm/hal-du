import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

class SimpleImageUploadWidget extends StatefulWidget {
  final Function(String imageUrl) onImageSelected;
  final String? initialImageUrl;
  
  const SimpleImageUploadWidget({
    super.key,
    required this.onImageSelected,
    this.initialImageUrl,
  });

  @override
  State<SimpleImageUploadWidget> createState() => _SimpleImageUploadWidgetState();
}

class _SimpleImageUploadWidgetState extends State<SimpleImageUploadWidget> {
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isDragging = false;
  late TextEditingController _imageUrlController;
  bool _isUploading = false;

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

  Future<void> _pickImage() async {
    if (_isUploading) return;
    
    setState(() {
      _isUploading = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        if (file.bytes != null) {
          final bytes = file.bytes!;
          
          // 파일 크기 체크 (5MB)
          if (bytes.length > 5 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('이미지 크기는 5MB를 초과할 수 없습니다'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
          
          // Base64 인코딩
          final base64String = base64Encode(bytes);
          final extension = file.extension?.toLowerCase() ?? 'jpg';
          final dataUrl = 'data:image/$extension;base64,$base64String';
          
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImageName = file.name;
            _imageUrlController.text = dataUrl;
          });
          
          widget.onImageSelected(dataUrl);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('이미지가 성공적으로 업로드되었습니다'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지 업로드 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageName = null;
      _imageUrlController.text = widget.initialImageUrl ?? '';
    });
    widget.onImageSelected(widget.initialImageUrl ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이미지 업로드',
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        
        // 이미지 업로드 영역
        MouseRegion(
          onEnter: (_) => setState(() => _isDragging = true),
          onExit: (_) => setState(() => _isDragging = false),
          child: GestureDetector(
            onTap: _isUploading ? null : _pickImage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 200,
              decoration: BoxDecoration(
                color: _isDragging ? const Color(0xFF2ECC71).withValues(alpha: 0.05) : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isDragging ? const Color(0xFF2ECC71) : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: _isUploading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFF2ECC71),
                          ),
                          SizedBox(height: 12),
                          Text('이미지 업로드 중...'),
                        ],
                      ),
                    )
                  : _selectedImageBytes != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                _selectedImageBytes!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Material(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: _clearImage,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: _isDragging ? const Color(0xFF2ECC71) : Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '클릭하여 이미지를 선택하세요',
                              style: GoogleFonts.notoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _isDragging ? const Color(0xFF2ECC71) : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PNG, JPG, JPEG (최대 5MB)',
                              style: GoogleFonts.notoSans(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                            if (_selectedImageName != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _selectedImageName!,
                                  style: GoogleFonts.notoSans(
                                    fontSize: 12,
                                    color: const Color(0xFF2ECC71),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 직접 경로 입력 필드
        TextFormField(
          controller: _imageUrlController,
          onChanged: (value) {
            widget.onImageSelected(value);
          },
          style: GoogleFonts.notoSans(
            fontSize: 16,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: '이미지 경로 (직접 입력)',
            hintText: 'assets/images/product.jpg',
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.link,
                color: Color(0xFF2ECC71),
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
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}