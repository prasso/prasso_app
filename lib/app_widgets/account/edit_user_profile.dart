import 'package:flutter/foundation.dart';
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prasso_app/constants/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditUserProfile extends HookWidget {
  const EditUserProfile({Key key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
      builder: (context) => const EditUserProfile(),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final _viewmodel = useProvider(editUserProfileViewModel);

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(_viewmodel.usr == null ? 'New User' : 'Edit User'),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _viewmodel.submit(context),
          ),
        ],
      ),
      body: _buildContents(_viewmodel, context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents(
      EditUserProfileViewModel _viewmodel, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(_viewmodel, context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(EditUserProfileViewModel _viewmodel, BuildContext context) {
    return Form(
      key: _viewmodel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(_viewmodel, context),
      ),
    );
  }

  List<Widget> _buildFormChildren(
      EditUserProfileViewModel _viewmodel, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double algo = screenWidth / perfectWidth;

    return [
      Stack(
        children: [
          Opacity(
            opacity: _viewmodel.uploadingDp ? 0.5 : 1.0,
            child: Hero(
              tag: 'myProfile',
              child: CircleAvatar(
                radius: algo * 120.0,
                backgroundColor: Colors.white,
                backgroundImage: _viewmodel.profileImage,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: _viewmodel.uploadingDp
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Container(),
            ),
          ),
          Positioned(
            bottom: algo * 5.0,
            right: algo * 10.0,
            child: GestureDetector(
              onTap: () {
                _viewmodel.pickImage(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: algo * 30.0,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.blueGrey,
                  size: algo * 33.0,
                ),
              ),
            ),
          )
        ],
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Email'),
        keyboardAppearance: Brightness.light,
        initialValue: _viewmodel.email,
        validator: (value) => value.isNotEmpty ? null : 'Email can\'t be empty',
        onSaved: (value) => _viewmodel.email = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Photo Url'),
        keyboardAppearance: Brightness.light,
        initialValue: _viewmodel.photoURL,
        onSaved: (value) => _viewmodel.photoURL = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Name'),
        keyboardAppearance: Brightness.light,
        initialValue: _viewmodel.displayName,
        onSaved: (value) => _viewmodel.displayName = value,
      ),
    ];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
        'editUserProfileViewModel', editUserProfileViewModel));
  }
}
