import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermarket_app/models/user.dart';
import 'package:supermarket_app/utils/constants.dart';

class AuthRepository {
  static const String _tokenKey = AppConstants.tokenKey;
  static const String _userKey = AppConstants.userKey;

  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking authentication: $e');
      return false;
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson == null) {
        throw Exception('No user data found');
      }
      
      final userMap = json.decode(userJson);
      return User.fromJson(userMap);
    } catch (e) {
      print('Error getting current user: $e');
      throw Exception('فشل في جلب بيانات المستخدم');
    }
  }

  Future<User> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock authentication - In real app, this would call an API
    if (email == 'admin@example.com' && password == '123456') {
      final user = User(
        id: '1',
        email: email,
        name: 'مدير النظام',
        phone: '+966501234567',
        address: 'الرياض، حي الملقا',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );
      
      await _saveUserData(user, rememberMe);
      return user;
    } else if (email == 'user@example.com' && password == '123456') {
      final user = User(
        id: '2',
        email: email,
        name: 'أحمد محمد',
        phone: '+966501234567',
        address: 'الرياض، حي الملقا',
        role: UserRole.customer,
        createdAt: DateTime.now(),
      );
      
      await _saveUserData(user, rememberMe);
      return user;
    } else {
      throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
    }
  }

  Future<User> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock registration - In real app, this would call an API
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      phone: phone,
      address: address,
      role: UserRole.customer,
      createdAt: DateTime.now(),
    );
    
    // For demo purposes, we'll save the user but not auto-login
    // In real app, you might want to auto-login after registration
    await _saveUserData(user, false);
    
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<void> forgotPassword({required String email}) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // In real app, this would send a password reset email
    throw Exception('Feature not implemented yet');
  }

  Future<User> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? address,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    final currentUser = await getCurrentUser();
    
    final updatedUser = currentUser.copyWith(
      name: name,
      phone: phone,
      address: address,
    );
    
    await _saveUserData(updatedUser, true);
    return updatedUser;
  }

  Future<void> _saveUserData(User user, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Generate a simple token (in real app, this would come from server)
    final token = _generateToken(user);
    
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(user.toJson()));
    
    if (!rememberMe) {
      // Set token to expire in 24 hours if not remember me
      // In real app, you'd handle session expiration
    }
  }

  String _generateToken(User user) {
    final data = '${user.id}_${user.email}_${DateTime.now().millisecondsSinceEpoch}';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Helper method to check if user is admin
  Future<bool> isAdmin() async {
    try {
      final user = await getCurrentUser();
      return user.role == UserRole.admin;
    } catch (e) {
      return false;
    }
  }

  // Helper method to check if user is customer
  Future<bool> isCustomer() async {
    try {
      final user = await getCurrentUser();
      return user.role == UserRole.customer;
    } catch (e) {
      return false;
    }
  }
}