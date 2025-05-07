import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../domain/product/get_product.dart';
import '../../domain/product/product_entity.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc(this.getProductsUseCase) : super(ProductInitial()) {
    on<FetchProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await getProductsUseCase();
        emit(ProductLoaded(products));
      } catch (e) {
        debugPrint('Error loading products: $e');
        emit(ProductError('Failed to load products: ${e.toString()}'));
      }
    });
  }
}
