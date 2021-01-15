import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/models/tab_item.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/routing/cupertino_tab_view_router.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';

@immutable
class CupertinoHomeScaffold extends StatefulHookWidget {
  const CupertinoHomeScaffold({Key key}) : super(key: key);

  @override
  CupertinoHomeScaffoldPageState createState() =>
      // ignore: no_logic_in_create_state
      CupertinoHomeScaffoldPageState();
}

class CupertinoHomeScaffoldPageState extends State<CupertinoHomeScaffold> {
  CupertinoHomeScaffoldPageState();

  final CupertinoTabController _controller = CupertinoTabController();

  void _select(CupertinoHomeScaffoldViewModel vm, int index, TabItem tabItem) {
    if (tabItem == vm.currentTab) {
      // pop to first route
      setState(() => vm.navigatorKeys[tabItem].currentState
          .popUntil((route) => route.isFirst));
    } else {
      setState(() => vm.currentTab = tabItem);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = useProvider(cupertinoHomeScaffoldVMProvider);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        key: const Key(Keys.tabBar),
        items: vm.tabs,
        onTap: (index) => _select(vm, index, TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: vm.navigatorKeys[item],
          builder: (context) => vm.widgetBuilders[item](context),
          onGenerateRoute: CupertinoTabViewRouter.generateRoute,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
