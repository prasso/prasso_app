// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:prasso_app/routing/router.dart';
// Project imports:
import 'package:prasso_app/utils/prasso_themedata.dart';
// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

class AppRunWebView extends StatelessWidget {
  final String? title;
  final String? selectedUrl;
  final String? extraHeaderInfo;

  final Completer<WebViewController> controllerCompleter =
      Completer<WebViewController>();

  AppRunWebView(
      {required this.title,
      required this.selectedUrl,
      required this.extraHeaderInfo});

  Future<void> plugHeadersIn() async {
    final WebViewController controller = await controllerCompleter.future;

    final Map<String, String> headers =
        Map<String, String>.from(json.decode(extraHeaderInfo!));
    await controller.loadUrl(selectedUrl!, headers: headers);
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
          title: Text(title!, //'$selectedUrl $
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
          userAgent:
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
          initialUrl: selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) {
            if (extraHeaderInfo != '') {
              //if extra header info isn't json we need to ignore it
              Map<String, String> headers = {};
              try {
                headers = Map<String, String>.from(
                    json.decode(extraHeaderInfo ?? '{}'));
              } on FormatException catch (e) {
                print('The provided header string is not valid JSON: $e');
              }
              webViewController.loadUrl(selectedUrl!, headers: headers);
            } else {
              webViewController.loadUrl(selectedUrl!, headers: null);
            }
            controllerCompleter.complete(webViewController);
          },
          navigationDelegate: (navigation) async {
            debugPrint('selectedUrl: $selectedUrl');
            debugPrint('extraHeaderInfo: $extraHeaderInfo');
            if (navigation.url.contains('login')) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  Routes.emailPasswordSignInPage,
                  arguments: () => Navigator.of(context).pop(),
                );
              });
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
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
