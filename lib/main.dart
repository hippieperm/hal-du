import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contents_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/product_detail_screen.dart';
import 'services/auth_service.dart';
//test
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const HaldoApp(),
    ),
  );
}

class HaldoApp extends StatelessWidget {
  const HaldoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '할두 - 할머니가 되어서도 두근두근!',
      theme: ThemeData(
        primarySwatch: Colors.pink,₩
        textTheme: GoogleFonts.notoSansTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/contents': (context) => const ContentsScreen(),
        '/shop': (context) => const ShopScreen(),
        '/product-detail': (context) => const ProductDetailScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
