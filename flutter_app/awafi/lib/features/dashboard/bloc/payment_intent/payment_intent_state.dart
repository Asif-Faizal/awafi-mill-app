abstract class PaymentIntentState {}

class PaymentIntentInitial extends PaymentIntentState {}

class PaymentIntentLoading extends PaymentIntentState {}

class PaymentIntentLoaded extends PaymentIntentState {
  final String secretKey;
  PaymentIntentLoaded(this.secretKey);
}

class PaymentIntentError extends PaymentIntentState {
  final String message;
  PaymentIntentError(this.message);
} 