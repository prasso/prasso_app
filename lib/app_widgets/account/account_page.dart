// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:prasso_app/app_widgets/account/edit_user_profile.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/common_widgets/avatar.dart';
import 'package:prasso_app/common_widgets/custom_buttons.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/routing/router.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends HookConsumerWidget {
  Future<void> _signOut(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferencesService sharedPreferencesServiceProvider =
        SharedPreferencesService(prefs);
    try {
      await sharedPreferencesServiceProvider.saveUserToken('');
      await sharedPreferencesServiceProvider.setthirdPartyToken('');
      await PrassoApiRepository.instance.signOut();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context, rootNavigator: true).pushNamed(
          Routes.emailPasswordSignInPage,
          arguments: () => Navigator.of(context).pop(),
        );
      });
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e,
      ));
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    //if the user is already null, don't confirm, just go to signin screen
    if (PrassoApiRepository.instance.currentUser != null) {
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
  }

  static Future<void> _showProfileEditor(
      BuildContext context, ApiUser? user) async {
    await Navigator.of(context)
        .push<MaterialPageRoute<String>>(MaterialPageRoute<EditUserProfile>(
      builder: (dynamic context) => const EditUserProfile(),
      fullscreenDialog: true,
    ) as Route<MaterialPageRoute<String>>);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(prassoApiService);
    final user = authService?.currentUser;
    return Scaffold(
      appBar: AppBar(
          title: const Text(Strings.accountPage,
              style: TextStyle(color: PrassoColors.lightGray)),
          actions: <Widget>[
            const SizedBox(height: 8),
            TextButton(
              key: const Key(Keys.logout),
              child: const Text(
                Strings.logout,
                style: TextStyle(
                  fontSize: 18.0,
                  color: PrassoColors.lightGray,
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

  Widget _buildUserInfo(BuildContext context, ApiUser? user) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Avatar(
              photoUrl: user?.photoURL,
              radius: 50,
              borderColor: Colors.black54,
              borderWidth: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user?.displayName ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          user?.email ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomRaisedButton(
            color: PrassoColors.olive,
            onPressed: () => _showProfileEditor(context, user),
            child: SizedBox(
                child: Text(
              Strings.shortEditProfileText,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),
            )),
          ),
        ),
        TextButton(
          child: const Text(
            Strings.editProfileText,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          onPressed: () => _showProfileEditor(context, user),
        ),
      ],
    );
  }
}
