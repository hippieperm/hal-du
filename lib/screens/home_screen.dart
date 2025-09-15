import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/footer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  bool _isAppBarTransparent = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isAppBarTransparent = _scrollController.offset < 50;
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // ABOUT 페이지로 이동
      Navigator.pushNamed(context, '/about');
    } else if (index == 1) {
      // CONTENTS 페이지로 이동
      Navigator.pushNamed(context, '/contents');
    } else if (index == 2) {
      // SHOP 페이지로 이동
      Navigator.pushNamed(context, '/shop');
    }
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
              isTransparent: _isAppBarTransparent,
            ),
          ),
        ],
      ),
    );
  }
}
