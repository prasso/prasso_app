// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:prasso_app/app_widgets/apps/app_web_view.dart';

class AppRunListTileModel {
  const AppRunListTileModel(
      {@required this.leadingText,
      @required this.pageUrl,
      this.pageTitle,
      this.sortOrder,
      this.isHeader = false,
      this.isLoading = false});
  final String leadingText;
  final String pageUrl;
  final String pageTitle;
  final int sortOrder;
  final bool isHeader;
  final bool isLoading;
}

class AppRunListTile extends StatelessWidget {
  const AppRunListTile({@required this.model});

  final AppRunListTileModel model;

  Future<void> _showWebViewWithUrl(
      String pageTitle, String pageUrl, BuildContext context) async {
    //show the webview with this url.
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
        builder: (dynamic context) => AppRunWebView(
              title: pageTitle,
              selectedUrl: pageUrl,
            )));
  }

  @override
  Widget build(BuildContext context) {
    const fontSize = 16.0;
    return Container(
      color: model.isHeader ? Colors.orange[100] : null,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Text(
            model.pageTitle ?? 'no page title',
            style: TextStyle(color: Colors.green[700], fontSize: fontSize),
            textAlign: TextAlign.left,
          ),
          Expanded(child: Container()),
          SizedBox(
            width: 90.0,
            child: TextButton(
              child: const Text('Open'),
              onPressed: model.isLoading
                  ? null
                  : () => _showWebViewWithUrl(
                      model.pageTitle ?? '', model.pageUrl ?? '', context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppRunListTileModel>('model', model));
  }
}
