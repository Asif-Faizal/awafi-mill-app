part of 'collection_products_bloc.dart';

abstract class CollectionProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCollectionProductsEvent extends CollectionProductEvent {
  final String subCategoryId;

  FetchCollectionProductsEvent(this.subCategoryId);

  @override
  List<Object?> get props => [subCategoryId];
}