part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {}

class CreateOrder extends OrderEvent {
  final Cart cart;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final PaymentMethod paymentMethod;

  const CreateOrder({
    required this.cart,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.paymentMethod,
  });

  @override
  List<Object> get props => [
        cart,
        deliveryAddress,
        deliveryInstructions ?? '',
        paymentMethod,
      ];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final OrderStatus status;

  const UpdateOrderStatus({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object> get props => [orderId, status];
}

class CancelOrder extends OrderEvent {
  final String orderId;
  final String? reason;

  const CancelOrder({
    required this.orderId,
    this.reason,
  });

  @override
  List<Object> get props => [orderId, reason ?? ''];
}

class LoadOrderDetails extends OrderEvent {
  final String orderId;

  const LoadOrderDetails({required this.orderId});

  @override
  List<Object> get props => [orderId];
}