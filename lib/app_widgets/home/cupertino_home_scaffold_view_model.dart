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
import 'package:prasso_app/app_widgets/apps/app_pdf_view.dart';
import 'package:prasso_app/app_widgets/apps/app_run_page.dart';
import 'package:prasso_app/app_widgets/apps/app_web_view.dart';
import 'package:prasso_app/app_widgets/apps/apps_page.dart';
import 'package:prasso_app/app_widgets/more/more_page.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/tab_item.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

class CupertinoHomeScaffoldViewModel extends ChangeNotifier {
  CupertinoHomeScaffoldViewModel(this.sharedPreferencesServiceProvider) {
    final appdata = sharedPreferencesServiceProvider.getAppData();
    if (appdata == null) {
      //new app install. we need to make sure nothing left over from
      //previous build
      return;
    }

    defaultTabsJson = appdata;
    _setdefaults();
  }
  static bool isDisposed = true;
  bool hasChangedEvent = false;
  bool isInitializing = false;

  final SharedPreferencesService sharedPreferencesServiceProvider;

  List<TabItemData> moreItems = [];
  Map<TabItem, TabItemData> allTabs = {
    TabItem.position1: TabItemData(
        key: Keys.appsTab,
        title: Strings.apps,
        icon: Icons.work,
        pageUrl: 'AppsPage()',
        pageTitle: Strings.apps,
        extraHeaderInfo: '',
        parent: 0),
    TabItem.position2: TabItemData(
        key: Keys.asdefinedTab,
        title: Strings.appsTabTitle,
        icon: Icons.star,
        pageUrl: 'AppRunPage.create',
        pageTitle: Strings.appsTabTitle,
        extraHeaderInfo: '',
        parent: 0),
    TabItem.position3: TabItemData(
        key: Keys.accountTab,
        title: Strings.account,
        icon: Icons.person,
        pageUrl: 'AccountPage()',
        pageTitle: Strings.account,
        extraHeaderInfo: '',
        parent: 0),
  };
  Map<TabItem, WidgetBuilder> widgetBuilders = {
    TabItem.position1: (_) => AppsPage(),
    TabItem.position2: (_) => AppRunPage(),
    TabItem.position3: (_) => AccountPage(),
    TabItem.position4: (_) => AppRunWebView(
          title: '',
          selectedUrl: '',
          extraHeaderInfo: '{}',
        ),
    TabItem.positionOverflow: (_) => AppRunWebView(
          title: '',
          selectedUrl: '',
          extraHeaderInfo: '{}',
        ),
  };

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.position1: GlobalKey<NavigatorState>(),
    TabItem.position2: GlobalKey<NavigatorState>(),
    TabItem.position3: GlobalKey<NavigatorState>(),
    TabItem.position4: GlobalKey<NavigatorState>(),
    TabItem.positionOverflow: GlobalKey<NavigatorState>(),
  };

  List<BottomNavigationBarItem> tabs = [];
  String _defaulttabsjson = Strings.emergencyDefaultTabs;

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  factory CupertinoHomeScaffoldViewModel.initializeFromLocalStorage(
      SharedPreferencesService sharedPreferencesService) {
    final _vm = CupertinoHomeScaffoldViewModel(sharedPreferencesService);
    _vm.isInitializing = true;
    isDisposed = false;
    _vm.currentTab = TabItem.position1;
    _vm.isInitializing = false;
    return _vm;
  }

  TabItem _currentTab = TabItem.position1;

  TabItem get currentTab {
    return _currentTab;
  }

  set currentTab(TabItem newtab) {
    if (defaultTabsJson == '') {
      return;
    }
    print('$_currentTab is changing to $newtab');
    _currentTab = newtab;

    if (isInitializing) {
      return;
    }
    notifyListeners();
    _setdefaults();
  }

  String get defaultTabsJson {
    return _defaulttabsjson;
  }

  //this should set to the value passed in unless it's empty
  //if passed value is empty then set to the emergency values
  set defaultTabsJson(String newtabsJson) {
    if ((newtabsJson?.isEmpty ?? true) || newtabsJson.toString() == 'null') {
      _defaulttabsjson = Strings.emergencyDefaultTabs;
    } else {
      _defaulttabsjson = newtabsJson;
    }
  }

  Future<bool> signingout() async {
    _currentTab = TabItem.position1;
    return true;
  }

  Future<bool> clear() async {
    await sharedPreferencesServiceProvider.saveAppData('');

    _setdefaults();

    _currentTab = TabItem.position1;
    return true;
  }

  void _setdefaults() {
    if (isInitializing || defaultTabsJson == '') {
      return;
    }
    final dynamic alldata = jsonDecode(defaultTabsJson);
    final tabslist = alldata['tabs'] as List;
    buildAllTabs(tabslist);
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
    final color =
        _currentTab == tabItem ? PrassoColors.brightBlue : Colors.grey;

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
        key: UniqueKey().toString(),
        title: tabsFromAPI[i]['label'],
        icon: getIconUsingPrefix(name: tabsFromAPI[i]['icon']),
        pageUrl: tabsFromAPI[i]['page_url'],
        pageTitle: tabsFromAPI[i]['page_title'],
        extraHeaderInfo: tabsFromAPI[i]['request_header'],
        sortOrder: tabsFromAPI[i]['sort_order'],
        parent: (tabsFromAPI[i]['page_url'] == Strings.morePageUrl)
            ? 0
            : tabsFromAPI[i]['parent'],
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
    final String extraHeaderInfo = t1.extraHeaderInfo;

    // if pageurl isn't https it is a page in this code
    if (actionString.startsWith('http')) {
      if (actionString.endsWith('.pdf')) {
        return (_) => AppRunPdfView(title: t1.title, urlPDFPath: actionString);
      } else {
        return (_) => AppRunWebView(
              title: t1.title,
              selectedUrl: actionString,
              extraHeaderInfo: extraHeaderInfo,
            );
      }
    } else {
      if (actionString == Strings.accountPageUrl) {
        return (_) => AccountPage();
      } else {
        if (actionString == Strings.morePageUrl) {
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
