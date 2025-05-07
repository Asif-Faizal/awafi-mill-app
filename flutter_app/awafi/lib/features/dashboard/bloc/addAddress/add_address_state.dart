part of 'add_address_bloc.dart';

abstract class AddAddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddAddressInitialState extends AddAddressState {}

class AddAddressLoadingState extends AddAddressState {}

class AddAddressSuccessState extends AddAddressState {
  final String message;

  AddAddressSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddAddressErrorState extends AddAddressState {
  final String errorMessage;

  AddAddressErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AddAddressUnauthorizedState extends AddAddressState {}
