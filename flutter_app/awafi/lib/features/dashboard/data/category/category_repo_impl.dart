
import '../../domain/category/category_entity.dart';
import '../../domain/category/category_repo.dart';
import 'category_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categories = await remoteDataSource.fetchCategories();
    return categories.map((category) => CategoryEntity(
      id: category.id,
      name: category.name,
      photo: category.photo,
      description: category.description,
    )).toList();
  }
}
