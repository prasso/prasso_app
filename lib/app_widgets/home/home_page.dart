import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold.dart';

class HomePage extends ConsumerWidget {
  const HomePage();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final cupertinoVM = watch(cupertinoHomeScaffoldVMProvider);
    return WillPopScope(
      onWillPop: () async => !await cupertinoVM
          .navigatorKeys[cupertinoVM.currentTab].currentState
          .maybePop(),
      child: const CupertinoHomeScaffold(),
    );
  }
}
