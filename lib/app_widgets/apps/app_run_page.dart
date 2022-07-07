// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:prasso_app/app_widgets/apps/app_run_list_tile.dart';
import 'package:prasso_app/app_widgets/apps/app_run_view_model.dart';
import 'package:prasso_app/app_widgets/apps/list_items_builder.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

class AppRunPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _viewModel = ref.watch(appRunViewModel);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Strings.dynamicPageTitle,
            style: TextStyle(color: PrassoColors.lightGray)),
        elevation: 2.0,
      ),
      body: _buildContents(ref, context, _viewModel),
    );
  }

  Widget _buildContents(WidgetRef ref, BuildContext context, AppRunViewModel _viewModel) {
    final logprovider = ref.watch(loggerProvider);
    return StreamBuilder<List<AppRunListTileModel>>(
      stream: _viewModel.dynamicTileModelStream,
      builder: (context, snapshot) {
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
