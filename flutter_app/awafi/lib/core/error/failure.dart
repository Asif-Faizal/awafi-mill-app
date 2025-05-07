abstract class Failure {
  final String message;

  Failure([this.message = 'An unknown error occurred']);
}
// server_failure.dart
class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server error occurred']);
}
