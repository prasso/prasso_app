import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:prasso_app/app_widgets/apps/edit_app_page.dart';
import 'package:prasso_app/app_widgets/apps/app_list_tile.dart';
import 'package:prasso_app/app_widgets/apps/list_items_builder.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:pedantic/pedantic.dart';

class AppsPage extends StatefulWidget {
  @override
  _AppsPageState createState() => _AppsPageState();

  static Future<void> show({BuildContext context, AppModel app}) async {
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
      builder: (context) => EditAppPage(app: app),
      fullscreenDialog: true,
    ));
  }
}

class _AppsPageState extends State<AppsPage> {
  Stream<List<AppModel>> _appsStream;

  @override
  void initState() {
    super.initState();
    final database = context.read<FirestoreDatabase>();
    _appsStream = database.appsStream();
  }

  Future<void> _delete(AppModel app) async {
    try {
      final database = context.read<FirestoreDatabase>();
      await database.deleteApp(app);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.apps),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => EditAppPage.show(context),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<AppModel>>(
      stream: _appsStream,
      builder: (context, snapshot) {
        context
            .watch<Logger>()
            .d('Apps StreamBuilder rebuild: ${snapshot.connectionState}');
        return ListItemsBuilder<AppModel>(
          snapshot: snapshot,
          itemBuilder: (context, app) => Dismissible(
            key: Key('app-${app.documentId}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(app),
            child: AppListTile(
              app: app,
              onTap: () => AppsPage.show(context: context, app: app),
            ),
          ),
        );
      },
    );
  }
}
