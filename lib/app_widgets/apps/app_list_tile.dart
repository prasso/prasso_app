// Flutter imports:
// Project imports:
import 'package:delegate_app/models/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({Key? key, required this.app, this.onTap})
      : super(key: key);
  final AppModel app;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(app.pageTitle!),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppModel>('app', app));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}
