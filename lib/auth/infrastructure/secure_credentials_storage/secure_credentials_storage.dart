import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:i_streamo_github/auth/domain/auth_failure.dart';

///
class SecureCredentialsStroage {
  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();
  final String _key = '#@!Key_for_access';

  ///
  Future<Either<AuthFailure, Map<String, dynamic>?>> getUserStates() async {
    try {
      final JsonData = await _flutterSecureStorage.read(key: _key);
      if (JsonData == null) {
        return right(null);
      }
      final decodedJson = json.decode(JsonData);
      return right(decodedJson);
    } on PlatformException {
      return left(AuthFailureStorage());
    }
  }

  ///
  Future<Either<AuthFailure, Unit>> saveUserStates(
      Map<String, dynamic> data) async {
    try {
      final JsonData = json.encode(data);
      await _flutterSecureStorage.write(key: _key, value: JsonData);
      return right(unit);
    } on PlatformException {
      return left(AuthFailureStorage());
    }
  }

  ///
  Future<Either<AuthFailure, Unit>> deleteUserState() async {
    try {
      await _flutterSecureStorage.delete(key: _key);
      return right(unit);
    } on PlatformException {
      return left(AuthFailureStorage());
    }
  }
}
