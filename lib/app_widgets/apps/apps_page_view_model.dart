// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:prasso_app/app_widgets/apps/edit_app_page.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/services/firestore_database.dart';

final appsPageViewModel = ChangeNotifierProvider(
    (ref) => AppsPageViewModel(database: ref.read(databaseProvider)));

class AppsPageViewModel extends ChangeNotifier {
  AppsPageViewModel({@required this.database});
  final FirestoreDatabase database;

  Future<void> show({BuildContext context, AppModel app}) async {
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
      builder: (context) =>
          EditAppPage(key: GlobalKey<FormState>(), appinfo: app),
      fullscreenDialog: true,
    ));
  }

  Future<void> delete(BuildContext context, AppModel app) async {
    try {
      await database.deleteApp(app);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }
}
