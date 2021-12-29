part of 'authentication_cubit.dart';

///
abstract class AuthenticationState extends Equatable {
  ///
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

///
class AuthenticationInitial extends AuthenticationState {}

///
class AuthenticationLoading extends AuthenticationState {}

///
class AuthenticationOtpSending extends AuthenticationState {}

///
class AuthenticationOtpSent extends AuthenticationState {}

///
class AuthenticationVerifyingOtp extends AuthenticationState {}

///
class AuthenticationSuccess extends AuthenticationState {
  ///
  final User user;

  ///
  AuthenticationSuccess({
    required this.user,
  });
  @override
  List<Object> get props => [
        user,
      ];
}

///
class UnAuthenticated extends AuthenticationState {}

///
class AuthenticationError extends AuthenticationState {
  ///
  final String? errorMessage;

  ///
  AuthenticationError({this.errorMessage});
}

///
class AuthenticationCheckingError extends AuthenticationState {
  ///
  final bool isBackgroundChecking;

  ///
  AuthenticationCheckingError({this.isBackgroundChecking = false});
}
