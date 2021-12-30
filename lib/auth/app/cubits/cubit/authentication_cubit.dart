import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i_streamo_github/auth/domain/auth_failure.dart';
import 'package:i_streamo_github/auth/infrastructure/firebase_authenticator.dart';
import 'package:i_streamo_github/repos/app/cubit/github_repos_cubit.dart';

part 'authentication_state.dart';

///
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuthenticator _firebaseAuthenticator;
  final GithubReposCubit _githubReposCubit;

  late StreamSubscription _streamSubscription;

  ///
  AuthenticationCubit(
    this._firebaseAuthenticator,
    this._githubReposCubit,
  ) : super(AuthenticationInitial()) {
    _streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        print('user is not null');
        emit(AuthenticationSuccess(user: user));
        print('auth state emitted');
      }
      if (user == null) {
        _githubReposCubit.deleteAllUserData();
        print('user is null');
        emit(UnAuthenticated());
        print('unauth state is emitted');
      }
    });
  }

  String? _verificationId;
  int? _token;

  ///
  Future<void> signInWithPhone(String phoneNumber) async {
    emit(AuthenticationOtpSending());
    final _successOrFailure = await _firebaseAuthenticator.signInWithPhone(
        phoneNumber: phoneNumber,
        verifyOtpCallBack: (verificationId, token) {
          emit(AuthenticationOtpSent());
          _verificationId = verificationId;
          _token = token;
        });

    _successOrFailure.fold((l) {
      if (l is AuthFailureNoInternet) {
        emit(AuthenticationError(errorMessage: l.errorMessage));
      } else {
        emit(const AuthenticationError());
      }
    }, (r) {});
  }

  ///
  Future<void> verifyOtpfromTheProfessional({
    required String otp,
  }) async {
    emit(AuthenticationVerifyingOtp());
    final _successOrFailure =
        await _firebaseAuthenticator.verifyOtpFromProfessional(
            otp: otp, verificationId: _verificationId!, resendToken: _token);
    _successOrFailure.fold((l) {
      if (l is AuthFailureNoInternet) {
        emit(AuthenticationError(errorMessage: l.errorMessage));
      }
      if (l is AuthFailureServer) {
        emit(AuthenticationError(errorMessage: l.errorMessage));
      }
    }, (r) {});
  }

  Future<void> logOut() async {
    _firebaseAuthenticator.logOut();
  }

  @override
  Future<void> close() async {
    _streamSubscription.cancel();
    super.close();
  }
}
