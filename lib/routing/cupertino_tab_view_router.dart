// Flutter imports:
// Project imports:
import 'package:delegate_app/app_widgets/apps/app_web_view.dart';
import 'package:delegate_app/models/app.dart';
import 'package:flutter/cupertino.dart';

class CupertinoTabViewRoutes {
  static const webViewPage = '/app_web_view';
}

// ignore: avoid_classes_with_only_static_members
class CupertinoTabViewRouter {
  static Route<String>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
