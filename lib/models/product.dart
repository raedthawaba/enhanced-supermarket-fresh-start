import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final List<String> images;
  final String unit;
  final double stockQuantity;
  final double minStockLevel;
  final bool isAvailable;
  final bool isOrganic;
  final bool isDiscounted;
  final double? discountPercentage;
  final String? barcode;
  final String? brand;
  final double weight;
  final String weightUnit;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime? expiryDate;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.images = const [],
    this.unit = 'قطعة',
    this.stockQuantity = 0,
    this.minStockLevel = 5,
    this.isAvailable = true,
    this.isOrganic = false,
    this.isDiscounted = false,
    this.discountPercentage,
    this.barcode,
    this.brand,
    this.weight = 0,
    this.weightUnit = 'جرام',
    this.tags = const [],
    this.rating = 0,
    this.reviewCount = 0,
    required this.createdAt,
    this.expiryDate,
    this.isFeatured = false,
  });

  double get discountPrice {
    if (isDiscounted && discountPercentage != null) {
      return price * (1 - discountPercentage! / 100);
    }
    return price;
  }

  bool get isLowStock => stockQuantity <= minStockLevel;
  bool get isOutOfStock => stockQuantity <= 0;

  String get displayPrice {
    return '${price.toStringAsFixed(2)} ر.س';
  }

  String get displayOldPrice {
    if (oldPrice != null) {
      return '${oldPrice!.toStringAsFixed(2)} ر.س';
    }
    return '';
  }

  String get displayDiscountPrice {
    if (isDiscounted) {
      return '${discountPrice.toStringAsFixed(2)} ر.س';
    }
    return displayPrice;
  }

  String get stockStatus {
    if (isOutOfStock) return 'غير متوفر';
    if (isLowStock) return 'كمية قليلة';
    return 'متوفر';
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    double? oldPrice,
    String? imageUrl,
    List<String>? images,
    String? unit,
    double? stockQuantity,
    double? minStockLevel,
    bool? isAvailable,
    bool? isOrganic,
    bool? isDiscounted,
    double? discountPercentage,
    String? barcode,
    String? brand,
    double? weight,
    String? weightUnit,
    List<String>? tags,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? expiryDate,
    bool? isFeatured,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      unit: unit ?? this.unit,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      isAvailable: isAvailable ?? this.isAvailable,
      isOrganic: isOrganic ?? this.isOrganic,
      isDiscounted: isDiscounted ?? this.isDiscounted,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      barcode: barcode ?? this.barcode,
      brand: brand ?? this.brand,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      expiryDate: expiryDate ?? this.expiryDate,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'oldPrice': oldPrice,
      'imageUrl': imageUrl,
      'images': images,
      'unit': unit,
      'stockQuantity': stockQuantity,
      'minStockLevel': minStockLevel,
      'isAvailable': isAvailable,
      'isOrganic': isOrganic,
      'isDiscounted': isDiscounted,
      'discountPercentage': discountPercentage,
      'barcode': barcode,
      'brand': brand,
      'weight': weight,
      'weightUnit': weightUnit,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'isFeatured': isFeatured,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      oldPrice: json['oldPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      images: List<String>.from(json['images'] ?? []),
      unit: json['unit'] ?? 'قطعة',
      stockQuantity: json['stockQuantity']?.toDouble() ?? 0,
      minStockLevel: json['minStockLevel']?.toDouble() ?? 5,
      isAvailable: json['isAvailable'] ?? true,
      isOrganic: json['isOrganic'] ?? false,
      isDiscounted: json['isDiscounted'] ?? false,
      discountPercentage: json['discountPercentage']?.toDouble(),
      barcode: json['barcode'],
      brand: json['brand'],
      weight: json['weight']?.toDouble() ?? 0,
      weightUnit: json['weightUnit'] ?? 'جرام',
      tags: List<String>.from(json['tags'] ?? []),
      rating: json['rating']?.toDouble() ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate']) 
          : null,
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        price,
        oldPrice,
        imageUrl,
        images,
        unit,
        stockQuantity,
        minStockLevel,
        isAvailable,
        isOrganic,
        isDiscounted,
        discountPercentage,
        barcode,
        brand,
        weight,
        weightUnit,
        tags,
        rating,
        reviewCount,
        createdAt,
        expiryDate,
        isFeatured,
      ];
}