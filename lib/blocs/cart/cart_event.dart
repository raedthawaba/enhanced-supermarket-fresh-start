part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  final int quantity;

  const AddToCart({
    required this.product,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [product, quantity];
}

class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart({required this.productId});

  @override
  List<Object> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantity({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}

class ApplyCoupon extends CartEvent {
  final String couponCode;

  const ApplyCoupon({required this.couponCode});

  @override
  List<Object> get props => [couponCode];
}

class RemoveCoupon extends CartEvent {}

class UpdateCart extends CartEvent {
  final Cart cart;

  const UpdateCart({required this.cart});

  @override
  List<Object> get props => [cart];
}