part of 'product_details_bloc.dart';

abstract class ProductIndividualState {}

class ProductIndividualInitial extends ProductIndividualState {}

class ProductIndividualLoading extends ProductIndividualState {}

class ProductIndividualLoaded extends ProductIndividualState {
  final ProductIndividualEntity productDetails;

  ProductIndividualLoaded(this.productDetails);
}

class ProductIndividualError extends ProductIndividualState {
  final String message;

  ProductIndividualError(this.message);
}