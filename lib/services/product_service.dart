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
        name: '마음까지 강화되는 요가 ( 50대 60대 온라인 요가 클래스 )',
        price: 10000,
        description: '건강한 50대, 60대를 위한 맞춤형 요가 클래스입니다.',
        imageUrl: 'assets/images/grandmother.jpg',
        category: '전체',
        stock: 10,
        additionalImages: [
          'assets/images/hero_image_1.jpg',
          'assets/images/hero_image_2.jpg',
        ],
        detailDescription: '할두 도서로 구성된 3권 책자를 바탕으로 다양한 인생 첫 시작을 만들어 나갈 수 있는 내용입니다. 책자와 부교재를 통해 즐겁고 의미있는 시간을 보낼 수 있습니다.',
        shippingInfo: '무료배송',
        refundPolicy: '1. 공정거래 위원회가 정하는 소비자 분쟁 해결기준에 의해 교환, 환불이 가능합니다.\n2. 상품에 하자가 있을 경우 구매일로부터 30일 이내에 교환, 환불이 가능합니다.\n3. 고객 변심으로 인한 취소의 경우 7일 이내에 취소 접수를 해주셔야 합니다.\n4. 단순 변심 취소의 경우 실제 출고 후 왕복 배송료가 부과됩니다.',
        options: '클럽명 (필수)',
        isNew: true,
        likes: 12,
      ),
      Product(
        id: '',
        name: '건강한 인생 2막을 위한 영양 가이드북',
        price: 25000,
        description: '50대 이후 건강한 삶을 위한 영양 관리 지침서',
        imageUrl: 'assets/images/grandmother.jpg',
        category: '전체',
        stock: 5,
        additionalImages: [
          'assets/images/hero_image_1.jpg',
        ],
        detailDescription: '전문 영양사가 집필한 50대 이후 건강 관리를 위한 실용적인 가이드북입니다.',
        shippingInfo: '무료배송',
        refundPolicy: '공정거래 위원회 기준에 따른 교환/환불 가능',
        isNew: false,
        likes: 8,
      ),
      Product(
        id: '',
        name: '[할두 특별판] 인생 2막 스타터 키트',
        price: 45000,
        description: '새로운 시작을 위한 할두 오리지널 패키지',
        imageUrl: 'assets/images/grandmother.jpg',
        category: '전체',
        stock: 15,
        additionalImages: [
          'assets/images/hero_image_1.jpg',
          'assets/images/hero_image_2.jpg',
        ],
        detailDescription: '할두만의 특별한 컨텐츠로 구성된 인생 2막 시작을 위한 종합 패키지입니다.',
        shippingInfo: '무료배송',
        refundPolicy: '구매 후 7일 이내 교환/환불 가능 (단순 변심 시 배송비 고객 부담)',
        options: '스타터 키트 구성 (고정)',
        isNew: true,
        likes: 25,
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