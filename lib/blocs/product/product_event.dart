part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadProduct extends ProductEvent {
  final String productId;

  const LoadProduct({required this.productId});

  @override
  List<Object> get props => [productId];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object> get props => [query];
}

class FilterProducts extends ProductEvent {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? inStockOnly;
  final bool? organicOnly;
  final bool? discountedOnly;

  const FilterProducts({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.inStockOnly,
    this.organicOnly,
    this.discountedOnly,
  });

  @override
  List<Object?> get props => [
        category,
        minPrice,
        maxPrice,
        minRating,
        inStockOnly,
        organicOnly,
        discountedOnly,
      ];
}

class LoadProductsByCategory extends ProductEvent {
  final String category;

  const LoadProductsByCategory({required this.category});

  @override
  List<Object> get props => [category];
}

class LoadFeaturedProducts extends ProductEvent {}

class LoadRecommendedProducts extends ProductEvent {}