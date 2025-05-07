import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/subCategory/get_subCategories.dart';
import '../../domain/subCategory/subCategory_entity.dart';

part 'sub_category_event.dart';
part 'sub_category_state.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  final GetSubCategories getSubCategories;

  SubCategoryBloc(this.getSubCategories) : super(SubCategoryInitial()) {
    on<FetchSubCategories>(_onFetchSubCategories);
  }

  Future<void> _onFetchSubCategories(FetchSubCategories event, Emitter<SubCategoryState> emit) async {
    emit(SubCategoryLoading());
    try {
      final subCategories = await getSubCategories(event.mainCategoryId, event.page, event.limit);
      emit(SubCategoryLoaded(subCategories));
    } catch (e) {
      emit(SubCategoryError(e.toString()));
    }
  }
}