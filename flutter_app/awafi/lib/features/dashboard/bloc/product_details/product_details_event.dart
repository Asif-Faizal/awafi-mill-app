part of 'product_details_bloc.dart';

abstract class ProductIndividualEvent {}

class GetProductIndividualEvent extends ProductIndividualEvent {
  final String productId;

  GetProductIndividualEvent(this.productId);
}