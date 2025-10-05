import 'dart:async';
import 'dart:io';

class NetworkConnection {
  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (error) {
      return false;
    }
  }
}
