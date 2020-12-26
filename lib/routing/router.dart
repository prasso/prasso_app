import 'package:flutter/material.dart';
import 'package:prasso_app/app_widgets/apps/edit_app_page.dart';
import 'package:prasso_app/app_widgets/sign_in/email_password_sign_in_ui.dart';

class Routes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  static const editAppPage = '/edit-app-page';
}

class Router {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.emailPasswordSignInPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPage(onSignedIn: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.editAppPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditAppPage(app: args),
          settings: settings,
          fullscreenDialog: true,
        );

      default:
        // TODO: Throw
        return null;
    }
  }
}
