import 'package:flutter_test/flutter_test.dart';
import 'package:sber_id/sber_id.dart';

void main() {
  test('SBerId instance test', () {
    expect(SBerId.instance, isNotNull);
  });
}