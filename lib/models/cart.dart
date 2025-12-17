import 'package:equatable/equatable.dart';
import 'package:supermarket_app/models/product.dart';

class CartItem extends Equatable {
  final String id;
  final Product product;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;
  double get totalDiscountPrice => product.discountPrice * quantity;
  double get totalSavings => (product.price - product.discountPrice) * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  CartItem incrementQuantity() {
    return copyWith(quantity: quantity + 1);
  }

  CartItem decrementQuantity() {
    if (quantity > 1) {
      return copyWith(quantity: quantity - 1);
    }
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  @override
  List<Object?> get props => [id, product, quantity, addedAt];
}

class Cart extends Equatable {
  final List<CartItem> items;
  final String? appliedCoupon;
  final double? discountAmount;
  final DateTime lastUpdated;

  const Cart({
    this.items = const [],
    this.appliedCoupon,
    this.discountAmount,
    required this.lastUpdated,
  });

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  int get itemCount => items.length;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get discountTotal => items.fold(0, (sum, item) => sum + item.totalSavings);
  double get couponDiscount => discountAmount ?? 0;
  double get deliveryFee => subtotal > 100 ? 0 : 15; // مجاني للطلبات أكثر من 100 ريال
  double get tax => subtotal * 0.15; // ضريبة القيمة المضافة 15%
  
  double get total {
    final subtotalAfterDiscounts = subtotal - discountTotal - couponDiscount;
    return subtotalAfterDiscounts + deliveryFee + tax;
  }

  bool get hasAppliedCoupon => appliedCoupon != null;
  bool get hasDiscount => discountTotal > 0 || couponDiscount > 0;
  bool get hasFreeDelivery => subtotal > 100;

  CartItem? getItem(String productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  bool containsProduct(String productId) {
    return items.any((item) => item.product.id == productId);
  }

  Cart addItem(Product product, {int quantity = 1}) {
    final existingItemIndex = items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex]
          .copyWith(quantity: updatedItems[existingItemIndex].quantity + quantity);
      
      return copyWith(
        items: updatedItems,
        lastUpdated: DateTime.now(),
      );
    } else {
      final newItem = CartItem(
        id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      
      return copyWith(
        items: [...items, newItem],
        lastUpdated: DateTime.now(),
      );
    }
  }

  Cart removeItem(String productId) {
    final updatedItems = items.where((item) => item.product.id != productId).toList();
    return copyWith(
      items: updatedItems,
      lastUpdated: DateTime.now(),
    );
  }

  Cart updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      return removeItem(productId);
    }

    final updatedItems = items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    return copyWith(
      items: updatedItems,
      lastUpdated: DateTime.now(),
    );
  }

  Cart clear() {
    return copyWith(
      items: [],
      appliedCoupon: null,
      discountAmount: 0,
      lastUpdated: DateTime.now(),
    );
  }

  Cart applyCoupon(String couponCode, double discount) {
    return copyWith(
      appliedCoupon: couponCode,
      discountAmount: discount,
      lastUpdated: DateTime.now(),
    );
  }

  Cart removeCoupon() {
    return copyWith(
      appliedCoupon: null,
      discountAmount: 0,
      lastUpdated: DateTime.now(),
    );
  }

  Cart copyWith({
    List<CartItem>? items,
    String? appliedCoupon,
    double? discountAmount,
    DateTime? lastUpdated,
  }) {
    return Cart(
      items: items ?? this.items,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      discountAmount: discountAmount ?? this.discountAmount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'appliedCoupon': appliedCoupon,
      'discountAmount': discountAmount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      appliedCoupon: json['appliedCoupon'],
      discountAmount: json['discountAmount']?.toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  @override
  List<Object?> get props => [
        items,
        appliedCoupon,
        discountAmount,
        lastUpdated,
      ];
}