import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';
import '../top_level_providers.dart';

final onboardingViewModelProvider =
    ChangeNotifierProvider<OnboardingViewModel>((ref) {
  final SharedPreferencesService localSharedPreferencesService =
      ref.watch(sharedPreferencesService);
  return OnboardingViewModel(localSharedPreferencesService);
});

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel(this.localSharedPreferencesService) : super() {
    state = localSharedPreferencesService.isOnboardingComplete();
  }
  final SharedPreferencesService localSharedPreferencesService;

  bool state = false;
  int index = 0;

  Future<void> completeOnboarding() async {
    await localSharedPreferencesService.setOnboardingComplete();
    state = true;
    notifyListeners();
  }

  Future<void> incrementOnboarding() async {
    ++index;
    notifyListeners();
  }

  bool get isOnboardingComplete => state;
}
