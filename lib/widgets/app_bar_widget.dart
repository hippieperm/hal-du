import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'signup_dialog.dart';
import 'login_dialog.dart';
import '../services/auth_service.dart';

class AppBarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isTransparent;
  final VoidCallback? onLogoTapped;

  const AppBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.isTransparent = false,
    this.onLogoTapped,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool _isAboutHovered = false;
  bool _isContentsHovered = false;
  bool _isShopHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 80,
      decoration: BoxDecoration(
        color: widget.isTransparent ? Colors.transparent : Colors.white,
        boxShadow: [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 로고
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onLogoTapped ??
                    () {
                      // 기본 동작: 홈으로 이동
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/',
                        (route) => false,
                      );
                    },
                child: Text(
                  '할두',
                  style: GoogleFonts.notoSans(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2ECC71), // 이미지의 초록색
                  ),
                ),
              ),
            ),

            // 데스크톱 네비게이션
            if (MediaQuery.of(context).size.width > 768)
              Row(
                children: [
                  _buildAboutNavItem(),
                  const SizedBox(width: 40),
                  _buildContentsNavItem(),
                  const SizedBox(width: 40),
                  _buildShopNavItem(),
                ],
              ),

            // 우측 버튼들
            Row(
              children: [
                Consumer<AuthService>(
                  builder: (context, authService, _) {
                    if (authService.isLoggedIn) {
                      return Row(
                        children: [
                          Text(
                            '${authService.currentUser?.name ?? ''}님',
                            style: GoogleFonts.notoSans(
                              color: widget.isTransparent
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () async {
                              await authService.logout();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('로그아웃되었습니다.')),
                                );
                              }
                            },
                            child: Text(
                              '로그아웃',
                              style: GoogleFonts.notoSans(
                                color: widget.isTransparent
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const LoginDialog(),
                              );
                            },
                            child: Text(
                              '로그인',
                              style: GoogleFonts.notoSans(
                                color: widget.isTransparent
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const SignupDialog(),
                              );
                            },
                            child: Text(
                              '회원가입',
                              style: GoogleFonts.notoSans(
                                color: widget.isTransparent
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    '장바구니',
                    style: GoogleFonts.notoSans(
                      color:
                          widget.isTransparent ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),

                // 모바일 메뉴 버튼
                if (MediaQuery.of(context).size.width <= 768)
                  IconButton(
                    onPressed: () {
                      // 모바일 메뉴 열기
                    },
                    icon: Icon(
                      Icons.menu,
                      color:
                          widget.isTransparent ? Colors.white : Colors.black87,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ABOUT 전용 네비게이션 아이템 (호버 효과 포함)
  Widget _buildAboutNavItem() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isAboutHovered = true),
      onExit: (_) => setState(() => _isAboutHovered = false),
      child: GestureDetector(
        onTap: () => widget.onItemTapped(0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 150,
          child: Center(
            child: Text(
              _isAboutHovered ? '할두란?' : 'ABOUT',
              style: GoogleFonts.notoSans(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _isAboutHovered
                    ? const Color(0xFF2ECC71) // 호버 시 지정된 녹색
                    : widget.isTransparent
                        ? (widget.selectedIndex == 0
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.9))
                        : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // CONTENTS 전용 네비게이션 아이템 (호버 효과 포함)
  Widget _buildContentsNavItem() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isContentsHovered = true),
      onExit: (_) => setState(() => _isContentsHovered = false),
      child: GestureDetector(
        onTap: () => widget.onItemTapped(1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 150,
          child: Center(
            child: Text(
              _isContentsHovered ? '콘텐츠' : 'CONTENTS',
              style: GoogleFonts.notoSans(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _isContentsHovered
                    ? const Color(0xFF2ECC71) // 호버 시 녹색
                    : widget.isTransparent
                        ? (widget.selectedIndex == 1
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.9))
                        : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // SHOP 전용 네비게이션 아이템 (호버 효과 포함)
  Widget _buildShopNavItem() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isShopHovered = true),
      onExit: (_) => setState(() => _isShopHovered = false),
      child: GestureDetector(
        onTap: () => widget.onItemTapped(2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 150,
          child: Center(
            child: Text(
              _isShopHovered ? '쇼핑' : 'SHOP',
              style: GoogleFonts.notoSans(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _isShopHovered
                    ? const Color(0xFF2ECC71) // 호버 시 녹색
                    : widget.isTransparent
                        ? (widget.selectedIndex == 2
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.9))
                        : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
