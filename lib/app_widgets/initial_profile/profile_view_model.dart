import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:prasso_app/app_widgets/initial_profile/create_profile_input_model.dart';
import 'package:prasso_app/app_widgets/initial_profile/profile_model.dart';
import 'package:prasso_app/app_widgets/onboarding/intro_viewmodel.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';

final profileViewModelProvider =
    ChangeNotifierProvider<ProfileViewModel>((ref) {
  final SharedPreferencesService localSharedPreferencesService =
      ref.watch(sharedPreferencesService);
  return ProfileViewModel(localSharedPreferencesService);
});

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this.localSharedPreferencesService) : super() {
    state = localSharedPreferencesService.isIntroComplete();
  }

  ProfileModel? profileModel;
  bool state = true;
  final SharedPreferencesService localSharedPreferencesService;

  // Create Profile
  Future<ProfileModel?> createProfileAPI(
      CreateProfileInputModel createProfileInputModel,
      BuildContext context) async {
    profileModel = ProfileModel.fromCreatePim(createProfileInputModel);

    final auth = context.read(prassoApiService);
    final user = auth?.currentUser;

    //save to api and this gets the yourhealth token and yourhealth profile updated
    state = true;
    final _viewmodel = context.read(editUserProfileViewModel);
    _viewmodel.setFromProfileViewModel(createProfileInputModel, user!);

    final database = context.read(databaseProvider);

    final IntroViewModel introViewModel = context.read(introViewModelProvider);
    await introViewModel.completeIntro(context, auth!, database!, _viewmodel);
    await localSharedPreferencesService.setIntroComplete();

    notifyListeners();
    return profileModel;
  }
}
