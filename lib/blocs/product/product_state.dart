part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final Product product;

  const ProductLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final List<Product>? filteredProducts;
  final String? searchQuery;
  final Map<String, dynamic>? activeFilters;

  const ProductsLoaded({
    required this.products,
    this.filteredProducts,
    this.searchQuery,
    this.activeFilters,
  });

  List<Product> get displayProducts {
    return filteredProducts ?? products;
  }

  bool get hasActiveFilters {
    return activeFilters != null && activeFilters!.isNotEmpty;
  }

  bool get hasSearchQuery {
    return searchQuery != null && searchQuery!.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        products,
        filteredProducts,
        searchQuery,
        activeFilters,
      ];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}