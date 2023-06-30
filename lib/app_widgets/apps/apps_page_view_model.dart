// Flutter imports:
// Project imports:
import 'package:delegate_app/app_widgets/apps/edit_app_page.dart';
import 'package:delegate_app/app_widgets/top_level_providers.dart';
import 'package:delegate_app/common_widgets/alert_dialogs.dart';
import 'package:delegate_app/models/app.dart';
import 'package:delegate_app/services/firestore_database.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

final appsPageViewModel = ChangeNotifierProvider<AppsPageViewModel>(
    (ref) => AppsPageViewModel(database: ref.read(databaseProvider)));

class AppsPageViewModel extends ChangeNotifier {
  AppsPageViewModel({required this.database});
  final FirestoreDatabase? database;

  Future<void> show({required BuildContext context, AppModel? app}) async {
    await Navigator.of(context)
        .push<MaterialPageRoute<String>>(MaterialPageRoute<String>(
      builder: (dynamic context) =>
          EditAppPage(key: GlobalKey<FormState>(), appinfo: app),
      fullscreenDialog: true,
    ) as Route<MaterialPageRoute<String>>);
  }

  Future<void> delete(BuildContext context, AppModel app) async {
    try {
      await database!.deleteApp(app);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }
}
