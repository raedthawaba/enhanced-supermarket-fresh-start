import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermarket_app/models/product.dart';
import 'package:supermarket_app/utils/constants.dart';

class FavoriteRepository {
  static const String _favoritesKey = AppConstants.favoritesKey;

  Future<List<Product>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson == null) {
      return [];
    }
    
    try {
      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return favoritesList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addToFavorites(Product product) async {
    final favorites = await getFavorites();
    
    // Check if already in favorites
    if (favorites.any((p) => p.id == product.id)) {
      return; // Already exists
    }
    
    favorites.add(product);
    await _saveFavorites(favorites);
  }

  Future<void> removeFromFavorites(String productId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((product) => product.id == productId);
    await _saveFavorites(favorites);
  }

  Future<bool> isFavorite(String productId) async {
    final favorites = await getFavorites();
    return favorites.any((product) => product.id == productId);
  }

  Future<void> clearFavorites() async {
    await _saveFavorites([]);
  }

  Future<int> getFavoritesCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }

  Future<void> _saveFavorites(List<Product> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = json.encode(favorites.map((product) => product.toJson()).toList());
    await prefs.setString(_favoritesKey, favoritesJson);
  }

  // Helper methods
  Future<List<Product>> getFavoritesByCategory(String category) async {
    final favorites = await getFavorites();
    return favorites.where((product) => product.category == category).toList();
  }

  Future<List<Product>> searchFavorites(String query) async {
    final favorites = await getFavorites();
    return favorites.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
             product.description.toLowerCase().contains(query.toLowerCase()) ||
             product.brand?.toLowerCase().contains(query.toLowerCase()) == true;
    }).toList();
  }
}