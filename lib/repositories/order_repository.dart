import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermarket_app/models/order.dart';
import 'package:supermarket_app/models/cart.dart';
import 'package:supermarket_app/models/product.dart';
import 'package:supermarket_app/utils/constants.dart';

class OrderRepository {
  static const String _ordersKey = 'user_orders';

  Future<List<Order>> getUserOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString(_ordersKey);
    
    if (ordersJson == null) {
      return [];
    }
    
    try {
      final List<dynamic> ordersList = json.decode(ordersJson);
      return ordersList.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Order> createOrder({
    required Cart cart,
    required String deliveryAddress,
    String? deliveryInstructions,
    required PaymentMethod paymentMethod,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (cart.items.isEmpty) {
      throw Exception('السلة فارغة');
    }

    // Calculate totals
    final subtotal = cart.subtotal;
    final discountAmount = cart.discountTotal + (cart.couponDiscount ?? 0);
    final deliveryFee = cart.deliveryFee;
    final tax = cart.tax;
    final totalAmount = subtotal - discountAmount + deliveryFee + tax;

    // Create order items
    final orderItems = cart.items.map((cartItem) {
      return OrderItem(
        id: '${cartItem.product.id}_${DateTime.now().millisecondsSinceEpoch}',
        product: cartItem.product,
        quantity: cartItem.quantity,
        unitPrice: cartItem.product.price,
        totalPrice: cartItem.totalPrice,
      );
    }).toList();

    // Create order
    final order = Order(
      id: 'ORD_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user', // In real app, get from auth
      items: orderItems,
      status: OrderStatus.pending,
      subtotal: subtotal,
      discountAmount: discountAmount,
      deliveryFee: deliveryFee,
      tax: tax,
      totalAmount: totalAmount,
      appliedCoupon: cart.appliedCoupon,
      deliveryAddress: deliveryAddress,
      deliveryInstructions: deliveryInstructions,
      paymentMethod: paymentMethod,
      paymentStatus: paymentMethod == PaymentMethod.cash 
          ? PaymentStatus.unpaid 
          : PaymentStatus.pending,
      orderDate: DateTime.now(),
      estimatedDeliveryDate: DateTime.now().add(const Duration(hours: 2)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save order
    await _saveOrder(order);
    
    return order;
  }

  Future<Order> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final orders = await getUserOrders();
    final orderIndex = orders.indexWhere((order) => order.id == orderId);
    
    if (orderIndex == -1) {
      throw Exception('الطلب غير موجود');
    }

    final updatedOrder = orders[orderIndex].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    orders[orderIndex] = updatedOrder;
    await _saveOrdersList(orders);

    return updatedOrder;
  }

  Future<Order> cancelOrder({
    required String orderId,
    String? reason,
  }) async {
    return updateOrderStatus(
      orderId: orderId,
      status: OrderStatus.cancelled,
    );
  }

  Future<Order?> getOrderById(String orderId) async {
    final orders = await getUserOrders();
    
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveOrder(Order order) async {
    final orders = await getUserOrders();
    orders.insert(0, order); // Add to beginning (most recent first)
    await _saveOrdersList(orders);
  }

  Future<void> _saveOrdersList(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = json.encode(orders.map((order) => order.toJson()).toList());
    await prefs.setString(_ordersKey, ordersJson);
  }

  // Helper methods for analytics
  Future<Map<String, dynamic>> getOrderStats() async {
    final orders = await getUserOrders();
    
    final totalOrders = orders.length;
    final completedOrders = orders.where((order) => order.isDelivered).length;
    final pendingOrders = orders.where((order) => order.isPending || order.isConfirmed).length;
    final cancelledOrders = orders.where((order) => order.isCancelled).length;
    
    final totalSpent = orders
        .where((order) => order.isDelivered)
        .fold(0.0, (double sum, Order order) => sum + order.totalAmount);
    
    return {
      'totalOrders': totalOrders,
      'completedOrders': completedOrders,
      'pendingOrders': pendingOrders,
      'cancelledOrders': cancelledOrders,
      'totalSpent': totalSpent,
    };
  }

  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    final orders = await getUserOrders();
    return orders.where((order) => order.status == status).toList();
  }

  Future<double> getTotalSpent() async {
    final orders = await getUserOrders();
    return orders
        .where((order) => order.isDelivered)
        .fold(0.0, (double sum, Order order) => sum + order.totalAmount);
  }

  Future<int> getOrderCount() async {
    final orders = await getUserOrders();
    return orders.length;
  }
}