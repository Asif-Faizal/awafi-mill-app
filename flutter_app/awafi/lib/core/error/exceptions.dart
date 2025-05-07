class UserNotLoggedInException implements Exception {
  final String message;
  UserNotLoggedInException(this.message);

  @override
  String toString() => 'UserNotLoggedInException: $message';
}
