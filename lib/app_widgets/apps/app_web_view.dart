// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
//import 'package:prasso_app/app_widgets/top_level_providers.dart';
//import 'package:prasso_app/common_widgets/alert_dialogs.dart';
//import 'package:prasso_app/constants/keys.dart';
//import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';
// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

class AppRunWebView extends StatelessWidget {
  final String title;
  final String selectedUrl;
  final String extraHeaderInfo;

  final Completer<WebViewController> controllerCompleter =
      Completer<WebViewController>();

  AppRunWebView(
      {@required this.title,
      @required this.selectedUrl,
      @required this.extraHeaderInfo});

  Future<void> plugHeadersIn() async {
    final WebViewController controller = await controllerCompleter.future;

    final Map<String, String> headers = Map.from(json.decode(extraHeaderInfo));
    await controller.loadUrl(selectedUrl, headers: headers);
  }

  /* for reloading config after it changes 
  Future<void> _reloadConfig(BuildContext context) async {
    try {
      final authService = context.read(prassoApiService);
      final user = authService.currentUser;
      await authService.getAppConfig(user);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.refreshFailed,
        exception: e,
      ));
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(title, //'$selectedUrl $
              style: const TextStyle(color: PrassoColors.lightGray)),
          elevation: 2.0,
          /* actions: <Widget>[
              const SizedBox(height: 8),
            TextButton(
                key: const Key(Keys.reload),
                child: const Text(
                  Strings.reload,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: PrassoColors.lightGray,
                  ),
                ),
                onPressed: () => _reloadConfig(context),
              ),
            ]*/
        ),
        body: WebView(
          initialUrl: selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) {
            if (extraHeaderInfo != '') {
              final Map<String, String> headers =
                  Map.from(json.decode(extraHeaderInfo ?? '{}'));
              webViewController.loadUrl(selectedUrl, headers: headers);
            } else {
              webViewController.loadUrl(selectedUrl, headers: null);
            }
            controllerCompleter.complete(webViewController);
          },
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('selectedUrl', selectedUrl));
    properties.add(StringProperty('extraHeaderInfo', extraHeaderInfo));
    properties.add(DiagnosticsProperty<Completer<WebViewController>>(
        'controllerCompleter', controllerCompleter));
  }
}
