import 'package:flutter/material.dart';
import 'footer_section.dart';

class FooterUsageExample extends StatelessWidget {
  const FooterUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Footer Demo'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 페이지 컨텐츠 예시
            Container(
              height: 600,
              color: Colors.grey[100],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '페이지 컨텐츠',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '아래로 스크롤하여 푸터를 확인해보세요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 푸터 섹션
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

// 메인 앱에 푸터를 포함한 전체 페이지 예시
class MainPageWithFooter extends StatelessWidget {
  const MainPageWithFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 히어로 섹션 등 다른 컨텐츠
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.blue[50],
              child: const Center(
                child: Text(
                  '메인 컨텐츠 영역',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),

            // 추가 섹션들
            Container(
              height: 400,
              color: Colors.green[50],
              child: const Center(
                child: Text(
                  '서비스 소개 섹션',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),

            Container(
              height: 400,
              color: Colors.orange[50],
              child: const Center(
                child: Text(
                  '기능 설명 섹션',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),

            // 푸터
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}