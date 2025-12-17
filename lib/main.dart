import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supermarket_app/app.dart';
import 'package:supermarket_app/blocs/auth/auth_bloc.dart';
import 'package:supermarket_app/screens/splash/splash_screen.dart';
import 'package:supermarket_app/screens/auth/login_screen.dart';
import 'package:supermarket_app/screens/home/home_screen.dart';
import 'package:supermarket_app/test_app.dart';
import 'package:supermarket_app/blocs/cart/cart_bloc.dart';
import 'package:supermarket_app/blocs/product/product_bloc.dart';
import 'package:supermarket_app/blocs/order/order_bloc.dart';
import 'package:supermarket_app/blocs/favorite/favorite_bloc.dart';
import 'package:supermarket_app/blocs/notification/notification_bloc.dart';
import 'package:supermarket_app/blocs/profile/profile_bloc.dart';
import 'package:supermarket_app/repositories/auth_repository.dart';
import 'package:supermarket_app/repositories/product_repository.dart';
import 'package:supermarket_app/repositories/order_repository.dart';
import 'package:supermarket_app/repositories/favorite_repository.dart';
import 'package:supermarket_app/services/database_service.dart';
import 'package:supermarket_app/services/simple_database_service.dart';
import 'package:supermarket_app/services/notification_service.dart';
import 'package:supermarket_app/services/locale_service.dart';
import 'package:supermarket_app/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Hive
    await Hive.initFlutter();
  } catch (e) {
    print('Hive initialization error: $e');
  }
  
  try {
    // Initialize local database
    await DatabaseService().init();
  } catch (e) {
    print('Database initialization error: $e');
    // Try simple database service as fallback
    try {
      print('Trying simple database service as fallback...');
      await SimpleDatabaseService().init();
      print('Simple database service initialized successfully');
    } catch (fallbackError) {
      print('Simple database service also failed: $fallbackError');
      // Continue without database
    }
  }
  
  try {
    // Initialize notifications
    await NotificationService().init();
  } catch (e) {
    print('Notification initialization error: $e');
  }
  
  try {
    // Initialize locale service
    LocaleService().init();
  } catch (e) {
    print('Locale service initialization error: $e');
  }
  
  try {
    runApp(const SupermarketApp());
  } catch (e) {
    print('Failed to run main app: $e');
    // Fallback to simple test app
    runApp(const TestApp());
  }
}

class SupermarketApp extends StatelessWidget {
  const SupermarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(LoadAuthStatus()),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(
            productRepository: ProductRepository(),
          )..add(LoadProducts()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(
            orderRepository: OrderRepository(),
          ),
        ),
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(
            favoriteRepository: FavoriteRepository(),
          )..add(LoadFavorites()),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: const Color(0xFF4CAF50),
          fontFamily: 'Cairo',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        routes: {
          '/': (context) => const SplashScreen(),
          '/main': (context) => BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const SplashScreen();
              } else if (state is AuthAuthenticated) {
                return const HomeScreen();
              } else if (state is AuthUnauthenticated) {
                return const LoginScreen();
              }
              return const SplashScreen();
            },
          ),
        },
        initialRoute: '/',
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ],
      ),
    );
  }
}