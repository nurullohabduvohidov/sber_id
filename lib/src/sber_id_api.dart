import 'models/auth_response.dart';
import 'models/sber_id_config.dart';
import '../sber_id_platform_interface.dart';

class SBerId {
  SBerId._();
  static final SBerId instance = SBerId._();

  Future<void> initialize(SBerIdConfig config) async {
    return await SBerIdPlatform.instance.initialize(config);
  }

  Future<SBerIdAuthResponse?> login() async {
    return await SBerIdPlatform.instance.login();
  }

  Future<bool> isSBerIdInstalled() async {
    return await SBerIdPlatform.instance.isSBerIdInstalled();
  }

  Future<void> logout() async {
    return await SBerIdPlatform.instance.logout();
  }
}