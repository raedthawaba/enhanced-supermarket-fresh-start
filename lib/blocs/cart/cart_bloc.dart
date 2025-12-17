import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_app/models/cart.dart';
import 'package:supermarket_app/models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<ApplyCoupon>(_onApplyCoupon);
    on<RemoveCoupon>(_onRemoveCoupon);
    on<UpdateCart>(_onUpdateCart);
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartLoading());
      
      // Load cart from local storage
      // For now, we'll start with an empty cart
      final cart = Cart(
        items: [],
        lastUpdated: DateTime.now(),
      );
      
      emit(CartLoaded(cart: cart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) return;
      
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = currentCart.addItem(
        event.product,
        quantity: event.quantity,
      );
      
      emit(CartLoaded(cart: updatedCart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) return;
      
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = currentCart.removeItem(event.productId);
      
      emit(CartLoaded(cart: updatedCart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) return;
      
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = currentCart.updateQuantity(
        event.productId,
        event.quantity,
      );
      
      emit(CartLoaded(cart: updatedCart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) return;
      
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = currentCart.clear();
      
      emit(CartLoaded(cart: updatedCart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onApplyCoupon(
    ApplyCoupon event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) return;
      
      final currentCart = (state as CartLoaded).cart;
      
      // Validate coupon (this would be more sophisticated in a real app)
      double discount = 0;
      if (event.couponCode == 'WELCOME10') {
        discount = currentCart.subtotal * 0.10; // 10% discount
      } else if (event.couponCode == 'SAVE20') {
        discount = 20.0; // Fixed 20 SAR discount
      }
      
      final updatedCart = currentCart.applyCoupon(
        event.couponCode,
        discount,
      );
      
      emit(CartLoaded(cart: updatedCart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onRemoveCoupon(
    RemoveCoupon event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) return;
      
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = currentCart.removeCoupon();
      
      emit(CartLoaded(cart: updatedCart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onUpdateCart(
    UpdateCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) return;
      
      final updatedCart = event.cart;
      emit(CartLoaded(cart: updatedCart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}