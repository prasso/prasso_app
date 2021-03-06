// Flutter imports:

import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:prasso_app/app_widgets/auth_widget.dart';
import 'package:prasso_app/app_widgets/home/home_page.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/routing/router.dart' as _rtr;
import 'package:prasso_app/services/shared_preferences_service.dart';
import 'app_widgets/onboarding/onboarding_page.dart';
import 'app_widgets/onboarding/onboarding_viewmodel.dart';
import 'app_widgets/sign_in/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FlutterConfig.loadEnvVariables();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesService.overrideWithValue(
        SharedPreferencesService(sharedPreferences),
      ),
    ],
    child: PrassoCore(),
  ));
}

class PrassoCore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  FirebaseCrashlytics.instance.crash();

    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.indigo),
        debugShowCheckedModeBanner: false,
        home: AuthWidget(
          nonSignedInBuilder: (_) => Consumer(
            builder: (context, watch, _) {
              final bool didCompleteOnboarding =
                  watch(onboardingViewModelProvider).state;
              return didCompleteOnboarding ? SignInPage() : OnboardingPage();
            },
          ),
          signedInBuilder: (_) => const HomePage(),
        ),
        onGenerateRoute: _rtr.Router.onGenerateRoute);
  }
}
