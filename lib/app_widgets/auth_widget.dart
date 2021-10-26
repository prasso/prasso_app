library custom_buttons;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';

import 'home/cupertino_home_scaffold_view_model.dart';

import 'home/cupertino_home_scaffold_view_model.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key key,
    @required this.signedInBuilder,
    @required this.nonSignedInBuilder,
  }) : super(key: key);
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final cupertinoVM = watch(cupertinoHomeScaffoldVMProvider);
    final sharedPreferences = watch(sharedPreferencesService);
    final authStateChanges = watch(userChangesProvider);
    return authStateChanges.when(
        data: (user) => _data(context, user, cupertinoVM, sharedPreferences),
        loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        error: (_, __) => nonSignedInBuilder(context));
  }

  Widget _data(
      BuildContext context,
      ApiUser user,
      CupertinoHomeScaffoldViewModel cupertinoVM,
      SharedPreferencesService sharedPreferences) {
    if (user != null &&
        cupertinoVM.tabs != null &&
        cupertinoVM.tabs.isNotEmpty) {
      return signedInBuilder(context);
    }
    return nonSignedInBuilder(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder>.has(
        'nonSignedInBuilder', nonSignedInBuilder));
    properties.add(ObjectFlagProperty<WidgetBuilder>.has(
        'signedInBuilder', signedInBuilder));
  }
}
