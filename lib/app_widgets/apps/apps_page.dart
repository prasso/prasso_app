// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:prasso_app/app_widgets/apps/app_list_tile.dart';
import 'package:prasso_app/app_widgets/apps/apps_page_view_model.dart';
import 'package:prasso_app/app_widgets/apps/list_items_builder.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

class AppsPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _viewModel = ref.watch(appsPageViewModel);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Strings.apps,
            style: TextStyle(color: PrassoColors.lightGray)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () =>
                _viewModel.show(context: context, app: AppModel.empty()),
          ),
        ],
      ),
      body: _buildContents(ref, context, _viewModel),
    );
  }

  Widget _buildContents(WidgetRef ref, BuildContext context, AppsPageViewModel _viewModel) {
    final logprovider = ref.watch(loggerProvider);

    return StreamBuilder<List<AppModel>>(
      stream: _viewModel.database!.appsStream(),
      builder: (context, snapshot) {
        logprovider
            .d('Apps StreamBuilder rebuild: ${snapshot.connectionState}');
        return ListItemsBuilder<AppModel>(
          snapshot: snapshot,
          itemBuilder: (context, app) => Dismissible(
            key: Key('app-${app.documentId}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _viewModel.delete(context, app),
            child: AppListTile(
              app: app,
              onTap: () => _viewModel.show(context: context, app: app),
            ),
          ),
        );
      },
    );
  }
}
