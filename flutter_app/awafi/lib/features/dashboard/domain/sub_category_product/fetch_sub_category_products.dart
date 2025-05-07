import 'package:awafi/features/dashboard/data/sub_category_product/sub_category_product_model.dart';

import 'sub_category_product_repo.dart';

class FetchProductsUseCase {
  final SubCategoryProductRepo repository;

  FetchProductsUseCase({required this.repository});

  Future<List<SubCategoryProductModel>> execute(String subCategoryId) async {
    return await repository.fetchProducts(subCategoryId);
  }
}