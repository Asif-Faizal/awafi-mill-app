import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'notification_event.dart';
part 'notification_state.dart';
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirebaseMessaging firebaseMessaging;

  NotificationBloc({required this.firebaseMessaging}) : super(NotificationInitial()) {
    on<RequestNotificationPermission>(_onRequestNotificationPermission);
    on<InitializeNotifications>(_onInitializeNotifications);
  }

  Future<void> _onRequestNotificationPermission(
      RequestNotificationPermission event, Emitter<NotificationState> emit) async {
    try {
      final settings = await firebaseMessaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        emit(NotificationPermissionGranted());
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        emit(NotificationPermissionProvisional());
      } else {
        emit(NotificationPermissionDenied());
      }
    } catch (e) {
      emit(NotificationError("Failed to request notification permission: $e"));
    }
  }

  Future<void> _onInitializeNotifications(
      InitializeNotifications event, Emitter<NotificationState> emit) async {
    try {
      // Step 1: Check and Request Permission
      final settings = await firebaseMessaging.requestPermission();
      
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        emit(NotificationPermissionDenied());
        return; // Stop the process if permission is denied
      }

      if (Platform.isIOS) {
     String? apnsToken = await firebaseMessaging.getAPNSToken();
     if (apnsToken != null) {
       print('APNs Token: $apnsToken');
     } else {
       print('Failed to get APNs Token');
     }
   }

      // Step 2: Initialize notifications after permission is granted
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground notification received: ${message.notification?.title}');
        // Add custom handling for foreground notifications here
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Background notification opened: ${message.notification?.title}');
        // Navigate or handle actions when the app is opened from a notification
      });

      // Optionally get the initial notification if the app was opened from a notification
      final initialMessage = await firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print('App opened from terminated state: ${initialMessage.notification?.title}');
      }
      String? fcmToken = await firebaseMessaging.getToken();
      if (fcmToken != null) {
        print("FCM Token: $fcmToken");
      } else {
        print("Failed to get FCM Token");
      }

      emit(NotificationInitialized());
    } catch (e) {
      emit(NotificationError("Failed to initialize notifications: $e"));
    }
  }
}