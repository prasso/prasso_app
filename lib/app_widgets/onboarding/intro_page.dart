import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:prasso_app/app_widgets/Onboarding/slider_model.dart';
import 'package:prasso_app/app_widgets/account/profile_form_children.dart';
import 'package:prasso_app/common_widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';
import 'package:video_player/video_player.dart';

import 'intro_viewmodel.dart';

class IntroPage extends HookWidget {
  Future<void> saveAndGetStarted(BuildContext context) async {
    final _viewmodel = context.read(editUserProfileViewModel);

    final auth = context.read(prassoApiService);
    final database = context.read(databaseProvider);

    final IntroViewModel introViewModel = context.read(introViewModelProvider);
    await introViewModel.completeIntro(context, auth, database, _viewmodel);
  }

  Future<void> onNext(BuildContext context) async {
    final IntroViewModel introViewModel = context.read(introViewModelProvider);
    await introViewModel.incrementIntro();
    //this trick is to reload the screen since it was navigated to directly and the view model state change is not initiating a redraw

    // ignore: invalid_use_of_protected_member
    (context as Element).reassemble();
  }

  final List<SliderModel> slides = [
    SliderModel(
        description:
            'Rapid Prototyping\n. Plug Your Designs In.\n Play Your App\n',
        title: 'Why Prasso?',
        localImageSrc: 'media/Screen1-Movingforward-pana.svg',
        backgroundColor: PrassoColors.lightGray),
    SliderModel(
        description: 'Tell us about your app\n',
        title: 'Personal Prototype',
        localImageSrc: 'media/Screen2-Teaching-cuate.svg',
        backgroundColor: PrassoColors.lightGray)
  ];

  @override
  Widget build(BuildContext context) {
    final IntroViewModel introViewModel = context.read(introViewModelProvider);

    if (introViewModel.index < slides.length - 1) {
      return _showVideoIntroScreen(context, introViewModel);
    } else {
      introViewModel.index = slides.length - 1;
      return _showProfileEditorScreen(context, introViewModel);
    }
  }

  Widget _showVideoIntroScreen(
      BuildContext context, IntroViewModel introViewModel) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Text(
              slides[introViewModel.index].description,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Text(
              slides[introViewModel.index].description,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: FractionallySizedBox(
                    child: VideoPlayer(introViewModel.videoController))),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomRaisedButton(
                onPressed: () {
                  onNext(context);
                },
                color: Theme.of(context).accentColor,
                borderRadius: 15,
                height: 50,
                child: Text(
                  'Continue',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    ));
  }

  Widget _showProfileEditorScreen(
      BuildContext context, IntroViewModel introViewModel) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Text(
              slides[introViewModel.index].description,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const Expanded(child: ProfileFormChildren()),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomRaisedButton(
                onPressed: () {
                  saveAndGetStarted(context);
                },
                color: Theme.of(context).accentColor,
                borderRadius: 15,
                height: 50,
                child: Text(
                  'Save and Get Started',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<SliderModel>('slides', slides));
  }
}
