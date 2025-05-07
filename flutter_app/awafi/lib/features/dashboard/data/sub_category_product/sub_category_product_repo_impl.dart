import 'package:awafi/features/dashboard/data/sub_category_product/sub_category_product_datasource.dart';
import 'package:awafi/features/dashboard/data/sub_category_product/sub_category_product_model.dart';

import '../../domain/sub_category_product/sub_category_product_repo.dart';

class SubCategoryProductRepoImpl implements SubCategoryProductRepo {
  final SubCategoryProductDatasource datasource;

  SubCategoryProductRepoImpl({required this.datasource});

  @override
  Future<List<SubCategoryProductModel>> fetchProducts(String subCategoryId) async {
    return await datasource.getProductsBySubCategory(subCategoryId);
  }
}