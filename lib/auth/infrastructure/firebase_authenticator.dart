import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i_streamo_github/auth/domain/auth_failure.dart';
import 'package:i_streamo_github/core/infrastructure/check_internet_connection.dart';

///
class FirebaseAuthenticator {
  final FirebaseAuth _firebaseAuth;

  ///
  FirebaseAuth get getFirebaseAuthInstance => _firebaseAuth;

  ///
  FirebaseAuthenticator(this._firebaseAuth);

  ///
  Future<Either<AuthFailure, Unit>> signInWithPhone(
      {required String phoneNumber,
      required void Function(String verificationId, int? token)
          verifyOtpCallBack}) async {
    final Completer<Either<AuthFailure, Unit>> completer = Completer();
    final value = await CheckInternetConnection.isInternetConnection();
    if (value) {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            try {
              await _firebaseAuth.signInWithCredential(phoneAuthCredential);
              completer.complete(right(unit));
            } on FirebaseAuthException catch (e) {
              completer
                  .complete(left(AuthFailureServer(errorMessage: e.message)));
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            completer
                .complete(left(AuthFailureServer(errorMessage: e.message)));
          },
          codeSent: verifyOtpCallBack,
          codeAutoRetrievalTimeout: (String verificationId) {});
    }
    if (!value) {
      completer.complete(left(AuthFailureNoInternet()));
    }

    return completer.future;
  }

  ///
  Future<Either<AuthFailure, Unit>> verifyOtpFromProfessional(
      {required String otp,
      required String verificationId,
      int? resendToken}) async {
    final Completer<Either<AuthFailure, Unit>> _completer = Completer();
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    final value = await CheckInternetConnection.isInternetConnection();

    if (value) {
      try {
        await _firebaseAuth.signInWithCredential(credential);
        _completer.complete(right(unit));
      } on FirebaseAuthException catch (e) {
        _completer.complete(left(AuthFailureServer(errorMessage: e.message)));
      }
    }
    if (!value) {
      _completer.complete(left(AuthFailureNoInternet()));
    }
    return _completer.future;
  }

  Future<void> logOut() async {
    _firebaseAuth.signOut();
  }
}
