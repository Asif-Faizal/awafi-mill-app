import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConectivityEvent, ConectivityState> {
  ConnectivityBloc() : super(ConnectivityInitial()) {
    checkInitialConnectivity();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      for (var result in results){
        if (result == ConnectivityResult.none) {
        add(ConnectivityLost());
      } else {
        add(ConnectivityGained());
      }
      }
    });
    on<ConnectivityLost>((event, emit) {
      emit(ConnectivityDisconnected());
    });
    on<ConnectivityGained>((event, emit) {
      emit(ConnectivityConnected());
    });
    on<RetryConnectivity>((event, emit) async {
      emit(ConnectivityLoading());
      await checkInitialConnectivity(); 
  });
  }
  Future<void> checkInitialConnectivity() async {
  final results = await Connectivity().checkConnectivity();
  for (var result in results) {
    if (result == ConnectivityResult.none) {
      add(ConnectivityLost());
    } else {
      add(ConnectivityGained());
    }
  }
}
}