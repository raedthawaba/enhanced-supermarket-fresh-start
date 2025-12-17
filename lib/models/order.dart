import 'package:equatable/equatable.dart';
import 'package:supermarket_app/models/product.dart';

class OrderItem extends Equatable {
  final String id;
  final Product product;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const OrderItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  OrderItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
  }) {
    return OrderItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, product, quantity, unitPrice, totalPrice];
}

class Order extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final OrderStatus status;
  final double subtotal;
  final double discountAmount;
  final double deliveryFee;
  final double tax;
  final double totalAmount;
  final String? appliedCoupon;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final String? paymentId;
  final String? deliveryPersonId;
  final DateTime orderDate;
  final DateTime? estimatedDeliveryDate;
  final DateTime? deliveredDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.discountAmount,
    required this.deliveryFee,
    required this.tax,
    required this.totalAmount,
    this.appliedCoupon,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paymentId,
    this.deliveryPersonId,
    required this.orderDate,
    this.estimatedDeliveryDate,
    this.deliveredDate,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  bool get isPending => status == OrderStatus.pending;
  bool get isConfirmed => status == OrderStatus.confirmed;
  bool get isPreparing => status == OrderStatus.preparing;
  bool get isReadyForDelivery => status == OrderStatus.readyForDelivery;
  bool get isOutForDelivery => status == OrderStatus.outForDelivery;
  bool get isDelivered => status == OrderStatus.delivered;
  bool get isCancelled => status == OrderStatus.cancelled;
  bool get isPaid => paymentStatus == PaymentStatus.paid;
  bool get isUnpaid => paymentStatus == PaymentStatus.unpaid;
  bool get isFailedPayment => paymentStatus == PaymentStatus.failed;

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'في الانتظار';
      case OrderStatus.confirmed:
        return 'مؤكد';
      case OrderStatus.preparing:
        return 'قيد التحضير';
      case OrderStatus.readyForDelivery:
        return 'جاهز للتوصيل';
      case OrderStatus.outForDelivery:
        return 'في الطريق';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }

  String get paymentStatusText {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'في انتظار الدفع';
      case PaymentStatus.paid:
        return 'تم الدفع';
      case PaymentStatus.unpaid:
        return 'لم يتم الدفع';
      case PaymentStatus.failed:
        return 'فشل في الدفع';
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return 'نقدي عند الاستلام';
      case PaymentMethod.visa:
        return 'فيزا';
      case PaymentMethod.mastercard:
        return 'ماستر كارد';
      case PaymentMethod.amex:
        return 'أمريكان إكسبرس';
      case PaymentMethod.mada:
        return 'مدى';
      case PaymentMethod.stcPay:
        return 'STC Pay';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.googlePay:
        return 'Google Pay';
      case PaymentMethod.paypal:
        return 'PayPal';
    }
  }

  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    OrderStatus? status,
    double? subtotal,
    double? discountAmount,
    double? deliveryFee,
    double? tax,
    double? totalAmount,
    String? appliedCoupon,
    String? deliveryAddress,
    String? deliveryInstructions,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    String? paymentId,
    String? deliveryPersonId,
    DateTime? orderDate,
    DateTime? estimatedDeliveryDate,
    DateTime? deliveredDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      totalAmount: totalAmount ?? this.totalAmount,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentId: paymentId ?? this.paymentId,
      deliveryPersonId: deliveryPersonId ?? this.deliveryPersonId,
      orderDate: orderDate ?? this.orderDate,
      estimatedDeliveryDate: estimatedDeliveryDate ?? this.estimatedDeliveryDate,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.toString(),
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'totalAmount': totalAmount,
      'appliedCoupon': appliedCoupon,
      'deliveryAddress': deliveryAddress,
      'deliveryInstructions': deliveryInstructions,
      'paymentMethod': paymentMethod.toString(),
      'paymentStatus': paymentStatus.toString(),
      'paymentId': paymentId,
      'deliveryPersonId': deliveryPersonId,
      'orderDate': orderDate.toIso8601String(),
      'estimatedDeliveryDate': estimatedDeliveryDate?.toIso8601String(),
      'deliveredDate': deliveredDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (status) => status.toString() == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      subtotal: json['subtotal'].toDouble(),
      discountAmount: json['discountAmount'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      tax: json['tax'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      appliedCoupon: json['appliedCoupon'],
      deliveryAddress: json['deliveryAddress'],
      deliveryInstructions: json['deliveryInstructions'],
      paymentMethod: PaymentMethod.values.firstWhere(
        (method) => method.toString() == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (status) => status.toString() == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentId: json['paymentId'],
      deliveryPersonId: json['deliveryPersonId'],
      orderDate: DateTime.parse(json['orderDate']),
      estimatedDeliveryDate: json['estimatedDeliveryDate'] != null
          ? DateTime.parse(json['estimatedDeliveryDate'])
          : null,
      deliveredDate: json['deliveredDate'] != null
          ? DateTime.parse(json['deliveredDate'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      notes: json['notes'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        status,
        subtotal,
        discountAmount,
        deliveryFee,
        tax,
        totalAmount,
        appliedCoupon,
        deliveryAddress,
        deliveryInstructions,
        paymentMethod,
        paymentStatus,
        paymentId,
        deliveryPersonId,
        orderDate,
        estimatedDeliveryDate,
        deliveredDate,
        createdAt,
        updatedAt,
        notes,
      ];
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  readyForDelivery,
  outForDelivery,
  delivered,
  cancelled,
}

enum PaymentMethod {
  cash,
  visa,
  mastercard,
  amex,
  mada,
  stcPay,
  applePay,
  googlePay,
  paypal,
}

enum PaymentStatus {
  pending,
  paid,
  unpaid,
  failed,
}