// Flutter imports:
// Project imports:
import 'package:delegate_app/app_widgets/home/cupertino_home_scaffold.dart';
import 'package:delegate_app/app_widgets/top_level_providers.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cupertinoVM = ref.watch(cupertinoHomeScaffoldVMProvider);

    return WillPopScope(
      onWillPop: () async => !await cupertinoVM
          .navigatorKeys[cupertinoVM.currentTab]!.currentState!
          .maybePop(),
      child: const CupertinoHomeScaffold(),
    );
  }
}
