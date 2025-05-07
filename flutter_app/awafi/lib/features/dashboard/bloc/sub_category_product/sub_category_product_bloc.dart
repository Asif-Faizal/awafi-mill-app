import 'package:awafi/features/dashboard/data/sub_category_product/sub_category_product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/sub_category_product/fetch_sub_category_products.dart';

part 'sub_category_product_event.dart';
part 'sub_category_product_state.dart';

class SubCategoryProductBloc extends Bloc<SubCategoryProductEvent, SubCategoryProductState> {
  final FetchProductsUseCase fetchProductsUseCase;

  SubCategoryProductBloc({required this.fetchProductsUseCase}) : super(ProductLoading()) {
    // Handling the FetchProductsEvent using the on<Event> method
    on<FetchSubCategoryProductEvent>(_onFetchProductsEvent);
  }

  // Event handler for FetchProductsEvent
  Future<void> _onFetchProductsEvent(FetchSubCategoryProductEvent event, Emitter<SubCategoryProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await fetchProductsUseCase.execute(event.subCategoryId);
      emit(ProductLoaded(products: products));
    } catch (e) {
      if (e.toString() == 'Unauthorized') {
        emit(ProductUnauthorized());
      } else {
        emit(ProductError(message: e.toString()));
      }
    }
  }
}
