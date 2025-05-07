import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/addCart/add_cart_entity.dart';
import '../../domain/addCart/add_to_cart.dart';

part 'add_cart_event.dart';
part 'add_cart_state.dart';

class AddCartBloc extends Bloc<AddCartEvent, AddCartState> {
  final AddCartItemUseCase addCartItemUseCase;

  AddCartBloc({required this.addCartItemUseCase}) : super(CartInitial()) {
    on<AddCartItemEvent>((event, emit) async {
      emit(AddCartLoading());
      try {
        await addCartItemUseCase.call(event.cartItem);

        await Future.delayed(Duration(seconds: 2));
        emit(CartSuccess());
      } catch (e) {
        emit(CartFailure(error: e.toString()));
      }
    });
  }
}
