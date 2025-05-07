part of 'add_address_bloc.dart';

abstract class AddAddressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddAddressRequestEvent extends AddAddressEvent {
  final AddAddressEntity address;

  AddAddressRequestEvent({required this.address});

  @override
  List<Object?> get props => [address];
}