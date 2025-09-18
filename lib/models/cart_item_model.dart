class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double productPrice;
  final String productImageUrl;
  final String productCategory;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    required this.productCategory,
    required this.quantity,
    required this.addedAt,
  });

  double get totalPrice => productPrice * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImageUrl': productImageUrl,
      'productCategory': productCategory,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productPrice: (json['productPrice'] ?? 0).toDouble(),
      productImageUrl: json['productImageUrl'] ?? '',
      productCategory: json['productCategory'] ?? '',
      quantity: json['quantity'] ?? 1,
      addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
    );
  }

  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    double? productPrice,
    String? productImageUrl,
    String? productCategory,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      productCategory: productCategory ?? this.productCategory,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}