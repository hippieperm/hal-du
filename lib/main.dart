import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contents_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/content_detail_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "your-api-key", // TODO: 실제 값으로 변경
      authDomain: "your-project.firebaseapp.com",
      projectId: "your-project-id",
      storageBucket: "your-project.appspot.com",
      messagingSenderId: "123456789",
      appId: "your-app-id",
    ),
  );
  
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
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
