part of 'connectivity_bloc.dart';

sealed class ConectivityEvent extends Equatable {
  const ConectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityLost extends ConectivityEvent {}

class ConnectivityGained extends ConectivityEvent {}

class RetryConnectivity extends ConectivityEvent {}