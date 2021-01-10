import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final cupertinoVM = context.read(cupertinoHomeScaffoldVMProvider);
    return WillPopScope(
      onWillPop: () async => !await cupertinoVM
          .navigatorKeys[cupertinoVM.currentTab].currentState
          .maybePop(),
      child: CupertinoHomeScaffold(),
    );
  }
}
