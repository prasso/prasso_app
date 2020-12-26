import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/services/prasso_api_service.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel({@required this.auth});
  final PrassoApiService auth;
  bool isLoading = false;

  // ignore: unused_element
  Future<ApiUser> _signIn(Future<ApiUser> Function() signInMethod) async {
    try {
      isLoading = true;
      notifyListeners();
      return await signInMethod();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  /*
Future<ApiUser> signInAnonymously() async {
    return _signIn(auth.signInAnonymously);
  }

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
