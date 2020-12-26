import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:prasso_app/app_widgets/apps/app_run_list_tile.dart';
import 'package:prasso_app/app_widgets/apps/app_run_view_model.dart';
import 'package:prasso_app/app_widgets/apps/list_items_builder.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/services/firestore_database.dart';

class AppRunPage extends StatefulWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return Provider<AppRunViewModel>(
      create: (_) => AppRunViewModel(database: database),
      child: AppRunPage(),
    );
  }

  @override
  _AppRunPageState createState() => _AppRunPageState();
}

class _AppRunPageState extends State<AppRunPage> {
  Stream<List<AppRunListTileModel>> _dynamicTileModelStream;

  @override
  void initState() {
    super.initState();
    final vm = context.read<AppRunViewModel>();
    _dynamicTileModelStream = vm.dynamicTileModelStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.dynamicPageTitle),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<AppRunListTileModel>>(
      stream: _dynamicTileModelStream,
      builder: (context, snapshot) {
        context
            .watch<Logger>()
            .d('AppRun StreamBuilder rebuild: ${snapshot.connectionState}');
        return ListItemsBuilder<AppRunListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => AppRunListTile(model: model),
        );
      },
    );
  }
}
