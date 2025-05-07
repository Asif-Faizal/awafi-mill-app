part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();
  
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationPermissionGranted extends NotificationState {}

class NotificationPermissionDenied extends NotificationState {}

class NotificationPermissionProvisional extends NotificationState {}

class NotificationInitialized extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}