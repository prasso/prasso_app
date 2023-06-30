// Flutter imports:
// Project imports:
import 'package:delegate_app/app_widgets/apps/edit_app_view_model.dart';
import 'package:delegate_app/models/app.dart';
import 'package:delegate_app/utils/prasso_themedata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditAppPage extends HookConsumerWidget {
  const EditAppPage({Key? key, this.appinfo}) : super(key: key);
  final AppModel? appinfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _viewModel = ref.watch(editAppViewModel);
    _viewModel.appInfo = appinfo;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(
            _viewModel.appInfo!.documentId == null ? 'New App' : 'Edit App',
            style: const TextStyle(color: PrassoColors.lightGray)),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _viewModel.submit,
          ),
        ],
      ),
      body: _buildContents(_viewModel),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents(EditAppViewModel _viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(_viewModel),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(EditAppViewModel _viewModel) {
    return Form(
      key: _viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(_viewModel),
      ),
    );
  }

  List<Widget> _buildFormChildren(EditAppViewModel _viewModel) {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'App name'),
        keyboardAppearance: Brightness.light,
        initialValue: _viewModel.appInfo!.pageTitle,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _viewModel.appInfo!.pageTitle = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'App Url'),
        keyboardAppearance: Brightness.light,
        initialValue: _viewModel.appInfo!.pageUrl,
        onSaved: (value) => _viewModel.appInfo!.pageUrl = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Tab Icon'),
        keyboardAppearance: Brightness.light,
        initialValue: _viewModel.appInfo!.tabIcon,
        onSaved: (value) => _viewModel.appInfo!.tabIcon = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Tab Label'),
        keyboardAppearance: Brightness.light,
        initialValue: _viewModel.appInfo!.tabLabel,
        onSaved: (value) => _viewModel.appInfo!.tabLabel = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Sort Order'),
        keyboardAppearance: Brightness.light,
        initialValue: _viewModel.appInfo!.tabLabel,
        onSaved: (value) => _viewModel.appInfo!.sortOrder = int.parse(value!),
      ),
    ];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppModel>('appinfo', appinfo));
  }
}
