import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductService extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: '낙담 줄인 내천함 헤어 (50대 60대 점감 세이 향감 5마)',
      price: 33000,
      description: '할두 줄인 내천함 헤어 (50대 60대 점감 세이 향감 5마)',
      imageUrl: 'assets/images/grandmother.jpg',
      category: '전체',
      stock: 10,
      createdAt: DateTime.now(),
    ),
    Product(
      id: '2',
      name: '마행하지 감동되는 굉가 ( 50대 60대 종감은 감감 종점 )',
      price: 10000,
      description: '마행하지 감동되는 굉가 ( 50대 60대 종감은 감감 종점 )',
      imageUrl: 'assets/images/grandmother.jpg',
      category: '전체',
      stock: 5,
      createdAt: DateTime.now(),
    ),
    Product(
      id: '3',
      name: '[해기가히] 실가되는 챗감리 내인네 - 사진집',
      price: 82000,
      description: '[해기가히] 실가되는 챗감리 내인네 - 사진집',
      imageUrl: 'assets/images/grandmother.jpg',
      category: '전체',
      stock: 3,
      createdAt: DateTime.now(),
    ),
  ];

  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 시뮬레이션된 지연
      await Future.delayed(const Duration(milliseconds: 500));

      final newProduct = product.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '상품 추가 중 오류가 발생했습니다: $e';
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
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product.copyWith(
          updatedAt: DateTime.now(),
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('상품을 찾을 수 없습니다');
      }
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
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products.removeAt(index);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('상품을 찾을 수 없습니다');
      }
    } catch (e) {
      _errorMessage = '상품 삭제 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}