import 'package:flutter/material.dart';

abstract class PaymentIntentEvent {}

class GetPaymentIntent extends PaymentIntentEvent {
  final BuildContext context;
  final int amount;

  GetPaymentIntent({required this.context, required this.amount});
} 