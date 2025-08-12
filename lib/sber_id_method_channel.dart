import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sber_id_platform_interface.dart';
import 'src/models/auth_response.dart';
import 'src/models/sber_id_config.dart';

class MethodChannelSBerId extends SBerIdPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('sber_id_auth');

  @override
  Future<void> initialize(SBerIdConfig config) async {
    try {
      await methodChannel.invokeMethod('initialize', config.toMap());
    } catch (e) {
      throw Exception('Failed to initialize Sber ID: $e');
    }
  }

  @override
  Future<SBerIdAuthResponse?> login() async {
    try {
      final result = await methodChannel.invokeMethod('startSberIDAuth');
      if (result != null) {
        return SBerIdAuthResponse.fromMap(Map<String, dynamic>.from(result));
      }
      return null;
    } on PlatformException catch (e) {
      return SBerIdAuthResponse.error(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<bool> isSBerIdInstalled() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('isSberIdInstalled');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await methodChannel.invokeMethod('logout');
    } catch (e) {
      // Logout error ni ignore qilamiz
    }
  }
}