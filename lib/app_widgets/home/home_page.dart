// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';

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
