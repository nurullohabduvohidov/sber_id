import 'dart:io';
import 'package:flutter/foundation.dart';

import 'models/auth_response.dart';
import 'services/sber_id_ios_service.dart';
import 'services/sber_id_android_service.dart';

/// Main Sber ID platform class
class SberId {
  static SberId? _instance;

  late SBerIdIosService _iosService;
  late SBerIdAndroidService _androidService;

  SberId._() {
    _iosService = SBerIdIosService();
    _androidService = SBerIdAndroidService();
  }

  /// Get singleton instance
  static SberId get instance {
    _instance ??= SberId._();
    return _instance!;
  }

  /// Initialize Sber ID (if needed for configuration)
  static void initialize() {
    // Configuration setup if needed
    if (kDebugMode) {
      print('Sber ID initialized');
    }
  }

  /// Login with platform-specific method
  Future<SBerIdAuthResponse?> login() async {
    if (Platform.isIOS) {
      return await _iosService.login();
    } else if (Platform.isAndroid) {
      return await _androidService.login();
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  /// Check if Sber ID app is installed
  Future<bool> isSberIdInstalled() async {
    if (Platform.isIOS) {
      return await _iosService.isSBerIdInstalled();
    } else if (Platform.isAndroid) {
      return await _androidService.isSBerIdInstalled();
    } else {
      return false;
    }
  }

  /// Logout from Sber ID
  Future<bool> logout() async {
    if (Platform.isIOS) {
      return await _iosService.logout();
    } else if (Platform.isAndroid) {
      return await _androidService.logout();
    } else {
      return false;
    }
  }

  /// Check current platform
  String get currentPlatform {
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (kIsWeb) return 'Web';
    return 'Unknown';
  }
}