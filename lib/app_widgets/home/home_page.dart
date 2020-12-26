import 'package:flutter/foundation.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/models/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold.dart';
import 'package:prasso_app/service_locator.dart';

class HomePage extends StatefulWidget {
  HomePage() {
    setupLocator();
  }
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.position1: GlobalKey<NavigatorState>(),
    TabItem.position2: GlobalKey<NavigatorState>(),
    TabItem.position3: GlobalKey<NavigatorState>(),
    TabItem.position4: GlobalKey<NavigatorState>(),
    TabItem.positionOverflow: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[
              locator<CupertinoHomeScaffoldViewModel>().currentTab]
          .currentState
          .maybePop(),
      child: CupertinoHomeScaffold(
        widgetBuilders:
            locator<CupertinoHomeScaffoldViewModel>().widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<TabItem, GlobalKey<NavigatorState>>>(
        'navigatorKeys', navigatorKeys));
  }
}
