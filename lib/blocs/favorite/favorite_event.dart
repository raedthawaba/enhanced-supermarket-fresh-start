part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class AddToFavorites extends FavoriteEvent {
  final Product product;

  const AddToFavorites({required this.product});

  @override
  List<Object> get props => [product];
}

class RemoveFromFavorites extends FavoriteEvent {
  final String productId;

  const RemoveFromFavorites({required this.productId});

  @override
  List<Object> get props => [productId];
}

class ToggleFavorite extends FavoriteEvent {
  final String productId;

  const ToggleFavorite({required this.productId});

  @override
  List<Object> get props => [productId];
}