// Package imports:
// Project imports:
import 'package:delegate_app/models/api_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    test('null uid throws exception', () {
      expect(const ApiUser(uid: ''), throwsAssertionError);
    }, skip: true);
  });
}
