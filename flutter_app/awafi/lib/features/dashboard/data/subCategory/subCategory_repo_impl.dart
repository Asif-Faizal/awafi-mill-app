import '../../domain/subCategory/subCategory_entity.dart';
import '../../domain/subCategory/subCategory_repo.dart';
import 'subCategory_datasource.dart';

class SubCategoryRepositoryImpl implements SubCategoryRepository {
  final SubCategoryRemoteDataSource remoteDataSource;

  SubCategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SubCategory>> getSubCategoriesByMainCategory(String mainCategoryId, int page, int limit) async {
    final subCategoryModels = await remoteDataSource.getSubCategories(mainCategoryId, page, limit);
    return subCategoryModels.map((model) => SubCategory(
      id: model.id,
      name: model.name,
      description: model.description,
    )).toList();
  }
}
