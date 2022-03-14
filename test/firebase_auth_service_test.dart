// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:prasso_app/models/api_user.dart';

void main() {
  group('User', () {
    test('null uid throws exception', () {
      expect(const ApiUser(uid: ''), throwsAssertionError);
    }, skip: true);
  });
}
