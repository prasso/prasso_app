// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';

final editAppViewModel = ChangeNotifierProvider((ref) => EditAppViewModel());

class EditAppViewModel extends ChangeNotifier {
  EditAppViewModel();

  AppModel? appInfo;
  final formKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<bool> submit(BuildContext context, PrassoApiRepository auth,
      FirestoreDatabase database) async {
    if (_validateAndSaveForm()) {
      try {
        await auth.updateFirebaseApps(context, appInfo!, database);
        //also update the API
        await auth.addApp(appInfo!);

        Navigator.of(context).pop();
      } catch (e) {
        unawaited(showExceptionAlertDialog(
          context: context,
          title: 'Operation failed',
          exception: e,
        ));
      }
    }
    return true;
  }
}
