import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prasso_app/models/tab_item.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/routing/cupertino_tab_view_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';

@immutable
class CupertinoHomeScaffold extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final cupertinoVM = watch(cupertinoHomeScaffoldVMProvider);
    return Consumer(builder: (context, watch, child) {
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            activeColor: Colors.orange,
            inactiveColor: Colors.grey,
            key: const Key(Keys.tabBar),
            items: cupertinoVM.tabs,
            onTap: (index) =>
                cupertinoVM.select(context, index, TabItem.values[index]),
          ),
          tabBuilder: (context, index) {
            final item = TabItem.values[index];
            return CupertinoTabView(
              navigatorKey: cupertinoVM.navigatorKeys[item],
              builder: (context) => cupertinoVM.widgetBuilders[item](context),
              onGenerateRoute: CupertinoTabViewRouter.generateRoute,
            );
          });
    });
  }
}
