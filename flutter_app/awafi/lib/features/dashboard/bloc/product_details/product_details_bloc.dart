import 'package:bloc/bloc.dart';

import '../../domain/product_details/get_product_details.dart';
import '../../domain/product_details/product_details_entity.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductIndividualBloc extends Bloc<ProductIndividualEvent, ProductIndividualState> {
  final GetProductIndividualDetails getProductDetails;

  ProductIndividualBloc({required this.getProductDetails}) : super(ProductIndividualInitial()) {
    on<GetProductIndividualEvent>((event, emit) async {
      emit(ProductIndividualLoading());
      try {
        final productDetails = await getProductDetails(event.productId);
        emit(ProductIndividualLoaded(productDetails));
      } catch (e) {
        emit(ProductIndividualError('Failed to load product details'));
      }
    });
  }
}