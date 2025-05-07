part of 'add_cart_bloc.dart';

abstract class AddCartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends AddCartState {}

class AddCartLoading extends AddCartState {}

class CartSuccess extends AddCartState {}

class CartFailure extends AddCartState {
  final String error;

  CartFailure({required this.error});

  @override
  List<Object?> get props => [error];
}