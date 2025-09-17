class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String category;
  final int? stock;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? additionalImages;
  final String? detailDescription;
  final String? shippingInfo;
  final String? refundPolicy;
  final String? options;
  final bool? isNew;
  final int? likes;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.stock,
    this.createdAt,
    this.updatedAt,
    this.additionalImages,
    this.detailDescription,
    this.shippingInfo,
    this.refundPolicy,
    this.options,
    this.isNew,
    this.likes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      stock: json['stock'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      additionalImages: json['additionalImages'] != null
          ? List<String>.from(json['additionalImages'])
          : null,
      detailDescription: json['detailDescription'],
      shippingInfo: json['shippingInfo'],
      refundPolicy: json['refundPolicy'],
      options: json['options'],
      isNew: json['isNew'],
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'additionalImages': additionalImages,
      'detailDescription': detailDescription,
      'shippingInfo': shippingInfo,
      'refundPolicy': refundPolicy,
      'options': options,
      'isNew': isNew,
      'likes': likes,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    String? category,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? additionalImages,
    String? detailDescription,
    String? shippingInfo,
    String? refundPolicy,
    String? options,
    bool? isNew,
    int? likes,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalImages: additionalImages ?? this.additionalImages,
      detailDescription: detailDescription ?? this.detailDescription,
      shippingInfo: shippingInfo ?? this.shippingInfo,
      refundPolicy: refundPolicy ?? this.refundPolicy,
      options: options ?? this.options,
      isNew: isNew ?? this.isNew,
      likes: likes ?? this.likes,
    );
  }
}