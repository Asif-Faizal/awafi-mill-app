part of 'connectivity_bloc.dart';

sealed class ConectivityState extends Equatable {
  const ConectivityState();
  
  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConectivityState {}

class ConnectivityDisconnected extends ConectivityState {}

class ConnectivityConnected extends ConectivityState {}

class ConnectivityLoading extends ConectivityState {}