import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/checkout/checkout_datasource.dart';
import '../../domain/checkout/checkout.dart';
import '../../domain/checkout/checkout_entity.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutUseCase checkoutUseCase;

  CheckoutBloc({required this.checkoutUseCase}) : super(CheckoutInitial()) {
    on<CheckoutInitiated>((event, emit) async {
      emit(CheckoutLoading());
      try {
        await checkoutUseCase(event.checkoutEntity);
        emit(CheckoutSuccess());
      } on UnauthorisedException {
        emit(UserUnauthorisedState());
      } catch (_) {
        emit(const CheckoutFailure("An error occurred while processing the checkout."));
      }
    });
  }
}