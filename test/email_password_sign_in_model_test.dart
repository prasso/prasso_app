import 'package:prasso_app/app_widgets/sign_in/email_password_sign_in_ui.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prasso_app/services/prasso_api_service.dart';

class MockAuthService extends Mock implements PrassoApiService {}

void main() {
  MockAuthService mockAuthService;
  EmailPasswordSignInModel model;

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
