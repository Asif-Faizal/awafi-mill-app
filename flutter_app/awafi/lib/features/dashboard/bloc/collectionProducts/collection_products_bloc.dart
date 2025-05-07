import 'package:awafi/features/dashboard/domain/collectionProducts/collection_product_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/collectionProducts/get_collection_products.dart';

part 'collection_products_event.dart';
part 'collection_products_state.dart';

class CollectionProductBloc
    extends Bloc<CollectionProductEvent, CollectionProductState> {
  final GetCollectionProductsUseCase getCollectionProductsUseCase;

  CollectionProductBloc(this.getCollectionProductsUseCase)
      : super(CollectionProductInitial()) {
    on<FetchCollectionProductsEvent>((event, emit) async {
      emit(CollectionProductLoading());
      try {
        final products = await getCollectionProductsUseCase(event.subCategoryId);
        emit(CollectionProductLoaded(products));
      } catch (e) {
        emit(CollectionProductError(e.toString()));
      }
    });
  }
}