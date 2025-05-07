part of 'sub_category_product_bloc.dart';

sealed class SubCategoryProductState extends Equatable {
  const SubCategoryProductState();
  
  @override
  List<Object> get props => [];
}


class ProductLoading extends SubCategoryProductState {}

class ProductLoaded extends SubCategoryProductState {
  final List<SubCategoryProductModel> products;

  const ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductError extends SubCategoryProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductUnauthorized extends SubCategoryProductState {}
