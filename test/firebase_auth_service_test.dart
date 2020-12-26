import 'package:flutter_test/flutter_test.dart';
import 'package:prasso_app/models/api_user.dart';

void main() {
  group('User', () {
    test('null uid throws exception', () {
      expect(ApiUser(uid: null), throwsAssertionError);
    }, skip: true);
  });
}
