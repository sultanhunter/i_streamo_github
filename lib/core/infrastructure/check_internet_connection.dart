import 'dart:io';

///
class CheckInternetConnection {
  ///
  static Future<bool> isInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      return false;
    }
    return false;
  }
}
