import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prasso_app/app_widgets/apps/app_web_view.dart';
import 'package:prasso_app/app_widgets/onboarding/slider_model.dart';
import 'package:prasso_app/common_widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

import 'onboarding_viewmodel.dart';

// ignore: must_be_immutable
class OnboardingPage extends HookWidget {
  Future<void> onGetStarted(BuildContext context) async {
    final OnboardingViewModel onboardingViewModel =
        context.read(onboardingViewModelProvider);
    await onboardingViewModel.completeOnboarding();
  }

  Future<void> _showWebViewWithUrl(
      String pageTitle, String pageUrl, BuildContext context) async {
    //show the webview with this url.
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
        builder: (dynamic context) => AppRunWebView(
              title: pageTitle,
              selectedUrl: pageUrl,
              extraHeaderInfo: '',
            )));
  }

  Future<void> onNext(BuildContext context) async {
    final OnboardingViewModel onboardingViewModel =
        context.read(onboardingViewModelProvider);
    await onboardingViewModel.incrementOnboarding();
  }

  final List<SliderModel> slides = [
    SliderModel(
        description:
            'Rapid Prototyping\n. Plug Your Designs In.\n Play Your App\n',
        title: 'Why Prasso?',
        localImageSrc: 'media/Screen1-Movingforward-pana.svg',
        backgroundColor: PrassoColors.lightGray),
    SliderModel(
        description: 'Communicate with your coach.\nStore progress photos.\n',
        title: 'Personal coaching',
        localImageSrc: 'media/Screen2-Teaching-cuate.svg',
        backgroundColor: PrassoColors.lightGray),
    SliderModel(
        description: 'Keep a food journal.\nPlan your menu.\n',
        title: 'Food Journal and Menu Planning',
        localImageSrc: 'media/Screen3-Onlinecalendar-bro.svg',
        backgroundColor: PrassoColors.lightGray),
  ];

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel onboardingViewModel =
        context.read(onboardingViewModelProvider);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const Expanded(child: SizedBox(height: 50.0)),
            Text(
              slides[onboardingViewModel.index].description,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: FractionallySizedBox(
              widthFactor: 0.7,
              child: SvgPicture.asset(
                  slides[onboardingViewModel.index].localImageSrc),
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomRaisedButton(
                onPressed: () {
                  if (onboardingViewModel.index == slides.length - 1) {
                    onGetStarted(context);
                  } else {
                    onNext(context);
                  }
                },
                color: Theme.of(context).accentColor,
                borderRadius: 15,
                height: 50,
                child: Text(
                  onboardingViewModel.index == slides.length - 1
                      ? 'Get Started'
                      : 'Next',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
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
