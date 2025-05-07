import 'package:awafi/features/dashboard/data/sub_category_product/sub_category_product_model.dart';

abstract class SubCategoryProductRepo {
  Future<List<SubCategoryProductModel>> fetchProducts(String subCategoryId);
}