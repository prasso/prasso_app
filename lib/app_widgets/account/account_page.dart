// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:prasso_app/app_widgets/account/edit_user_profile.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/common_widgets/avatar.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';

class AccountPage extends HookWidget {
  // for reloading config after it changes
  Future<void> _reloadConfig(BuildContext context, ApiUser user) async {
    try {
      await PrassoApiRepository.instance.getAppConfig(user);
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
      await PrassoApiRepository.instance.signOut();
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
      builder: (dynamic context) => const EditUserProfile(),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read(prassoApiService);
    final user = authService.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.accountPage), actions: <Widget>[
        const SizedBox(height: 8),
        /*TextButton(
          key: const Key(Keys.reload),
          child: const Text(
            Strings.reload,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          onPressed: () => _reloadConfig(context, user),
        ),*/
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
        TextButton(
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
