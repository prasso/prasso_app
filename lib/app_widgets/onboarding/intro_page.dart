import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prasso_app/app_widgets/Onboarding/slider_model.dart';
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:prasso_app/app_widgets/initial_profile/initial_profile2.dart';
import 'package:prasso_app/common_widgets/custom_buttons.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

import 'intro_viewmodel.dart';

class IntroPage extends HookConsumerWidget {
  Future<void> onNext(WidgetRef ref, BuildContext context) async {
    final IntroViewModel introViewModel = ref.read(introViewModelProvider);
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
        description: 'Tell us about you\n',
        title: 'Personal Prototype',
        localImageSrc: 'media/Screen2-Teaching-cuate.svg',
        backgroundColor: PrassoColors.lightGray)
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final IntroViewModel introViewModel = ref.read(introViewModelProvider);

    if (introViewModel.index < slides.length - 1) {
      return _showVideoIntroScreen(ref, context, introViewModel);
    } else {
      introViewModel.index = slides.length - 1;
      return _showProfileEditorScreen(context, introViewModel, ref);
    }
  }

  Widget _showVideoIntroScreen(
      WidgetRef ref, BuildContext context, IntroViewModel introViewModel) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              slides[introViewModel.index].description ?? '',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const CircleAvatar(
              radius: 200.0,
              backgroundImage: AssetImage('media/TheTree.png'),
            ),
            Text(
              'Easy to use.',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomRaisedButton(
                onPressed: () {
                  onNext(ref, context);
                },
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: 15,
                height: 50,
                child: Text(
                  'Continue to the app',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    )));
  }

  Widget _showProfileEditorScreen(
      BuildContext context, IntroViewModel introViewModel, WidgetRef ref) {
    final _viewmodel = ref.watch(editUserProfileViewModel);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Text(
              slides[introViewModel.index].description ?? '',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: InitialProfile(Strings.fromClassIntroPage, _viewmodel)),
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
