import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'terms_dialog.dart';
import '../services/auth_service.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 숫자만 추출
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // 11자리 제한
    if (digitsOnly.length > 11) {
      digitsOnly = digitsOnly.substring(0, 11);
    }
    
    String formatted = '';
    if (digitsOnly.length >= 1) {
      if (digitsOnly.length <= 3) {
        formatted = digitsOnly;
      } else if (digitsOnly.length <= 7) {
        formatted = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
      } else {
        formatted = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class SignupDialog extends StatefulWidget {
  const SignupDialog({super.key});

  @override
  State<SignupDialog> createState() => _SignupDialogState();
}

class _SignupDialogState extends State<SignupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  int _selectedYear = 1990;
  int _selectedMonth = 1;
  int _selectedDay = 1;

  List<String> _selectedInterests = [];
  bool _termsAccepted = false;

  final List<String> _interests = [
    '운동', '독서', '글쓰기', '요리', '그림', '댄스', '공부', '기타'
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 다이얼로그 열릴 때 약관 동의부터 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTermsDialog();
    });
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const TermsDialog(),
    ).then((accepted) {
      if (accepted == true) {
        setState(() {
          _termsAccepted = true;
        });
      } else {
        // 약관 동의 안하면 다이얼로그 닫기
        Navigator.of(context).pop();
      }
    });
  }

  void _submitSignup() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      final success = await authService.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phone: _contactController.text,
      );

      if (success) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('회원가입이 완료되었습니다.')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authService.errorMessage ?? '회원가입에 실패했습니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 약관 동의 전에는 빈 Container 반환
    if (!_termsAccepted) {
      return const SizedBox.shrink();
    }

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '회원가입',
                  style: GoogleFonts.notoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 프로필 이미지
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 폼
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 이메일
                      _buildTextField(
                        controller: _emailController,
                        hintText: '이메일',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '이메일을 입력해주세요';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                            return '올바른 이메일 형식을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // 비밀번호
                      _buildTextField(
                        controller: _passwordController,
                        hintText: '비밀번호',
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '비밀번호를 입력해주세요';
                          }
                          if (value!.length < 6) {
                            return '비밀번호는 6자 이상이어야 합니다';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // 비밀번호 확인
                      _buildTextField(
                        controller: _passwordConfirmController,
                        hintText: '비밀번호 확인',
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '비밀번호 확인을 입력해주세요';
                          }
                          if (value != _passwordController.text) {
                            return '비밀번호가 일치하지 않습니다';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // 이름
                      _buildLabel('이름'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _nameController,
                        hintText: '이름을(를) 입력하세요',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // 연락처
                      _buildLabel('연락처'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _contactController,
                        hintText: '010-0000-0000',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [PhoneNumberFormatter()],
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '연락처를 입력해주세요';
                          }
                          // 하이픈 제거 후 11자리 검증
                          String digitsOnly = value!.replaceAll(RegExp(r'[^0-9]'), '');
                          if (digitsOnly.length != 11) {
                            return '올바른 휴대폰 번호를 입력해주세요';
                          }
                          if (!digitsOnly.startsWith('010')) {
                            return '010으로 시작하는 번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // 생년월일
                      _buildLabel('생년월일'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              value: _selectedYear,
                              items: List.generate(70, (index) => 1930 + index),
                              onChanged: (value) => setState(() => _selectedYear = value!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdown(
                              value: _selectedMonth,
                              items: List.generate(12, (index) => index + 1),
                              onChanged: (value) => setState(() => _selectedMonth = value!),
                              suffix: '월',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdown(
                              value: _selectedDay,
                              items: List.generate(31, (index) => index + 1),
                              onChanged: (value) => setState(() => _selectedDay = value!),
                              suffix: '일',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 취미
                      _buildLabel('취미'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: _interests.map((interest) {
                          final isSelected = _selectedInterests.contains(interest);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedInterests.remove(interest);
                                } else {
                                  _selectedInterests.add(interest);
                                }
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF2ECC71) : Colors.grey[400]!,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    color: isSelected ? const Color(0xFF2ECC71) : Colors.white,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  interest,
                                  style: GoogleFonts.notoSans(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),

                      // 회원가입 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2ECC71),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            '가입하기',
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.notoSans(
          color: Colors.grey[500],
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF2ECC71)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: GoogleFonts.notoSans(
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const Text(
          ' *',
          style: TextStyle(color: Colors.blue, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required int value,
    required List<int> items,
    required void Function(int?) onChanged,
    String suffix = '',
  }) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            '$item$suffix',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF2ECC71)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      style: GoogleFonts.notoSans(
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }
}