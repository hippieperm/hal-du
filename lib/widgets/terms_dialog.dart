import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsDialog extends StatefulWidget {
  const TermsDialog({super.key});

  @override
  State<TermsDialog> createState() => _TermsDialogState();
}

class _TermsDialogState extends State<TermsDialog> {
  bool _agreeToAll = false;
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;
  bool _agreeToCollection = false;
  bool _agreeToMarketing = false;
  bool _confirmAge = false;

  bool get _allRequiredChecked =>
      _agreeToPrivacy &&
      _agreeToCollection &&
      _confirmAge;

  bool get _canSubmit => _allRequiredChecked;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Text(
              '약관동의',
              style: GoogleFonts.notoSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            // 약관 항목들
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이용약관 및 개인정보 수집 동의
                    _buildCheckboxItem(
                      value: _allRequiredChecked && _agreeToMarketing,
                      onChanged: (value) => setState(() {
                        _agreeToAll = value!;
                        _agreeToPrivacy = value;
                        _agreeToCollection = value;
                        _confirmAge = value;
                        _agreeToMarketing = value;
                      }),
                      title: '이용약관, 개인정보 수집 및 이용에 모두 동의합니다.',
                    ),
                    const SizedBox(height: 20),

                    // 이용약관 동의 (필수)
                    _buildCheckboxItem(
                      value: _agreeToPrivacy,
                      onChanged: (value) => setState(() {
                        _agreeToPrivacy = value!;
                      }),
                      title: '이용약관 동의',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),

                    // 약관 내용 박스
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '제1조 목적',
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '본 이용약관은 "할두"(이하 "사이트")의',
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 개인정보 수집 및 이용 동의 (필수)
                    _buildCheckboxItem(
                      value: _agreeToCollection,
                      onChanged: (value) => setState(() {
                        _agreeToCollection = value!;
                      }),
                      title: '개인정보 수집 및 이용 동의',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),

                    // 개인정보 수집 내용 박스
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1. 개인정보 수집목적 및 이용목적',
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '(1) 홈페이지 회원 가입 및 관리',
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 마케팅 정보 수신 동의 (선택)
                    _buildCheckboxItem(
                      value: _agreeToMarketing,
                      onChanged: (value) => setState(() => _agreeToMarketing = value!),
                      title: '마케팅 정보 수신 동의 (선택)',
                    ),
                    const SizedBox(height: 20),

                    // 만 14세 이상 확인 (필수)
                    _buildCheckboxItem(
                      value: _confirmAge,
                      onChanged: (value) => setState(() {
                        _confirmAge = value!;
                      }),
                      title: '만 14세 이상입니다.',
                      isRequired: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 버튼들
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canSubmit
                        ? () => Navigator.of(context).pop(true)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canSubmit
                          ? const Color(0xFF2ECC71)
                          : Colors.grey[400],
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
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem({
    required bool value,
    required void Function(bool?) onChanged,
    required String title,
    bool isRequired = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          margin: const EdgeInsets.only(top: 2),
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2ECC71),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            side: BorderSide(
              color: value ? const Color(0xFF2ECC71) : Colors.grey[400]!,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text.rich(
              TextSpan(
                text: title,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                children: isRequired
                    ? [
                        TextSpan(
                          text: ' (필수)',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}