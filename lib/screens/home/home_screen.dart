import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_app/blocs/auth/auth_bloc.dart';
import 'package:supermarket_app/blocs/cart/cart_bloc.dart';
import 'package:supermarket_app/blocs/favorite/favorite_bloc.dart';
import 'package:supermarket_app/blocs/notification/notification_bloc.dart';
import 'package:supermarket_app/blocs/product/product_bloc.dart';
import 'package:supermarket_app/screens/cart/cart_screen.dart';
import 'package:supermarket_app/screens/categories/categories_screen.dart';
import 'package:supermarket_app/screens/favorites/favorites_screen.dart';
import 'package:supermarket_app/screens/home/widgets/banner_widget.dart';
import 'package:supermarket_app/screens/home/widgets/category_card.dart';
import 'package:supermarket_app/screens/home/widgets/featured_products_widget.dart';
import 'package:supermarket_app/screens/home/widgets/search_widget.dart';
import 'package:supermarket_app/screens/notifications/notifications_screen.dart';
import 'package:supermarket_app/screens/orders/orders_screen.dart';
import 'package:supermarket_app/screens/profile/profile_screen.dart';
import 'package:supermarket_app/screens/search/search_results_screen.dart';
import 'package:supermarket_app/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<ProductBloc>().add(LoadProducts());
    context.read<CartBloc>().add(LoadCart());
    context.read<FavoriteBloc>().add(LoadFavorites());
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    
    if (query.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SearchResultsScreen(query: query),
        ),
      );
    }
  }

  void _onCategorySelected(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoriesScreen(selectedCategory: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomeTab(),
          const CategoriesScreen(),
          const FavoritesScreen(),
          const OrdersScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _currentIndex == 0 ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildHomeTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.cart.totalQuantity;
              }
              
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductBloc>().add(LoadProducts());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              SearchWidget(onSearch: _onSearch),
              
              const SizedBox(height: 24),
              
              // Banner
              const BannerWidget(),
              
              const SizedBox(height: 24),
              
              // Categories
              Text(
                'الفئات',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.categories.length,
                  itemBuilder: (context, index) {
                    final category = AppConstants.categories[index];
                    return CategoryCard(
                      category: category,
                      onTap: () => _onCategorySelected(category),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Featured Products
              Text(
                'المنتجات المميزة',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const FeaturedProductsWidget(),
              
              const SizedBox(height: 24),
              
              // Special Offers Banner
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'عرض خاص',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'خصم 20% على جميع المنتجات العضوية',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'اشتري الآن',
                          style: TextStyle(
                            color: const Color(0xFFFF6B6B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Recently Viewed (placeholder)
              Text(
                'المشاهدة مؤخراً',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'لا توجد منتجات مشاهدة مؤخراً',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 80), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            activeIcon: Icon(Icons.category),
            label: 'الفئات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            activeIcon: Icon(Icons.receipt_long),
            label: 'الطلبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CartScreen()),
        );
      },
      backgroundColor: const Color(0xFF4CAF50),
      child: const Icon(Icons.shopping_cart, color: Colors.white),
    );
  }
}