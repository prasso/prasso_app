import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:video_player/video_player.dart';
import '../top_level_providers.dart';

final introViewModelProvider = ChangeNotifierProvider<IntroViewModel>((ref) {
  final SharedPreferencesService localSharedPreferencesService =
      ref.watch(sharedPreferencesService);
  return IntroViewModel(localSharedPreferencesService);
});

class IntroViewModel extends ChangeNotifier {
  IntroViewModel(this.localSharedPreferencesService) : super() {
    state = localSharedPreferencesService?.isIntroComplete();

    // Pointing the video controller to mylocal asset.
    videoController = VideoPlayerController.asset('media/Optamize.mov');

    videoController.initialize().then((_) {
      // Once the video has been loaded we play the video and set looping to true.
      videoController.play();
      videoController.setLooping(true);
    });
  }

  final SharedPreferencesService localSharedPreferencesService;
  VideoPlayerController videoController;
  bool state = true;
  int index = 0;

  Future<void> completeIntro(BuildContext context, PrassoApiRepository auth,
      FirestoreDatabase database, EditUserProfileViewModel _viewmodel) async {
    //save to api and this gets the yourhealth token and yourhealth profile updated

    state = true;
    const bool canPop = false;
    await _viewmodel.saveUser(context, auth, database, canPop: canPop);
    await localSharedPreferencesService.setIntroComplete();
    notifyListeners();
  }

  Future<void> incrementIntro() async {
    ++index;
    notifyListeners();
  }

  bool isIntroComplete() {
    return state;
  }
}
