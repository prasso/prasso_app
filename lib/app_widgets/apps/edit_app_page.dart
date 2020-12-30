import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prasso_app/services/prasso_api_service.dart';
import 'package:provider/provider.dart';
import 'package:prasso_app/models/app.dart';

class EditAppPage extends StatefulWidget {
  const EditAppPage({Key key, this.app}) : super(key: key);
  final AppModel app;

  static Future<void> show(BuildContext context, {AppModel app}) async {
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
      builder: (context) => EditAppPage(app: app),
      fullscreenDialog: true,
    ));
  }

  @override
  _EditAppPageState createState() => _EditAppPageState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppModel>('app', app));
  }
}

class _EditAppPageState extends State<EditAppPage> {
  final _formKey = GlobalKey<FormState>();

  AppModel _appInfo;

  @override
  void initState() {
    super.initState();
    if (widget.app != null) {
      _appInfo = widget.app;
    } else {
      _appInfo = AppModel.empty();
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      final PrassoApiService auth =
          Provider.of<PrassoApiService>(context, listen: false);
      await auth.updateFirebaseApps(context, _appInfo);
      //also update the API
      await auth.addApp(_appInfo);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.app == null ? 'New App' : 'Edit App'),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'App name'),
        keyboardAppearance: Brightness.light,
        initialValue: _appInfo.pageTitle,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _appInfo.pageTitle = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'App Url'),
        keyboardAppearance: Brightness.light,
        initialValue: _appInfo.pageUrl,
        onSaved: (value) => _appInfo.pageUrl = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Tab Icon'),
        keyboardAppearance: Brightness.light,
        initialValue: _appInfo.tabIcon,
        onSaved: (value) => _appInfo.tabIcon = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Tab Label'),
        keyboardAppearance: Brightness.light,
        initialValue: _appInfo.tabLabel,
        onSaved: (value) => _appInfo.tabLabel = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Sort Order'),
        keyboardAppearance: Brightness.light,
        initialValue: _appInfo.tabLabel,
        onSaved: (value) => _appInfo.sortOrder = int.parse(value),
      ),
    ];
  }
}
