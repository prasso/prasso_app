// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:prasso_app/app_widgets/apps/app_web_view.dart';
import 'package:prasso_app/app_widgets/sign_in/email_password_sign_in_ui.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/routing/router.dart';

class CupertinoTabViewRoutes {
  static const webViewPage = '/app_web_view';
}

// ignore: avoid_classes_with_only_static_members
class CupertinoTabViewRouter {
  static Route<String>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.emailPasswordSignInPage:
        return CupertinoPageRoute(
          builder: (dynamic _) => const EmailPasswordSignInPage(
              formType: EmailPasswordSignInFormType.signIn),
          settings: settings,
          fullscreenDialog: true,
        );
      case CupertinoTabViewRoutes.webViewPage:
        // ignore: avoid_as
        final AppModel? app = settings.arguments is AppModel
            ? settings.arguments as AppModel
            : null;

        return CupertinoPageRoute(
          builder: (dynamic _) => AppRunWebView(
              title: app!.pageTitle,
              selectedUrl: app.pageUrl,
              extraHeaderInfo: app.extraHeaderInfo),
          settings: settings,
          fullscreenDialog: false,
        );
    }
    return null;
  }
}
