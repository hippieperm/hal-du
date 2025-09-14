import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.pink[50]!, Colors.white],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 메인 타이틀
            Text(
              '건강한 인생 2막, 할두와 함께 해요!',
              style: GoogleFonts.notoSans(
                fontSize: MediaQuery.of(context).size.width > 768 ? 48 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // 서브 타이틀
            Text(
              '할머니가 되어서도 두근두근',
              style: GoogleFonts.notoSans(
                fontSize: MediaQuery.of(context).size.width > 768 ? 24 : 18,
                fontWeight: FontWeight.w500,
                color: Colors.pink[600],
              ),
            ),

            const SizedBox(height: 10),

            // 브랜드명
            Text(
              '할두 haldo 있다!',
              style: GoogleFonts.notoSans(
                fontSize: MediaQuery.of(context).size.width > 768 ? 28 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.pink[700],
              ),
            ),

            const SizedBox(height: 40),

            // CTA 버튼
            ElevatedButton(
              onPressed: () {
                // 액션 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: Text(
                '지금 시작하기',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
