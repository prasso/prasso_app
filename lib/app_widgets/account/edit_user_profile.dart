// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:prasso_app/app_widgets/initial_profile/initial_profile2.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

class EditUserProfile extends HookWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
      builder: (dynamic context) => const EditUserProfile(),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final _viewmodel = useProvider(editUserProfileViewModel);
    final auth = useProvider(prassoApiService);
    final database = useProvider(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(_viewmodel.usr == null ? Strings.newuser : Strings.edituser,
            style: TextStyle(color: Theme.of(context).backgroundColor)),
        actions: <Widget>[
          TextButton(
            child: const Text(
              Strings.save,
              style: TextStyle(fontSize: 18, color: PrassoColors.lightGray),
            ),
            onPressed: () => _viewmodel.submit(context, auth!, database!),
          ),
        ],
      ),
      body: InitialProfile(Strings.fromClassEditUserProfile),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
        'editUserProfileViewModel', editUserProfileViewModel));
  }
}
