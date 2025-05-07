part of 'sub_category_product_bloc.dart';

sealed class SubCategoryProductEvent extends Equatable {
  const SubCategoryProductEvent();

  @override
  List<Object> get props => [];
}
class FetchSubCategoryProductEvent extends SubCategoryProductEvent {
  final String subCategoryId;

  const FetchSubCategoryProductEvent({required this.subCategoryId});

  @override
  List<Object> get props => [subCategoryId];
}