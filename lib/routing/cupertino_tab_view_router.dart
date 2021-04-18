// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:prasso_app/app_widgets/apps/app_web_view.dart';
import 'package:prasso_app/models/app.dart';

class CupertinoTabViewRoutes {
  static const webViewPage = '/app_web_view';
}

class CupertinoTabViewRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CupertinoTabViewRoutes.webViewPage:
        final AppModel app = settings.arguments as AppModel;
        return CupertinoPageRoute(
          builder: (dynamic _) => AppRunWebView(
              title: app.pageTitle,
              selectedUrl: app.pageUrl,
              extraHeaderInfo: app.extraHeaderInfo),
          settings: settings,
          fullscreenDialog: false,
        );
    }
    return null;
  }
}
