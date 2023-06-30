import 'package:delegate_app/app_widgets/apps/app_web_view.dart';
import 'package:delegate_app/app_widgets/onboarding/slider_model.dart';
import 'package:delegate_app/common_widgets/custom_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'onboarding_viewmodel.dart';

// ignore: must_be_immutable
class OnboardingPage extends HookConsumerWidget {
  Future<void> onGetStarted(WidgetRef ref, BuildContext context) async {
    final OnboardingViewModel onboardingViewModel =
        ref.read(onboardingViewModelProvider);
    await onboardingViewModel.completeOnboarding();
  }

  Future<void> _showWebViewWithUrl(
      String pageTitle, String pageUrl, BuildContext context) async {
    //show the webview with this url.
    // ignore: strict_raw_type
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
        builder: (dynamic context) => AppRunWebView(
              title: pageTitle,
              selectedUrl: pageUrl,
              extraHeaderInfo: '',
            )));
  }

  Future<void> onNext(WidgetRef ref, BuildContext context) async {
    final OnboardingViewModel onboardingViewModel =
        ref.read(onboardingViewModelProvider);
    await onboardingViewModel.incrementOnboarding();
  }

  final List<SliderModel> slides = [
    SliderModel(
        description: 'create your own mobile app from scratch\n',
        title: 'Why Prasso?',
        localImageSrc: 'media/Mobilewireframe-rafiki.svg',
        backgroundColor: Colors.grey[200]),
    SliderModel(
        description:
            'Create your prototype.\nReview the results in the Prasso app.\n',
        title: 'Rapid Prototype',
        localImageSrc: 'media/Operatingsystemupgrade-pana.svg',
        backgroundColor: Colors.grey[200]),
    SliderModel(
        description: 'Personalize your mobile app with branding and content.\n',
        title: 'Full Control',
        localImageSrc: 'media/Phonemaintenance-rafiki.svg',
        backgroundColor: Colors.grey[200]),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OnboardingViewModel onboardingViewModel =
        ref.read(onboardingViewModelProvider);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const Expanded(child: SizedBox(height: 50.0)),
            Text(
              slides[onboardingViewModel.index].description!,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: FractionallySizedBox(
              widthFactor: 0.7,
              child: SvgPicture.asset(
                  slides[onboardingViewModel.index].localImageSrc!),
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomRaisedButton(
                onPressed: () {
                  if (onboardingViewModel.index == slides.length - 1) {
                    onGetStarted(ref, context);
                  } else {
                    onNext(ref, context);
                  }
                },
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: 15,
                height: 50,
                child: Text(
                  onboardingViewModel.index == slides.length - 1
                      ? 'Get Started'
                      : 'Next',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => _showWebViewWithUrl(
                    'storyset', 'https://storyset.com/people', context),
                child: const Text(
                  'Illustration by Freepik Storyset', // ${Strings.prodUrl}',
                  style: TextStyle(fontSize: 8, color: Colors.black),
                ),
              ),
            )
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
