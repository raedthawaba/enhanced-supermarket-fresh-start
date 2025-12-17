import 'package:supermarket_app/models/product.dart';
import 'package:supermarket_app/utils/constants.dart';

class ProductRepository {
  Future<List<Product>> getAllProducts() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _mockProducts;
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _mockProducts.where((product) => product.category == category).toList();
  }

  Future<List<Product>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _mockProducts.where((product) => product.isFeatured).toList();
  }

  Future<List<Product>> getRecommendedProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return first 6 products as recommendations
    return _mockProducts.take(6).toList();
  }

  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _mockProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _mockProducts.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
             product.description.toLowerCase().contains(query.toLowerCase()) ||
             product.category.toLowerCase().contains(query.toLowerCase()) ||
             product.brand?.toLowerCase().contains(query.toLowerCase()) == true;
    }).toList();
  }

  // Mock data for demonstration
  static final List<Product> _mockProducts = [
    Product(
      id: '1',
      name: 'تفاح أحمر طازج',
      description: 'تفاح أحمر طبيعي من المزارع المحلية، غني بالفيتامينات والمعادن',
      category: 'خضروات وفواكه',
      price: 8.50,
      oldPrice: 10.00,
      imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
      unit: 'كيلو',
      stockQuantity: 50,
      minStockLevel: 10,
      isAvailable: true,
      isOrganic: true,
      isDiscounted: true,
      discountPercentage: 15,
      brand: 'مزارع نجد',
      weight: 1,
      weightUnit: 'كيلو',
      tags: ['عضوي', 'طازج', 'محلي'],
      rating: 4.5,
      reviewCount: 24,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isFeatured: true,
    ),
    Product(
      id: '2',
      name: 'برتقال مصري',
      description: 'برتقال مصري طازج وعصيري، مصدر ممتاز لفيتامين C',
      category: 'خضروات وفواكه',
      price: 6.00,
      imageUrl: 'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
      unit: 'كيلو',
      stockQuantity: 75,
      minStockLevel: 15,
      isAvailable: true,
      isOrganic: false,
      brand: 'وادي النيل',
      weight: 1,
      weightUnit: 'كيلو',
      tags: ['طازج', 'فيتامين سي'],
      rating: 4.2,
      reviewCount: 18,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Product(
      id: '3',
      name: 'دجاج مجمد كامل',
      description: 'دجاج مجمد طبيعي، من مزارع محلية، طازج ومغذي',
      category: 'لحوم ودواجن',
      price: 25.00,
      imageUrl: 'https://images.unsplash.com/photo-1604908176997-43162c0d04bc?w=400',
      unit: 'كيلو',
      stockQuantity: 30,
      minStockLevel: 5,
      isAvailable: true,
      brand: 'دواجن الخليج',
      weight: 1,
      weightUnit: 'كيلو',
      tags: ['مجمد', 'طبيعي'],
      rating: 4.7,
      reviewCount: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isFeatured: true,
    ),
    Product(
      id: '4',
      name: 'حليب طازج كامل الدسم',
      description: 'حليب طازج كامل الدسم، من أبقار محلية، غني بالكالسيوم',
      category: 'ألبان وأجبان',
      price: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
      unit: 'لتر',
      stockQuantity: 40,
      minStockLevel: 10,
      isAvailable: true,
      brand: 'البان نجد',
      weight: 1,
      weightUnit: 'لتر',
      tags: ['طازج', 'كامل الدسم'],
      rating: 4.3,
      reviewCount: 32,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Product(
      id: '5',
      name: 'خبز أبيض طازج',
      description: 'خبز أبيض طازج يومياً، من دقيق عالي الجودة',
      category: 'خبز ومخبوزات',
      price: 3.00,
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
      unit: 'رغيف',
      stockQuantity: 100,
      minStockLevel: 20,
      isAvailable: true,
      brand: 'مخبزة الأحلام',
      weight: 500,
      weightUnit: 'جرام',
      tags: ['طازج', 'يومي'],
      rating: 4.1,
      reviewCount: 28,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    Product(
      id: '6',
      name: 'ماء معدني طبيعي',
      description: 'ماء معدني طبيعي من المنابع الجبلية، غني بالمعادن المفيدة',
      category: 'مشروبات',
      price: 2.50,
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
      unit: 'زجاجة',
      stockQuantity: 200,
      minStockLevel: 50,
      isAvailable: true,
      brand: 'ينابيع الجبل',
      weight: 600,
      weightUnit: 'مل',
      tags: ['طبيعي', 'معدني'],
      rating: 4.0,
      reviewCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Product(
      id: '7',
      name: 'طماطم عضوية',
      description: 'طماطم عضوية طازجة، من مزارع عضوية معتمدة',
      category: 'خضروات وفواكه',
      price: 9.00,
      oldPrice: 11.00,
      imageUrl: 'https://images.unsplash.com/photo-1546470427-85a2b9c6ed40?w=400',
      unit: 'كيلو',
      stockQuantity: 25,
      minStockLevel: 8,
      isAvailable: true,
      isOrganic: true,
      isDiscounted: true,
      discountPercentage: 18,
      brand: 'مزارع العضوية',
      weight: 1,
      weightUnit: 'كيلو',
      tags: ['عضوي', 'طازج'],
      rating: 4.6,
      reviewCount: 22,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isFeatured: true,
    ),
    Product(
      id: '8',
      name: 'سمك سلمون طازج',
      description: 'سمك سلمون طازج مستورد، غني بأوميجا 3',
      category: 'أسماك',
      price: 85.00,
      imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400',
      unit: 'كيلو',
      stockQuantity: 15,
      minStockLevel: 3,
      isAvailable: true,
      brand: 'محيط الأطلسي',
      weight: 1,
      weightUnit: 'كيلو',
      tags: ['طازج', 'مستورد', 'أوميجا 3'],
      rating: 4.8,
      reviewCount: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      expiryDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Product(
      id: '9',
      name: 'جبن أبيض طري',
      description: 'جبن أبيض طري من الحليب الطبيعي، طعم لذيذ ومغذي',
      category: 'ألبان وأجبان',
      price: 18.00,
      imageUrl: 'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400',
      unit: 'كيلو',
      stockQuantity: 20,
      minStockLevel: 5,
      isAvailable: true,
      brand: 'أجبان الخليج',
      weight: 500,
      weightUnit: 'جرام',
      tags: ['طبيعي', 'طري'],
      rating: 4.4,
      reviewCount: 35,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Product(
      id: '10',
      name: 'عسل طبيعي نقي',
      description: 'عسل طبيعي نقي من أزهار البرتقال، غني بالفيتامينات',
      category: 'أخرى',
      price: 45.00,
      oldPrice: 50.00,
      imageUrl: 'https://images.unsplash.com/photo-1587049352846-4a222e784210?w=400',
      unit: 'كيلو',
      stockQuantity: 12,
      minStockLevel: 3,
      isAvailable: true,
      isOrganic: true,
      isDiscounted: true,
      discountPercentage: 10,
      brand: 'مناحل الصحراء',
      weight: 1,
      weightUnit: 'كيلو',
      tags: ['عضوي', 'طبيعي', 'نقي'],
      rating: 4.9,
      reviewCount: 67,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      isFeatured: true,
    ),
  ];
}