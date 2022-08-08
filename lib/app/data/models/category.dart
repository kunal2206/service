import 'sub_category.dart';

class Category {
  final String id;
  final String categoryName;
  final double? categoryMaxDiscount;
  final String categoryImageUrl;
  final String categoryCarouselImageUrl;
  final String section;
  final bool containsType;

  List<SubCategory>? children;

  Category({
    required this.id,
    required this.categoryName,
    this.categoryMaxDiscount,
    required this.categoryImageUrl,
    required this.categoryCarouselImageUrl,
    required this.section,
    this.children,
    this.containsType = false,
  });
}
