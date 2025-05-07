part of 'sub_category_bloc.dart';

abstract class SubCategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSubCategories extends SubCategoryEvent {
  final String mainCategoryId;
  final int page;
  final int limit;

  FetchSubCategories({required this.mainCategoryId, this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [mainCategoryId, page, limit];
}