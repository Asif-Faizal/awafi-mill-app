part of 'address_bloc.dart';

abstract class GetAddressEvent extends Equatable {
  const GetAddressEvent();

  @override
  List<Object?> get props => [];
}

class FetchAddress extends GetAddressEvent {}