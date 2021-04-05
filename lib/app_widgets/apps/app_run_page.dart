// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:prasso_app/app_widgets/apps/app_run_list_tile.dart';
import 'package:prasso_app/app_widgets/apps/app_run_view_model.dart';
import 'package:prasso_app/app_widgets/apps/list_items_builder.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/constants/strings.dart';

class AppRunPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = useProvider(appRunViewModel);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.dynamicPageTitle),
        elevation: 2.0,
      ),
      body: _buildContents(context, _viewModel),
    );
  }

  Widget _buildContents(BuildContext context, AppRunViewModel _viewModel) {
    final logprovider = useProvider(loggerProvider);
    return StreamBuilder<List<AppRunListTileModel>>(
      stream: _viewModel.dynamicTileModelStream,
      builder: (dynamic context, dynamic snapshot) {
        logprovider
            .d('AppRun StreamBuilder rebuild: ${snapshot.connectionState}');
        return ListItemsBuilder<AppRunListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => AppRunListTile(model: model),
        );
      },
    );
  }
}
