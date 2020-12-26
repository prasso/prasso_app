import 'package:flutter/foundation.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/models/tab_item.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/routing/cupertino_tab_view_router.dart';
import 'package:prasso_app/service_locator.dart';
import 'package:provider/provider.dart';

@immutable
class CupertinoHomeScaffold extends StatefulWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final Map<TabItem, WidgetBuilder> widgetBuilders;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  CupertinoHomeScaffoldPageState createState() =>
      // ignore: no_logic_in_create_state
      CupertinoHomeScaffoldPageState(
          widgetBuilders: widgetBuilders, navigatorKeys: navigatorKeys);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<TabItem, GlobalKey<NavigatorState>>>(
        'navigatorKeys', navigatorKeys));
    properties.add(DiagnosticsProperty<Map>('widgetBuilders', widgetBuilders));
  }
}

class CupertinoHomeScaffoldPageState extends State<CupertinoHomeScaffold> {
  CupertinoHomeScaffoldPageState({
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  });

  final CupertinoTabController _controller = CupertinoTabController();

  final Map<TabItem, WidgetBuilder> widgetBuilders;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  void _select(int index, TabItem tabItem) {
    if (tabItem == locator<CupertinoHomeScaffoldViewModel>().currentTab) {
      // pop to first route
      setState(() => navigatorKeys[tabItem]
          .currentState
          .popUntil((route) => route.isFirst));
    } else {
      setState(
          () => locator<CupertinoHomeScaffoldViewModel>().currentTab = tabItem);
    }
  }

  @override
  void initState() {
    locator<CupertinoHomeScaffoldViewModel>().setProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CupertinoHomeScaffoldViewModel>(
        create: (context) => locator<CupertinoHomeScaffoldViewModel>(),
        child: Consumer<CupertinoHomeScaffoldViewModel>(
            builder: (context, model, child) => CupertinoTabScaffold(
                  tabBar: CupertinoTabBar(
                    key: const Key(Keys.tabBar),
                    items: locator<CupertinoHomeScaffoldViewModel>().tabs,
                    onTap: (index) => _select(index, TabItem.values[index]),
                  ),
                  tabBuilder: (context, index) {
                    final item = TabItem.values[index];
                    return CupertinoTabView(
                      navigatorKey: navigatorKeys[item],
                      builder: (context) => widgetBuilders[item](context),
                      onGenerateRoute: CupertinoTabViewRouter.generateRoute,
                    );
                  },
                )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map>('widgetBuilders', widgetBuilders));
    properties.add(DiagnosticsProperty<Map<TabItem, GlobalKey<NavigatorState>>>(
        'navigatorKeys', navigatorKeys));
  }
}
