import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/contents_section.dart';
import '../widgets/shop_section.dart';
import '../widgets/footer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 스크롤 가능한 콘텐츠
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const HeroSection(),
                const AboutSection(),
                const ContentsSection(),
                const ShopSection(),
                const FooterWidget(),
              ],
            ),
          ),
          // 고정된 앱바
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarWidget(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
