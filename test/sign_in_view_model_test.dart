// Package imports:
// Project imports:
import 'package:delegate_app/app_widgets/sign_in/sign_in_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

void main() {
  MockAuthService? mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    SignInViewModel(auth: mockAuthService);
  });

  tearDown(() {
    mockAuthService = null;
  });
}
