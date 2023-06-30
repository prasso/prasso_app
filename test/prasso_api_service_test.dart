// Dart imports:
import 'dart:async';
import 'dart:convert';

// Project imports:
import 'package:delegate_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:delegate_app/models/api_user.dart';
import 'package:delegate_app/services/prasso_api_repository.dart';
import 'package:delegate_app/services/shared_preferences_service.dart';
// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockJsonService extends Mock implements PrassoApiRepository {}

void main() {
  group('PrassoApi tests', () {
    const String testjson =
        '{"success": true,"data": {"token": "tokenhere","name": "Test Tester","uid": 1,"email": "test@tester.com","photoURL": "https://ui-avatars.com/api/?name=Test+Tester&color=7F9CF5&background=EBF4FF","app_data": "[{\'id\':1,\'token_id\':1,\'team_id\':1,\'appicon\':\'action.svg\',\'app_name\':\'prasso\',\'page_title\':\'To Act\',\'page_url\':\'https:\\/\\/prasso.io\',\'sort_order\':1,\'created_at\':null,\'updated_at\':null,\'tabs\':[{\'id\':1,\'app_id\':1,\'icon\':\'fist.svg\',\'label\':\'team\',\'page_title\':\'Team\',\'page_url\':\'prasso.io\\/team\',\'sort_order\':1,\'created_at\':null,\'updated_at\':null},{\'id\':2,\'app_id\':1,\'icon\':\'others.svg\',\'label\':\'others\',\'page_title\':\'Others\',\'page_url\':\'prasso.io\\/others\',\'sort_order\':1,\'created_at\':null,\'updated_at\':null},{\'id\':3,\'app_id\':1,\'icon\':\'tree.svg\',\'label\':\'events\',\'page_title\':\'Events\',\'page_url\':\'prasso.io\\/events\',\'sort_order\':1,\'created_at\':null,\'updated_at\':null},{\'id\':4,\'app_id\':1,\'icon\':\'library.svg\',\'label\':\'library\',\'page_title\':\'Library\',\'page_url\':\'prasso.io\\/library\',\'sort_order\':1,\'created_at\':null,\'updated_at\':null},{\'id\':5,\'app_id\':1,\'icon\':\'more.svg\',\'label\':\'more\',\'page_title\':\'More\',\'page_url\':\'prasso.io\\/more\',\'sort_order\':1,\'created_at\':null,\'updated_at\':null}]}]"},"message": "User login successfully."}';

    late StreamController<ApiUser> onAuthStateChangedController;

    setUp(() {
      onAuthStateChangedController = StreamController<ApiUser>();
    });

    tearDown(() {
      onAuthStateChangedController.close();
    });

    void stubTabsParsingYields() {
      final dynamic data = jsonDecode(testjson);
      final appdata = data['data']['app_data'].toString();
      final dynamic alldata = jsonDecode(appdata);

      final tabslist = List.from(alldata['tabs']);

      final CupertinoHomeScaffoldViewModel model =
          CupertinoHomeScaffoldViewModel(SharedPreferencesService(null));
      model.buildAllTabs(tabslist);
    }

    testWidgets(
        'WHEN json received '
        'THEN calls builder with snapshot in waiting state'
        'AND tabs are built', (tester) async {
      stubTabsParsingYields();
    });
  });
}
