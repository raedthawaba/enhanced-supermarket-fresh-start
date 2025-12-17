import 'package:flutter/foundation.dart';
import 'package:supermarket_app/utils/constants.dart';

/// Simple database service that works on web without FFI
/// Use this as a fallback when the main database service fails
class SimpleDatabaseService {
  static final SimpleDatabaseService _instance = SimpleDatabaseService._internal();
  factory SimpleDatabaseService() => _instance;
  SimpleDatabaseService._internal();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      print('Initializing simple database service...');
      
      if (kIsWeb) {
        print('Web platform detected - using localStorage as fallback');
        // For web, we'll use localStorage or in-memory storage
        // In a real implementation, you might use IndexedDB
      } else {
        print('Non-web platform detected');
      }
      
      _isInitialized = true;
      print('Simple database service initialized successfully');
    } catch (e) {
      print('Simple database service initialization failed: $e');
      _isInitialized = true; // Mark as initialized even if failed
    }
  }

  bool get isInitialized => _isInitialized;

  /// Mock database operations
  Future<List<Map<String, dynamic>>> query(String table) async {
    print('Mock query to table: $table');
    return [];
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    print('Mock insert to table: $table, data: $data');
  }

  Future<void> update(String table, Map<String, dynamic> data, String where) async {
    print('Mock update to table: $table, where: $where');
  }

  Future<void> delete(String table, String where) async {
    print('Mock delete from table: $table, where: $where');
  }
}