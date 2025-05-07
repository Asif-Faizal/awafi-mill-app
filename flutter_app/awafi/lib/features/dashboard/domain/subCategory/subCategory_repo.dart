import 'subCategory_entity.dart';

abstract class SubCategoryRepository {
  Future<List<SubCategory>> getSubCategoriesByMainCategory(String mainCategoryId, int page, int limit);
}