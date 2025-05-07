part of 'collection_products_bloc.dart';

abstract class CollectionProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CollectionProductInitial extends CollectionProductState {}

class CollectionProductLoading extends CollectionProductState {}

class CollectionProductLoaded extends CollectionProductState {
  final List<CollectionProductEntity> products;

  CollectionProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class CollectionProductError extends CollectionProductState {
  final String message;

  CollectionProductError(this.message);

  @override
  List<Object?> get props => [message];
}