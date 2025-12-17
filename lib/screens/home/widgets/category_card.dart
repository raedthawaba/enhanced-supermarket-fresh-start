import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColors = _getCategoryColor(category);
    final categoryIcon = _getCategoryIcon(category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColors['primary']!,
              categoryColors['secondary']!,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: categoryColors['primary']!.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              categoryIcon,
              size: 32,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Color> _getCategoryColor(String category) {
    switch (category) {
      case 'خضروات وفواكه':
        return {
          'primary': const Color(0xFF4CAF50),
          'secondary': const Color(0xFF81C784),
        };
      case 'لحوم ودواجن':
        return {
          'primary': const Color(0xFFF44336),
          'secondary': const Color(0xFFFF8A65),
        };
      case 'أسماك':
        return {
          'primary': const Color(0xFF2196F3),
          'secondary': const Color(0xFF64B5F6),
        };
      case 'ألبان وأجبان':
        return {
          'primary': const Color(0xFFFFEB3B),
          'secondary': const Color(0xFFFFE082),
        };
      case 'خبز ومخبوزات':
        return {
          'primary': const Color(0xFFFF9800),
          'secondary': const Color(0xFFFFB74D),
        };
      case 'مشروبات':
        return {
          'primary': const Color(0xFF9C27B0),
          'secondary': const Color(0xFFBA68C8),
        };
      case 'مكسرات':
        return {
          'primary': const Color(0xFF795548),
          'secondary': const Color(0xFFA1887F),
        };
      case 'تنظيف':
        return {
          'primary': const Color(0xFF607D8B),
          'secondary': const Color(0xFF90A4AE),
        };
      case 'عناية شخصية':
        return {
          'primary': const Color(0xFFE91E63),
          'secondary': const Color(0xFFF06292),
        };
      case 'أدوية':
        return {
          'primary': const Color(0xFF3F51B5),
          'secondary': const Color(0xFF7986CB),
        };
      case 'أدوات منزلية':
        return {
          'primary': const Color(0xFF9E9E9E),
          'secondary': const Color(0xFFBDBDBD),
        };
      default:
        return {
          'primary': const Color(0xFF4CAF50),
          'secondary': const Color(0xFF81C784),
        };
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'خضروات وفواكه':
        return Icons.eco;
      case 'لحوم ودواجن':
        return Icons.restaurant;
      case 'أسماك':
        return Icons.set_meal;
      case 'ألبان وأجبان':
        return Icons.local_drink;
      case 'خبز ومخبوزات':
        return Icons.bakery_dining;
      case 'مشروبات':
        return Icons.local_drink;
      case 'مكسرات':
        return Icons.nutrition;
      case 'تنظيف':
        return Icons.cleaning_services;
      case 'عناية شخصية':
        return Icons.face;
      case 'أدوية':
        return Icons.medication;
      case 'أدوات منزلية':
        return Icons.home;
      default:
        return Icons.category;
    }
  }
}