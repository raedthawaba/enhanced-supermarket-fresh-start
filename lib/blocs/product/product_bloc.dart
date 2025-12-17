import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_app/models/product.dart';
import 'package:supermarket_app/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProduct>(_onLoadProduct);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProducts>(_onFilterProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<LoadFeaturedProducts>(_onLoadFeaturedProducts);
    on<LoadRecommendedProducts>(_onLoadRecommendedProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      
      final products = await _productRepository.getAllProducts();
      
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadProduct(
    LoadProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;
        final product = currentState.products.firstWhere(
          (p) => p.id == event.productId,
          orElse: () => throw Exception('Product not found'),
        );
        
        emit(ProductLoaded(product: product));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;
        final filteredProducts = currentState.products.where((product) {
          return product.name.toLowerCase().contains(event.query.toLowerCase()) ||
                 product.description.toLowerCase().contains(event.query.toLowerCase()) ||
                 product.category.toLowerCase().contains(event.query.toLowerCase());
        }).toList();
        
        emit(ProductsLoaded(
          products: currentState.products,
          filteredProducts: filteredProducts,
          searchQuery: event.query,
        ));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onFilterProducts(
    FilterProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;
        final baseProducts = (currentState.filteredProducts?.isNotEmpty ?? false)
            ? currentState.filteredProducts! 
            : currentState.products;
        
        List<Product> filteredProducts = baseProducts;
        
        // Filter by category
        if (event.category != null && event.category!.isNotEmpty) {
          filteredProducts = filteredProducts.where((product) {
            return product.category == event.category;
          }).toList();
        }
        
        // Filter by price range
        if (event.minPrice != null || event.maxPrice != null) {
          filteredProducts = filteredProducts.where((product) {
            final price = product.discountPrice;
            final minPrice = event.minPrice ?? 0;
            final maxPrice = event.maxPrice ?? double.infinity;
            return price >= minPrice && price <= maxPrice;
          }).toList();
        }
        
        // Filter by rating
        if (event.minRating != null) {
          filteredProducts = filteredProducts.where((product) {
            return product.rating >= event.minRating!;
          }).toList();
        }
        
        // Filter by availability
        if (event.inStockOnly != null && event.inStockOnly!) {
          filteredProducts = filteredProducts.where((product) {
            return product.isAvailable && product.stockQuantity > 0;
          }).toList();
        }
        
        // Filter by organic
        if (event.organicOnly != null && event.organicOnly!) {
          filteredProducts = filteredProducts.where((product) {
            return product.isOrganic;
          }).toList();
        }
        
        // Filter by discount
        if (event.discountedOnly != null && event.discountedOnly!) {
          filteredProducts = filteredProducts.where((product) {
            return product.isDiscounted;
          }).toList();
        }
        
        emit(ProductsLoaded(
          products: currentState.products,
          filteredProducts: filteredProducts,
          searchQuery: currentState.searchQuery,
          activeFilters: {
            'category': event.category,
            'minPrice': event.minPrice,
            'maxPrice': event.maxPrice,
            'minRating': event.minRating,
            'inStockOnly': event.inStockOnly,
            'organicOnly': event.organicOnly,
            'discountedOnly': event.discountedOnly,
          },
        ));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      
      final products = await _productRepository.getProductsByCategory(event.category);
      
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadFeaturedProducts(
    LoadFeaturedProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      
      final products = await _productRepository.getFeaturedProducts();
      
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadRecommendedProducts(
    LoadRecommendedProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      
      final products = await _productRepository.getRecommendedProducts();
      
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}