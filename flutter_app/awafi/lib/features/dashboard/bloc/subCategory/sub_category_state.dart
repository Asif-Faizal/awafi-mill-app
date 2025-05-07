part of 'sub_category_bloc.dart';

abstract class SubCategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class SubCategoryInitial extends SubCategoryState {}

class SubCategoryLoading extends SubCategoryState {}

class SubCategoryLoaded extends SubCategoryState {
  final List<SubCategory> subCategories;

  SubCategoryLoaded(this.subCategories);

  @override
  List<Object> get props => [subCategories];
}

class SubCategoryError extends SubCategoryState {
  final String message;

  SubCategoryError(this.message);

  @override
  List<Object> get props => [message];
}