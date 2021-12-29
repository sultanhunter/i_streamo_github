///
abstract class AuthFailure {}

///
class AuthFailureServer extends AuthFailure {
  ///
  final String? errorMessage;

  ///
  final int? errorCode;

  ///
  AuthFailureServer({this.errorMessage, this.errorCode});
}

///
class AuthFailureStorage extends AuthFailure {}

///
class AuthFailureNoInternet extends AuthFailure {
  ///
  final String errorMessage = 'No Internet';
}
