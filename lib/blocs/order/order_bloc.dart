import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_app/models/order.dart';
import 'package:supermarket_app/models/cart.dart';
import 'package:supermarket_app/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrderLoading()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CancelOrder>(_onCancelOrder);
    on<LoadOrderDetails>(_onLoadOrderDetails);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      
      final orders = await _orderRepository.getUserOrders();
      
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      
      final order = await _orderRepository.createOrder(
        cart: event.cart,
        deliveryAddress: event.deliveryAddress,
        deliveryInstructions: event.deliveryInstructions,
        paymentMethod: event.paymentMethod,
      );
      
      emit(OrderCreated(order: order));
      
      // Reload orders after creating new one
      final orders = await _orderRepository.getUserOrders();
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      
      final updatedOrder = await _orderRepository.updateOrderStatus(
        orderId: event.orderId,
        status: event.status,
      );
      
      emit(OrderUpdated(order: updatedOrder));
      
      // Reload orders to reflect changes
      final orders = await _orderRepository.getUserOrders();
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      
      final cancelledOrder = await _orderRepository.cancelOrder(
        orderId: event.orderId,
        reason: event.reason,
      );
      
      emit(OrderCancelled(order: cancelledOrder));
      
      // Reload orders to reflect changes
      final orders = await _orderRepository.getUserOrders();
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrderState> emit,
  ) async {
    try {
      if (state is OrdersLoaded) {
        final currentState = state as OrdersLoaded;
        final order = currentState.orders.firstWhere(
          (o) => o.id == event.orderId,
          orElse: () => throw Exception('Order not found'),
        );
        
        emit(OrderDetailsLoaded(order: order));
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }
}