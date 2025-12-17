part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<Order> orders;

  const OrdersLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class OrderCreated extends OrderState {
  final Order order;

  const OrderCreated({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderUpdated extends OrderState {
  final Order order;

  const OrderUpdated({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderCancelled extends OrderState {
  final Order order;

  const OrderCancelled({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderDetailsLoaded extends OrderState {
  final Order order;

  const OrderDetailsLoaded({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object> get props => [message];
}