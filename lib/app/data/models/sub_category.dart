import 'service.dart';

class SubCategory {
  final String id;
  final String subCategoryName;
  final double? categoryMaxDiscount;

  List<Service>? children;

  SubCategory({
    required this.id,
    required this.subCategoryName,
    this.categoryMaxDiscount,
    this.children,
  });
}
