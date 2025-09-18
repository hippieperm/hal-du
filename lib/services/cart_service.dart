import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  
  int get itemCount => _cartItems.fold(0, (total, item) => total + item.quantity);
  
  double get totalPrice => _cartItems.fold(0.0, (total, item) => total + item.totalPrice);
  
  bool get isEmpty => _cartItems.isEmpty;
  
  bool get isNotEmpty => _cartItems.isNotEmpty;

  void addToCart(Product product, {int quantity = 1}) {
    print('CartService.addToCart called with product: ${product.name} (ID: ${product.id})');
    
    if (product.id.isEmpty) {
      print('Error: Product ID is empty, cannot add to cart');
      return;
    }
    
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      print('Product already in cart, increasing quantity');
      _cartItems[existingIndex].quantity += quantity;
    } else {
      print('Adding new product to cart');
      final cartItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product.id,
        productName: product.name,
        productPrice: product.price,
        productImageUrl: product.imageUrl,
        productCategory: product.category,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      _cartItems.add(cartItem);
      print('Cart item added. New cart size: ${_cartItems.length}');
    }
    
    print('Total items in cart: ${itemCount}');
    notifyListeners();
  }

  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(cartItemId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void increaseQuantity(String cartItemId) {
    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String cartItemId) {
    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        removeFromCart(cartItemId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    if (productId.isEmpty) return false;
    return _cartItems.any((item) => item.productId == productId);
  }

  int getQuantityInCart(String productId) {
    final item = _cartItems.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(
        id: '',
        productId: '',
        productName: '',
        productPrice: 0,
        productImageUrl: '',
        productCategory: '',
        quantity: 0,
        addedAt: DateTime.now(),
      ),
    );
    return item.quantity;
  }

  CartItem? getCartItem(String productId) {
    try {
      return _cartItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }
}