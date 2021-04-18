// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: WebView(
          initialUrl: selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) {
            final Map<String, String> headers =
                Map.from(json.decode(extraHeaderInfo ?? '{}'));
            webViewController.loadUrl(selectedUrl, headers: headers);
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
