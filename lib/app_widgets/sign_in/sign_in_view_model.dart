// Flutter imports:
// Project imports:
import 'package:delegate_app/models/api_user.dart';
import 'package:delegate_app/services/prasso_api_repository.dart';
import 'package:flutter/foundation.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel({required this.auth});
  final PrassoApiRepository? auth;
  bool isLoading = false;
  dynamic error;

  // ignore: unused_element
  Future<ApiUser?> _signIn(Future<ApiUser> Function() signInMethod) async {
    try {
      isLoading = true;
      notifyListeners();
      await signInMethod();
      error = null;
    } catch (e) {
      error = e;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
  /*

  Future<void> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }

  Future<void> signInWithFacebook() async {
    return await _signIn(auth.signInWithFacebook);
  }

  Future<void> signInWithApple() async {
    return await _signIn(auth.signInWithApple);
  }
  */
}
