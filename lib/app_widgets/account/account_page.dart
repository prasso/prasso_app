import 'dart:async';

import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/app_widgets/account/edit_user_profile.dart';
import 'package:prasso_app/common_widgets/avatar.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/service_locator.dart';
import 'package:prasso_app/services/prasso_api_service.dart';
import 'package:provider/provider.dart';
import 'package:pedantic/pedantic.dart';

class AccountPage extends StatelessWidget {
  // for reloading config after it changes
  Future<void> _reloadConfig(BuildContext context) async {
    try {
      final PrassoApiService auth =
          Provider.of<PrassoApiService>(context, listen: false);

      await auth.getAppConfig(context);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.refreshFailed,
        exception: e,
      ));
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final PrassoApiService auth =
          Provider.of<PrassoApiService>(context, listen: false);
      await auth.signOut();

      await locator.reset(dispose: true);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e,
      ));
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: Strings.logout,
          content: Strings.logoutAreYouSure,
          cancelActionText: Strings.cancel,
          defaultActionText: Strings.logout,
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context);
    }
  }

  static Future<void> _showProfileEditor(
      BuildContext context, ApiUser user) async {
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
      builder: (context) => EditUserProfile(usr: user),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ApiUser>(context);

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.accountPage), actions: <Widget>[
        const SizedBox(height: 8),
        TextButton(
          key: const Key(Keys.reload),
          child: const Text(
            Strings.reload,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          onPressed: () => _reloadConfig(context),
        ),
        TextButton(
          key: const Key(Keys.logout),
          child: const Text(
            Strings.logout,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          onPressed: () => _confirmSignOut(context),
        ),
      ]),
      body: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: _buildUserInfo(context, user),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, ApiUser user) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Avatar(
              photoUrl: user.photoURL,
              radius: 50,
              borderColor: Colors.black54,
              borderWidth: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: const TextStyle(color: Colors.black),
          ),
        const SizedBox(height: 8),
        if (user.email != null)
          Text(
            user.email,
            style: const TextStyle(color: Colors.black),
          ),
        const SizedBox(height: 8),
        FlatButton(
          child: const Text(
            'Edit Profile',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          onPressed: () => _showProfileEditor(context, user),
        ),
      ],
    );
  }
}
