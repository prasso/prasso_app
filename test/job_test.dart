// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:prasso_app/models/app.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final app = AppModel.fromMap({'':''}, 'abc');
      expect(app, null);
    });
    test('app with all properties', () {
      final app = AppModel.fromMap(const {
        'pageTitle': 'Blogging',
        'pageUrl': 'https://www/google.com',
        'extraHeaderInfo': '{\'test_header\': \'flutter_test_header\'}'
      }, 'abc');
      expect(
          app,
          AppModel('abc', 'Blogging', 'https://www/google.com', 'icon', 'label',
              '{\'test_header\': \'flutter_test_header\'}', 1));
    });

    test('missing name', () {
      final app = AppModel.fromMap(const {
        'ratePerHour': 10,
      }, 'abc');
      expect(app, null);
    });
  });

  group('toMap', () {
    test('valid pageTitle, pageUrl', () {
      final AppModel app = AppModel('abc', 'Blogging', 'https://www/google.com',
          'icon', 'label', '{\'test_header\': \'flutter_test_header\'}', 1);
      expect(app.toMap(), {
        'pageTitle': 'Blogging',
        'pageUrl': 10,
      });
    });
  });
}
