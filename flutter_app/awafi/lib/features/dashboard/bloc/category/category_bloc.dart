import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/category/category_entity.dart';
import '../../domain/category/fetch_category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FetchCategoriesUseCase fetchCategoriesUseCase;

  CategoryBloc({required this.fetchCategoriesUseCase}) : super(CategoryInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
  }

  void _onFetchCategories(FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await fetchCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories'));
    }
  }
}