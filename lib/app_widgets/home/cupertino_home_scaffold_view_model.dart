// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Project imports:
import 'package:prasso_app/app_widgets/account/account_page.dart';
import 'package:prasso_app/app_widgets/apps/app_pdf_view.dart';
import 'package:prasso_app/app_widgets/apps/app_web_view.dart';
import 'package:prasso_app/app_widgets/more/more_page.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/tab_item.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';
// Package imports:
import 'package:prasso_app/utils/icons_helper.dart';

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
  bool doBuildTabs = false;

  final CupertinoTabController tabController = CupertinoTabController();
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
        iconImageFileName: 'add_circle',
        isActive: true,
        sortOrder: 1,
        parent: 0,
        subscriptionRequired: false),
    TabItem.position2: TabItemData(
        key: Keys.asdefinedTab,
        title: Strings.appsTabTitle,
        icon: Icons.star,
        pageUrl: 'AppRunPage.create',
        pageTitle: Strings.appsTabTitle,
        extraHeaderInfo: '',
        iconImageFileName: 'add_circle',
        isActive: true,
        sortOrder: 1,
        parent: 0,
        subscriptionRequired: false),
    TabItem.position3: TabItemData(
        key: Keys.accountTab,
        title: Strings.account,
        icon: Icons.person,
        pageUrl: 'AccountPage()',
        pageTitle: Strings.account,
        extraHeaderInfo: '',
        iconImageFileName: 'add_circle',
        isActive: true,
        sortOrder: 1,
        parent: 0,
        subscriptionRequired: false),
  };
  Map<TabItem, WidgetBuilder?> widgetBuilders = {
    TabItem.position1: (_) => AccountPage(),
    TabItem.position2: (_) => AccountPage(),
    TabItem.position3: (_) => AccountPage(),
    TabItem.position4: (_) => AppRunWebView(
          title: '',
          selectedUrl: '',
          extraHeaderInfo: '{}',
          sharedPreferencesServiceProvider: null,
        ),
    TabItem.positionOverflow: (_) => AppRunWebView(
          title: '',
          selectedUrl: '',
          extraHeaderInfo: '{}',
          sharedPreferencesServiceProvider: null,
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
  String? _defaulttabsjson = Strings.emergencyDefaultTabs;

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

//this method is called on the notification process of app changes
//dont set the current tab if we are in IntroPage or if the current tab is a
//already equal to the new tab
  set currentTab(TabItem newtab) {
    if (defaultTabsJson == '') {
      return;
    }
    if (_currentTab == newtab && !doBuildTabs) {
      tabController.index = _currentTab.index;
      return;
    }
    print('$_currentTab is changing to $newtab');
    _currentTab = newtab;

    if (isInitializing) {
      return;
    }

    allTabs.forEach((key, value) {
      if (key == newtab) {
        value.isActive = true;
      } else {
        value.isActive = false;
      }
    });

    tabController.index = _currentTab.index;

    notifyListeners();
    if (doBuildTabs) {
      doBuildTabs = false;
      _setdefaults();
    }
  }

  String? get defaultTabsJson {
    return _defaulttabsjson;
  }

  bool get isDashboard {
    if (tabController.index < 2) {
      return true;
    }
    return false;
  }

  //this should set to the value passed in unless it's empty
  //if passed value is empty then set to the emergency values
  set defaultTabsJson(String? newtabsJson) {
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

  Future<bool> goToDashboard(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 100));

    // this takes you all the way back to login page
    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.isFirst);
    await Future.delayed(const Duration(milliseconds: 100));

    //now change to Dashboard tab, using the property here to get the notifications out
    doBuildTabs = true;
    currentTab = TabItem.position1;
    return true;
  }

  ///
  /// This method is called when the user clicks on a link text view from many screens
  /// It will open the link in a new tab
  Future<bool> showWebViewWithUrl(String pageTitle, String pageUrl,
      String extraHeaderInfo, BuildContext context) async {
    //show the webview with this url.
    await Navigator.of(context).push<String>(MaterialPageRoute<String>(
        builder: (dynamic context) => AppRunWebView(
              title: pageTitle,
              selectedUrl: pageUrl,
              extraHeaderInfo: extraHeaderInfo,
              sharedPreferencesServiceProvider:
                  sharedPreferencesServiceProvider,
            )));
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
    final dynamic alldata = jsonDecode(defaultTabsJson!);
    final tabslist = List.from(alldata['tabs']);
    buildAllTabs(tabslist);
  }

  void buildTabs({bool? tryagain}) {
    try {
      final List<BottomNavigationBarItem> rt = [];
      allTabs.forEach((key, value) {
        if (value.parent == 0) {
          rt.add(_buildItem(key, value));
        }
      });
      tabs = rt;
    } catch (e) {
      if (tryagain!) {
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
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
      ),
      label: itemData.title,
    );
  }

  void buildAllTabs(List<dynamic> tabsFromAPI) {
    allTabs.clear();
    moreItems = [];

    for (int i = 0; i < tabsFromAPI.length; i++) {
      final TabItemData t1 = TabItemData(
          key: UniqueKey().toString(),
          title: tabsFromAPI[i]['label'],
          icon: getIconUsingPrefix(name: tabsFromAPI[i]['icon']),
          iconImageFileName: tabsFromAPI[i]['icon'],
          pageUrl: tabsFromAPI[i]['page_url'],
          pageTitle: tabsFromAPI[i]['page_title'],
          extraHeaderInfo: tabsFromAPI[i]['request_header'],
          isActive: true,
          sortOrder: tabsFromAPI[i]['sort_order'],
          parent: (tabsFromAPI[i]['page_url'] == Strings.morePageUrl)
              ? 0
              : tabsFromAPI[i]['parent'],
          subscriptionRequired: false

          //         fill these in
/*
      @required this.iconImageFileName,
      @required this.isActive,
      @required this.subscriptionRequired});*/
          );

      final int position = allTabs.length;
      /*if (position <= TabItem.values.length && t1.parent == 0) {
        if ((position > 3 && t1.pageUrl != Strings.morePageUrl) || t1.parent! > 0) {
          moreItems.add(t1);
        } else {
          allTabs[TabItem.values[position]] = t1;
          widgetBuilders[TabItem.values[position]] = _actionFromString(t1);
        }

      }*/
      if (position <= TabItem.values.length && t1.parent == 0) {
        allTabs[TabItem.values[position]] = t1;

        widgetBuilders[TabItem.values[position]] = _actionFromString(t1);
      }
      if (t1.parent != 0) {
        moreItems.add(t1);
      }
    }

    buildTabs(tryagain: true);
  }

  WidgetBuilder? _actionFromString(TabItemData t1) {
    final String actionString = t1.pageUrl!;
    final String? extraHeaderInfo = t1.extraHeaderInfo;

    //filter out the known links ( links that are pointing to native views)
    //if not a known link then do the web view action

    if (actionString == Strings.accountPageUrl) {
      return (_) => AccountPage();
    }
    if (actionString == Strings.morePageUrl) {
      return (_) => MorePage();
    }

    if (actionString.startsWith('http')) {
      if (actionString.endsWith('.pdf')) {
        return (_) => AppRunPdfView(title: t1.title, urlPDFPath: actionString);
      } else {
        return (_) => AppRunWebView(
              title: t1.title,
              selectedUrl: actionString,
              extraHeaderInfo: extraHeaderInfo,
              sharedPreferencesServiceProvider:
                  sharedPreferencesServiceProvider,
            );
      }
    }
    return null;
  }

  void navigateToMoreItem(int index, BuildContext context) {
    final TabItemData t1 = moreItems[index];
    // ignore: strict_raw_type
    Navigator.push<MaterialPageRoute>(
      context,
      MaterialPageRoute(
        builder: _actionFromString(t1)!,
      ),
    );
  }

  void buildTabsFromStorage() {
    final appdata = sharedPreferencesServiceProvider.getAppData();
    if (appdata == null || appdata == 'null') {
      try {
        final prassoApiRepository = PrassoApiRepository.instance;
        final user = prassoApiRepository.currentUser;

        prassoApiRepository.getAppConfig(user);
      } catch (e) {
        showErrorToast(Strings.refreshFailed);
      }
    }
  }
}
