import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProductService() {
    _initProductService();
  }

  void _initProductService() {
    print('🔥 ProductService: Initializing Firestore listener...');
    
    // Firestore 실시간 리스너 설정
    _firestore.collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      print('🔥 ProductService: Received snapshot with ${snapshot.docs.length} documents');
      
      _products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        print('🔥 ProductService: Processing product: ${data['name']}');
        return Product.fromJson(data);
      }).toList();
      
      print('🔥 ProductService: Total products loaded: ${_products.length}');
      notifyListeners();
    }, onError: (error) {
      _errorMessage = 'Firestore 연결 오류: $error';
      print('❌ ProductService: Firestore error: $error');
      notifyListeners();
    });
  }

  List<Product> getProductsByCategory(String category) {
    if (category == '전체') {
      return products;
    }
    return products.where((product) => product.category == category).toList();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addProduct(Product product) async {
    print('🔥 ProductService: Starting addProduct for: ${product.name}');
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newProduct = product.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('🔥 ProductService: Product data to add: ${newProduct.toJson()}');

      // Firestore에 상품 추가 (id는 자동 생성)
      final docRef = await _firestore.collection(_collection).add(newProduct.toJson());
      
      print('🔥 ProductService: Successfully added product with ID: ${docRef.id}');
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '상품 추가 중 오류가 발생했습니다: $e';
      print('❌ ProductService: Error adding product: $e');
      print('❌ ProductService: Error type: ${e.runtimeType}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedProduct = product.copyWith(
        updatedAt: DateTime.now(),
      );

      // Firestore에서 상품 업데이트
      await _firestore.collection(_collection)
          .doc(product.id)
          .update(updatedProduct.toJson());
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '상품 수정 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Firestore에서 상품 삭제
      await _firestore.collection(_collection).doc(productId).delete();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '상품 삭제 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 초기 샘플 데이터 추가 (개발용)
  Future<void> addSampleProducts() async {
    print('🔥 ProductService: Starting to add sample products...');
    
    final sampleProducts = [
      Product(
        id: '',
        name: '낙담 줄인 내천함 헤어 (50대 60대 점감 세이 향감 5마)',
        price: 33000,
        description: '할두 줄인 내천함 헤어 (50대 60대 점감 세이 향감 5마)',
        imageUrl: 'assets/images/grandmother.jpg',
        category: '전체',
        stock: 10,
      ),
      Product(
        id: '',
        name: '마행하지 감동되는 굉가 ( 50대 60대 종감은 감감 종점 )',
        price: 10000,
        description: '마행하지 감동되는 굉가 ( 50대 60대 종감은 감감 종점 )',
        imageUrl: 'assets/images/grandmother.jpg',
        category: '전체',
        stock: 5,
      ),
      Product(
        id: '',
        name: '[해기가히] 실가되는 챗감리 내인네 - 사진집',
        price: 82000,
        description: '[해기가히] 실가되는 챗감리 내인네 - 사진집',
        imageUrl: 'assets/images/grandmother.jpg',
        category: '전체',
        stock: 3,
      ),
    ];

    print('🔥 ProductService: Adding ${sampleProducts.length} sample products');

    for (int i = 0; i < sampleProducts.length; i++) {
      final product = sampleProducts[i];
      print('🔥 ProductService: Adding sample product ${i + 1}/${sampleProducts.length}: ${product.name}');
      final success = await addProduct(product);
      if (success) {
        print('✅ ProductService: Sample product ${i + 1} added successfully');
      } else {
        print('❌ ProductService: Failed to add sample product ${i + 1}');
      }
    }
    
    print('🔥 ProductService: Finished adding sample products');
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}