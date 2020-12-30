library custom_buttons;

// import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/services/prasso_api_service.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:prasso_app/service_locator.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({
    Key key,
    @required this.builder,
    this.userProvidersBuilder,
  }) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<ApiUser>) builder;
  final List<SingleChildWidget> Function(BuildContext, ApiUser)
      userProvidersBuilder;

  @override
  Widget build(BuildContext context) {
    final PrassoApiService authService =
        Provider.of<PrassoApiService>(context, listen: false);

    return StreamBuilder<ApiUser>(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        final ApiUser user = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active &&
            !locator.isRegistered<ApiUser>()) {
          setupLoggedInUser(user);
        }

        if (user != null) {
          return MultiProvider(
            providers: userProvidersBuilder != null
                ? userProvidersBuilder(context, user)
                : [],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<
        Widget Function(
            BuildContext p1, AsyncSnapshot<ApiUser> p2)>('builder', builder));
    properties.add(DiagnosticsProperty<
            List<SingleChildWidget> Function(BuildContext p1, ApiUser p2)>(
        'userProvidersBuilder', userProvidersBuilder));
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({
    Key key,
    @required this.userSnapshot,
    @required this.signedInBuilder,
    @required this.nonSignedInBuilder,
  }) : super(key: key);
  final AsyncSnapshot<ApiUser> userSnapshot;
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData
          ? signedInBuilder(context)
          : nonSignedInBuilder(context);
    }
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AsyncSnapshot<ApiUser>>(
        'userSnapshot', userSnapshot));
    properties.add(ObjectFlagProperty<WidgetBuilder>.has(
        'nonSignedInBuilder', nonSignedInBuilder));
    properties.add(ObjectFlagProperty<WidgetBuilder>.has(
        'signedInBuilder', signedInBuilder));
  }
}
