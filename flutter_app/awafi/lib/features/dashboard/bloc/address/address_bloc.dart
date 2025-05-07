import 'package:awafi/features/dashboard/data/address/address_datasource.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/address/address_entity.dart';
import '../../domain/address/get_address.dart';

part 'address_event.dart';
part 'address_state.dart';

class GetAddressBloc extends Bloc<GetAddressEvent, GetAddressState> {
  final GetAddressUseCase getAddressUseCase;

  GetAddressBloc(this.getAddressUseCase) : super(AddressInitial()) {
    on<FetchAddress>(_onFetchAddress);
  }

  Future<void> _onFetchAddress(FetchAddress event, Emitter<GetAddressState> emit) async {
    emit(AddressLoading());
    try {
      final address = await getAddressUseCase();
      emit(AddressLoaded(address));
    } on UnauthenticatedAddressException{
      emit(AddressUnauthorized());
    } catch (e) {
      if (e.toString().contains("AddressNotFound")) {
        emit(AddressNotFound());
      } else {
        emit(AddressError(e.toString()));
      }
    }
  }
}