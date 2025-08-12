import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sber_id/sber_id_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSBerId platform = MethodChannelSBerId();
  const MethodChannel channel = MethodChannel('sber_id_auth');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'startSberIDAuth':
            return {
              'isSuccess': true,
              'authCode': 'test_auth_code',
              'state': 'test_state',
              'nonce': 'test_nonce'
            };
          case 'isSberIdInstalled':
            return true;
          case 'logout':
            return null;
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('login success', () async {
    final result = await platform.login();
    expect(result?.isSuccess, true);
    expect(result?.authCode, 'test_auth_code');
  });

  test('isSberIdInstalled', () async {
    final result = await platform.isSBerIdInstalled();
    expect(result, true);
  });

  test('logout', () async {
    // Should not throw exception
    await platform.logout();
  });
}