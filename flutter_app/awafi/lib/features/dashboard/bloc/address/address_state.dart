part of 'address_bloc.dart';

abstract class GetAddressState extends Equatable {
  const GetAddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends GetAddressState {}

class AddressLoading extends GetAddressState {}

class AddressLoaded extends GetAddressState {
  final Address address;

  const AddressLoaded(this.address);

  @override
  List<Object?> get props => [address];
}

class AddressError extends GetAddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressNotFound extends GetAddressState {}

class AddressUnauthorized extends GetAddressState {}