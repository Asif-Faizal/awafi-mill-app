import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/addAddress/add_address.dart';
import '../../domain/addAddress/add_address_entity.dart';

part 'add_address_event.dart';
part 'add_address_state.dart';

class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  final AddAddressUseCase addAddressUseCase;

  AddAddressBloc({required this.addAddressUseCase}) : super(AddAddressInitialState()) {
    on<AddAddressRequestEvent>(_onAddAddressRequest);
  }

  Future<void> _onAddAddressRequest(
    AddAddressRequestEvent event,
    Emitter<AddAddressState> emit,
  ) async {
    emit(AddAddressLoadingState());
    try {
      final result = await addAddressUseCase.execute(event.address);

      if (result['status_code'] == 403) {
        emit(AddAddressUnauthorizedState());
      } else {
        emit(AddAddressSuccessState(message: result['message']));
      }
    } catch (error) {
      emit(AddAddressErrorState(errorMessage: 'Failed to add address: $error'));
    }
  }
}