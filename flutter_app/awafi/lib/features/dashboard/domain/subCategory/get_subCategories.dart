import 'subCategory_entity.dart';
import 'subCategory_repo.dart';

class GetSubCategories {
  final SubCategoryRepository repository;

  GetSubCategories(this.repository);

  Future<List<SubCategory>> call(String mainCategoryId, int page, int limit) {
    return repository.getSubCategoriesByMainCategory(mainCategoryId, page, limit);
  }
}