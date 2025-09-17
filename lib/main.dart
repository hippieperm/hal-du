import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_config.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contents_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/content_detail_screen.dart';
import 'services/auth_service.dart';
import 'services/product_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화
  await Firebase.initializeApp(
    options: FirebaseConfig.firebaseOptions,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ProductService()),
      ],
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
        primarySwatch: Colors.pink,
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
      onGenerateRoute: (settings) {
        if (settings.name == '/content-detail') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => ContentDetailScreen(
              contentId: args?['contentId'] ?? 'unknown',
            ),
          );
        } else if (settings.name == '/product-detail') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: args?['productId'] as String?,
            ),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
