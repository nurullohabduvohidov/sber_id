import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'sber_id_method_channel.dart';
import 'src/models/auth_response.dart';
import 'src/models/sber_id_config.dart';

abstract class SBerIdPlatform extends PlatformInterface {
  SBerIdPlatform() : super(token: _token);

  static final Object _token = Object();
  static SBerIdPlatform _instance = MethodChannelSBerId();

  static SBerIdPlatform get instance => _instance;

  static set instance(SBerIdPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize(SBerIdConfig config) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<SBerIdAuthResponse?> login() {
    throw UnimplementedError('login() has not been implemented.');
  }

  Future<bool> isSBerIdInstalled() {
    throw UnimplementedError('isSberIdInstalled() has not been implemented.');
  }

  Future<void> logout() {
    throw UnimplementedError('logout() has not been implemented.');
  }
}