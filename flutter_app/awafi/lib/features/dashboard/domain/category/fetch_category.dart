import 'category_entity.dart';
import 'category_repo.dart';

class FetchCategoriesUseCase {
  final CategoryRepository repository;

  FetchCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}