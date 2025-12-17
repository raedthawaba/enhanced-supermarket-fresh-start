import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_app/models/product.dart';
import 'package:supermarket_app/repositories/favorite_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteBloc({required FavoriteRepository favoriteRepository})
      : _favoriteRepository = favoriteRepository,
        super(FavoriteLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      emit(FavoriteLoading());
      
      final favorites = await _favoriteRepository.getFavorites();
      
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      if (state is! FavoritesLoaded) return;
      
      final currentState = state as FavoritesLoaded;
      await _favoriteRepository.addToFavorites(event.product);
      
      final updatedFavorites = [...currentState.favorites, event.product];
      
      emit(FavoritesLoaded(favorites: updatedFavorites));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      if (state is! FavoritesLoaded) return;
      
      final currentState = state as FavoritesLoaded;
      await _favoriteRepository.removeFromFavorites(event.productId);
      
      final updatedFavorites = currentState.favorites
          .where((product) => product.id != event.productId)
          .toList();
      
      emit(FavoritesLoaded(favorites: updatedFavorites));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      if (state is! FavoritesLoaded) return;
      
      final currentState = state as FavoritesLoaded;
      final isFavorite = currentState.favorites
          .any((product) => product.id == event.productId);
      
      if (isFavorite) {
        await _favoriteRepository.removeFromFavorites(event.productId);
        
        final updatedFavorites = currentState.favorites
            .where((product) => product.id != event.productId)
            .toList();
        
        emit(FavoritesLoaded(favorites: updatedFavorites));
      } else {
        await _favoriteRepository.addToFavorites(event.product);
        
        final updatedFavorites = [...currentState.favorites, event.product];
        
        emit(FavoritesLoaded(favorites: updatedFavorites));
      }
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }
}