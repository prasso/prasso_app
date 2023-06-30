// Flutter imports:
// Project imports:
import 'package:delegate_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:delegate_app/app_widgets/top_level_providers.dart';
import 'package:delegate_app/models/tab_item.dart';
import 'package:delegate_app/routing/cupertino_tab_view_router.dart';
import 'package:delegate_app/routing/router.dart';
import 'package:delegate_app/utils/prasso_themedata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      setState(() {});
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
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed(
              Routes.emailPasswordSignInPage,
              arguments: () => Navigator.of(context).pop(),
            );
          });
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
      return const Scaffold(
          body: Center(
              child: Padding(
        padding: EdgeInsets.all(28.0),
        child: Text(
          'A default app may not be setup for this login yet. If you have setup your app, please contact support. Otherwise, please restart this app.',
          style: TextStyle(
            fontSize: 24.0,
            color: PrassoColors.primary,
          ),
        ),
      )));
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<CupertinoHomeScaffoldViewModel>('vm', vm));
  }
}
