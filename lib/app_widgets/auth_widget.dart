library custom_buttons;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/models/api_user.dart';

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
    final authStateChanges = watch(authStateChangesProvider);
    return authStateChanges.when(
        data: (user) => _data(context, user),
        loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        error: (_, __) => nonSignedInBuilder(context)
        //Scaffold(
        //  body: EmptyContent(
        //    title: 'Something went wrong',
        //    message: 'Can\'t load data right now. Please contact support',
        //  ),
        //),
        );
  }

  Widget _data(BuildContext context, ApiUser user) {
    if (user != null) {
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
