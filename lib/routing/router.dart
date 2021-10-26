// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:prasso_app/app_widgets/apps/edit_app_page.dart';
import 'package:prasso_app/app_widgets/home/home_page.dart';
import 'package:prasso_app/app_widgets/onboarding/intro_page.dart';
import 'package:prasso_app/app_widgets/sign_in/email_password_sign_in_ui.dart';
import 'package:prasso_app/app_widgets/sign_in/sign_in_page.dart';

class Routes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  static const emailPasswordRegisterPage = '/email-password-register-in-page';
  static const editAppPage = '/edit-app-page';
  static const homePage = '/home-page';
  static const introPages = '/intro-pages';
  static const login = '/login';
}

class Router {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.emailPasswordRegisterPage:
        return MaterialPageRoute<dynamic>(
          builder: (dynamic _) => EmailPasswordSignInPage(
            onSignedIn: args,
            formType: EmailPasswordSignInFormType.register,
          ),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.emailPasswordSignInPage:
        return MaterialPageRoute<dynamic>(
          builder: (dynamic _) => EmailPasswordSignInPage(
              onSignedIn: args, formType: EmailPasswordSignInFormType.signIn),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.editAppPage:
        return MaterialPageRoute<dynamic>(
          builder: (dynamic _) =>
              EditAppPage(key: GlobalKey<FormState>(), appinfo: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.homePage:
        return MaterialPageRoute<dynamic>(
          builder: (dynamic _) => const HomePage(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.introPages:
        return MaterialPageRoute<dynamic>(
          builder: (dynamic _) => IntroPage(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.login:
        return MaterialPageRoute<dynamic>(
          builder: (dynamic _) => SignInPage(),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
