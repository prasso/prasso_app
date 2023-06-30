// Package imports:
// Project imports:
import 'package:delegate_app/app_widgets/sign_in/email_password_sign_in_ui.dart';
import 'package:delegate_app/services/prasso_api_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements PrassoApiRepository {}

void main() {
  MockAuthService mockAuthService;
  late EmailPasswordSignInModel model;

  setUp(() {
    mockAuthService = MockAuthService();
    model = EmailPasswordSignInModel(auth: mockAuthService);
  });

  tearDown(() {
    model.dispose();
  });

  test('updateEmail', () async {
    const sampleEmail = 'email@email.com';
    var didNotifyListeners = false;
    model.addListener(() => didNotifyListeners = true);

    model.updateEmail(sampleEmail);
    expect(model.email, sampleEmail);
    expect(didNotifyListeners, true);
  });
}
