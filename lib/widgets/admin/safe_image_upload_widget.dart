import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

class SafeImageUploadWidget extends StatefulWidget {
  final Function(String imageUrl) onImageSelected;
  final String? initialImageUrl;
  
  const SafeImageUploadWidget({
    super.key,
    required this.onImageSelected,
    this.initialImageUrl,
  });

  @override
  State<SafeImageUploadWidget> createState() => _SafeImageUploadWidgetState();
}

class _SafeImageUploadWidgetState extends State<SafeImageUploadWidget> {
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isUploading = false;
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

  Future<void> _pickImage() async {
    if (_isUploading) return;
    
    setState(() {
      _isUploading = true;
    });

    try {
      // file_picker 사용하되 더 안전하게
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        if (file.bytes != null && file.bytes!.isNotEmpty) {
          final bytes = file.bytes!;
          
          // 파일 크기 체크 (5MB)
          if (bytes.length > 5 * 1024 * 1024) {
            _showMessage('이미지 크기는 5MB를 초과할 수 없습니다', isError: true);
            return;
          }
          
          // Base64 인코딩
          try {
            final base64String = base64Encode(bytes);
            final extension = file.extension?.toLowerCase() ?? 'jpg';
            final dataUrl = 'data:image/$extension;base64,$base64String';
            
            setState(() {
              _selectedImageBytes = bytes;
              _selectedImageName = file.name;
              _imageUrlController.text = dataUrl;
            });
            
            widget.onImageSelected(dataUrl);
            _showMessage('${file.name} 업로드 완료');
            
          } catch (e) {
            _showMessage('이미지 인코딩 중 오류가 발생했습니다', isError: true);
          }
        } else {
          _showMessage('이미지 데이터를 읽을 수 없습니다', isError: true);
        }
      }
    } catch (e) {
      _showMessage('파일 선택 중 오류가 발생했습니다', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
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
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickImage,
              icon: _isUploading 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.upload_file, size: 18),
              label: Text(
                _isUploading ? '업로드 중...' : '파일 선택',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
          child: _selectedImageBytes != null
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: _clearImage,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
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
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isUploading 
                          ? '파일 업로드 중...'
                          : '위의 "파일 선택" 버튼을 클릭하세요',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
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
        
        const SizedBox(height: 16),
        
        // 직접 경로 입력 필드
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
            labelText: '또는 이미지 경로 직접 입력',
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
                        _selectedImageBytes = null;
                        _selectedImageName = null;
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
          '• 파일 선택: 컴퓨터에서 이미지 파일을 직접 업로드\n• 경로 입력: assets/images/ 폴더의 파일명 또는 웹 URL 입력',
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