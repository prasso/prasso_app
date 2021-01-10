import 'package:flutter/foundation.dart';
import 'package:prasso_app/app_widgets/apps/app_run_list_tile.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appRunViewModel = ChangeNotifierProvider(
    (ref) => AppRunViewModel(database: ref.read(databaseProvider)));

class AppRunViewModel extends ChangeNotifier {
  AppRunViewModel({@required this.database});
  final FirestoreDatabase database;

  Stream<List<AppModel>> get allAppRunStream => database.appsStream();

  Future<List<AppModel>> allAppRun() async {
    final List<List<AppModel>> appfuture = await allAppRunStream.toList();
    return appfuture.first;
  }

  /// Output stream
  Stream<List<AppRunListTileModel>> get dynamicTileModelStream =>
      allAppRunStream.map(_createModels);

  static List<AppRunListTileModel> _createModels(List<AppModel> allAppRun) {
    if (allAppRun.isEmpty) {
      return [];
    }

    return <AppRunListTileModel>[
      const AppRunListTileModel(
        leadingText: 'Links',
        pageTitle: 'Title',
        pageUrl: 'Action',
      ),
      for (AppModel dynamicDetails in allAppRun) ...[
        AppRunListTileModel(
            isHeader: true,
            leadingText: dynamicDetails.documentId,
            pageTitle: dynamicDetails.pageTitle,
            pageUrl: dynamicDetails.pageUrl,
            sortOrder: dynamicDetails.sortOrder),
      ]
    ];
  }
}
