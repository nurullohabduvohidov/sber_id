import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/auth_response.dart';

class SBerIdIosService {
  static const MethodChannel _channel = MethodChannel('sber_id_auth');

  Future<SBerIdAuthResponse?> login() async {
    try {
      final result = await _channel.invokeMethod("startSberIDAuth");
      if (kDebugMode) {
        print("iOS Sber ID result: $result");
      }

      if (result != null) {
        return SBerIdAuthResponse.fromMap(Map<String, dynamic>.from(result));
      }
      return SBerIdAuthResponse(isSuccess: false, error: 'No result received');
    } catch (e) {
      if (kDebugMode) {
        print("iOS Sber ID error: $e");
      }
      return SBerIdAuthResponse(isSuccess: false, error: e.toString());
    }
  }

  Future<bool> isSBerIdInstalled() async {
    try {
      return await _channel.invokeMethod("isSberIdInstalled") ?? false;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking Sber ID installation: $e");
      }
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      return await _channel.invokeMethod("logout") ?? false;
    } catch (e) {
      if (kDebugMode) {
        print("iOS logout error: $e");
      }
      return false;
    }
  }
}