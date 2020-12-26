import 'package:flutter/foundation.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/service_locator.dart';

class MorePage extends StatelessWidget {
  final CupertinoHomeScaffoldViewModel model =
      locator<CupertinoHomeScaffoldViewModel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.morePage),
      ),
      body: _buildMoreInfo(context),
    );
  }

  Widget _buildMoreInfo(BuildContext context) {
    return ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: model.moreItems.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = model.moreItems[index];

        return ListTile(
          leading: Icon(
            item.icon,
            color: Colors.grey,
          ),
          title: Text(item.pageTitle),
          subtitle: Text(item.title),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => model.navigateToMoreItem(index, context),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<CupertinoHomeScaffoldViewModel>('model', model));
  }
}
