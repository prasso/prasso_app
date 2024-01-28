// Flutter imports:
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/models/tab_item.dart';
import 'package:prasso_app/routing/cupertino_tab_view_router.dart';
import 'package:prasso_app/routing/router.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widgets/alert_dialogs.dart';
import '../../constants/keys.dart';
import '../../constants/strings.dart';
import '../../services/prasso_api_repository.dart';
import '../../services/shared_preferences_service.dart';

@immutable
class CupertinoHomeScaffold extends StatefulHookConsumerWidget {
  const CupertinoHomeScaffold({Key? key}) : super(key: key);

  @override
  CupertinoHomeScaffoldPageState createState() =>
      CupertinoHomeScaffoldPageState();
}

class CupertinoHomeScaffoldPageState
    extends ConsumerState<CupertinoHomeScaffold> {
  CupertinoHomeScaffoldPageState();
  CupertinoHomeScaffoldViewModel? vm;
  static bool isNavigatingToLogin = false;

  void _select(CupertinoHomeScaffoldViewModel vm, int index, TabItem tabItem) {
    if (tabItem == vm.currentTab) {
      // pop to first route
      if (mounted) {
        setState(() => vm.navigatorKeys[tabItem]!.currentState!
            .popUntil((route) => route.isFirst));
      }
    } else {
      if (mounted) {
        setState(() => vm.currentTab = tabItem);
      }
    }
  }

  /// onChangedApplication is here to update the tabs when the user changes Jan18
  void _onChangedApplication() {
    if (mounted) {
      setState(() {
        isNavigatingToLogin = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    vm?.removeListener(_onChangedApplication);
    vm?.hasChangedEvent = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isNavigatingToLogin) return blankScreen();

    final authService = ref.read(prassoApiService);
    final usr = authService?.currentUser;

    if (usr == null) {
      if (authService != null && authService.userIsRegistering) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed(
            Routes.introPages,
            arguments: () => Navigator.of(context).pop(),
          );
        });
      } else {
        if (Navigator.of(context).canPop()) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .pop(); // Takes you back to the sign-in screen.
          });
        } else {
          isNavigatingToLogin = true;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed(
              Routes.emailPasswordSignInPage,
              arguments: () => Navigator.of(context).pop(),
            );
          });

          return Container();
        }
      }
    }

    //if we haven't transitioned to the sign in screen after loading the user
    //then we need to make sure the tabs are built
    vm = ref.watch(cupertinoHomeScaffoldVMProvider);

    if (!vm!.hasChangedEvent) {
      vm!.addListener(_onChangedApplication);
      vm!.hasChangedEvent = true;
    }

    if (vm!.tabs.length < 2) {
      return blankScreen();
    }

    return CupertinoTabScaffold(
      controller: vm!.tabController,
      tabBar: CupertinoTabBar(
        items: vm!.tabs,
        inactiveColor: Colors.grey,
        activeColor: PrassoColors.brightOrange,
        onTap: (index) => () {
          _select(vm!, index, TabItem.values[index]);
        },
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          // navigatorKey: vm.navigatorKeys[item],
          builder: (context) => vm!.widgetBuilders[item]!(context),
          onGenerateRoute: CupertinoTabViewRouter.generateRoute,
        );
      },
    );
  }

  Widget blankScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName,
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
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
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
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text(
            isNavigatingToLogin
                ? ' '
                : 'A default app may not be setup for this login yet. If you have setup your app, please contact support. Otherwise, please restart this app.',
            style: const TextStyle(
              fontSize: 24.0,
              color: PrassoColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<CupertinoHomeScaffoldViewModel>('vm', vm));
  }
}
