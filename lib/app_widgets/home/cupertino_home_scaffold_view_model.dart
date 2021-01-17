// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dynamic_widget/dynamic_widget/icons_helper.dart';

// Project imports:
import 'package:prasso_app/app_widgets/account/account_page.dart';
import 'package:prasso_app/app_widgets/apps/app_run_page.dart';
import 'package:prasso_app/app_widgets/apps/app_web_view.dart';
import 'package:prasso_app/app_widgets/apps/apps_page.dart';
import 'package:prasso_app/app_widgets/more/more_page.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/tab_item.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';

class CupertinoHomeScaffoldViewModel extends ChangeNotifier {
  CupertinoHomeScaffoldViewModel(this.sharedPreferencesServiceProvider) {
    _setdefaults();
  }
  static bool isDisposed = true;
  final SharedPreferencesService sharedPreferencesServiceProvider;

  Map<TabItem, WidgetBuilder> widgetBuilders;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.position1: GlobalKey<NavigatorState>(),
    TabItem.position2: GlobalKey<NavigatorState>(),
    TabItem.position3: GlobalKey<NavigatorState>(),
    TabItem.position4: GlobalKey<NavigatorState>(),
    TabItem.positionOverflow: GlobalKey<NavigatorState>(),
  };

  final formKey = GlobalKey<FormState>();
  List<BottomNavigationBarItem> tabs;
  List<TabItemData> moreItems;
  Map<TabItem, TabItemData> allTabs;

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  factory CupertinoHomeScaffoldViewModel.initializeFromLocalStorage(
      SharedPreferencesService sharedPreferencesService) {
    final _vm = CupertinoHomeScaffoldViewModel(sharedPreferencesService);
    _vm.setProperties();
    isDisposed = false;

    return _vm;
  }

  TabItem _currentTab = TabItem.position1;

  TabItem get currentTab {
    return _currentTab;
  }

  set currentTab(TabItem newtab) {
    print('$_currentTab is changing to $newtab');
    _currentTab = newtab;
    notifyListeners();
    setProperties();
  }

  Future<bool> clear() async {
    await sharedPreferencesServiceProvider.saveAppData('');

    _setdefaults();
    return true;
  }

  void setProperties() {
    final appdata = sharedPreferencesServiceProvider.getAppData();
    if ((appdata?.isEmpty ?? true) || appdata.toString() == 'null') {
      _setdefaults();
      return;
    }
    final restoredjson = appdata.replaceAll('&quote;', '"');
    final dynamic alldata = jsonDecode(restoredjson);

    final tabslist = alldata['tabs'] as List;

    buildAllTabs(tabslist);
  }

  void _setdefaults() {
    moreItems = [];
    allTabs = {
      TabItem.position1: TabItemData(
          key: Keys.appsTab,
          title: Strings.apps,
          icon: Icons.work,
          pageUrl: 'AppsPage()',
          pageTitle: Strings.apps,
          parent: 0),
      TabItem.position2: TabItemData(
          key: Keys.asdefinedTab,
          title: Strings.appsTabTitle,
          icon: Icons.star,
          pageUrl: 'AppRunPage.create',
          pageTitle: Strings.appsTabTitle,
          parent: 0),
      TabItem.position3: TabItemData(
          key: Keys.accountTab,
          title: Strings.account,
          icon: Icons.person,
          pageUrl: 'AccountPage()',
          pageTitle: Strings.account,
          parent: 0),
    };
    widgetBuilders = {
      TabItem.position1: (_) => AppsPage(),
      TabItem.position2: (_) => AppRunPage(),
      TabItem.position3: (_) => AccountPage(),
      TabItem.position4: (_) => AppRunWebView(title: '', selectedUrl: ''),
      TabItem.positionOverflow: (_) =>
          AppRunWebView(title: '', selectedUrl: ''),
    };
    buildTabs(tryagain: false);
  }

  void buildTabs({bool tryagain}) {
    try {
      final List<BottomNavigationBarItem> rt = [];
      allTabs.forEach((key, value) {
        if (value.parent == 0) {
          rt.add(_buildItem(key, value));
        }
      });
      tabs = rt;
    } catch (e) {
      if (tryagain) {
        _setdefaults();
      }
    }
    notifyListeners();
  }

  void select(BuildContext context, int index, TabItem tabItem) {
    if (tabItem == currentTab) {
      // pop to first route
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      currentTab = tabItem;
    }
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem, TabItemData itemData) {
    final color = _currentTab == tabItem ? Colors.orange : Colors.grey;

    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        color: color,
      ),
      // ignore: deprecated_member_use
      title: Text(
        itemData.title,
        key: Key(itemData.key),
        style: TextStyle(color: color),
      ),
    );
  }

  void buildAllTabs(List tabsFromAPI) {
    allTabs.clear();
    moreItems = [];

    for (int i = 0; i < tabsFromAPI.length; i++) {
      final TabItemData t1 = TabItemData(
        key: tabsFromAPI[i]['id'].toString(),
        title: tabsFromAPI[i]['label'],
        icon: getIconUsingPrefix(name: tabsFromAPI[i]['icon']),
        pageUrl: tabsFromAPI[i]['page_url'],
        pageTitle: tabsFromAPI[i]['page_title'],
        sortOrder: tabsFromAPI[i]['sort_order'].toString(),
        parent: tabsFromAPI[i]['parent'],
      );

      final int position = allTabs.length;
      if (position <= TabItem.values.length && t1.parent == 0) {
        allTabs[TabItem.values[position]] = t1;

        widgetBuilders[TabItem.values[position]] = actionFromString(t1);
      }
      if (t1.parent > 0) {
        moreItems.add(t1);
      }
    }

    buildTabs(tryagain: true);
  }

  WidgetBuilder actionFromString(TabItemData t1) {
    final String actionString = t1.pageUrl;
    // if pageurl isn't https it is a page in this code
    if (actionString.startsWith('http')) {
      return (_) => AppRunWebView(title: t1.title, selectedUrl: actionString);
    } else {
      if (actionString == 'AccountPage()') {
        return (_) => AccountPage();
      } else {
        if (actionString == 'More()') {
          return (_) => MorePage();
        } else {
          if (actionString == 'AppsPage()') {
            return (_) => AppsPage();
          } else {
            if (actionString == 'AppRunPage.create') {
              return (_) => AppRunPage();
            }
          }
        }
      }
    }
    return null;
  }

  void navigateToMoreItem(int index, BuildContext context) {
    final TabItemData t1 = moreItems[index];
    Navigator.push<MaterialPageRoute>(
      context,
      MaterialPageRoute(
        builder: actionFromString(t1),
      ),
    );
  }
}
